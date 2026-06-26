import '../../domain/models/contract.dart';
import '../utils/arabic_text_helpers.dart';

class HeirShare {
  final String heirId;
  final String heirName;
  final String relation;
  final int shares;
  final double fraction;
  final String fractionLabel;
  final bool isExcluded;
  final String exclusionReason;

  const HeirShare({
    required this.heirId,
    required this.heirName,
    required this.relation,
    required this.shares,
    required this.fraction,
    required this.fractionLabel,
    this.isExcluded = false,
    this.exclusionReason = '',
  });
}

class InheritanceResult {
  final List<HeirShare> shares;
  final int totalShares;
  final bool hasExcludedHeirs;
  final List<String> warnings;
  final bool isKalala;
  final bool hasPendingPregnancy;
  final String path;

  const InheritanceResult({
    required this.shares,
    required this.totalShares,
    required this.hasExcludedHeirs,
    required this.warnings,
    required this.isKalala,
    required this.hasPendingPregnancy,
    required this.path,
  });

  int get activeTotal => shares.where((s) => !s.isExcluded).fold(0, (a, b) => a + b.shares);
}

class InheritanceCalculator {
  static const int totalShares = 2400;

  InheritanceResult calculate({
    required List<Heir> heirs,
    required bool isKalala,
    required bool isAmiriaLand,
    required bool willExceedsThird,
    required bool willHasHeirConsent,
  }) {
    final warnings = <String>[];
    final excluded = <String>[];

    final activeHeirs = heirs.where((h) {
      if (h.isKiller) {
        excluded.add('${h.person.fullName}: محروم من الإرث (القاتل لا يرث)');
        return false;
      }
      if (h.isApostate) {
        excluded.add('${h.person.fullName}: محروم من الإرث (الردة مانع إرث)');
        return false;
      }
      return true;
    }).toList();

    if (activeHeirs.any((h) => h.isPregnant)) {
      warnings.add('يوجد وارث حامل – يجب تأجيل القسمة حتى الولادة');
    }
    if (activeHeirs.any((h) => h.person.isMissing)) {
      warnings.add('يوجد وارث مفقود – يُودع نصيبه أمانةً قضائية');
    }
    if (activeHeirs.any((h) => h.isPrisoner)) {
      warnings.add('يوجد وارث أسير – قد يحتاج تمثيلاً قانونياً');
    }
    if (activeHeirs.any((h) => h.isIntersex)) {
      warnings.add('يوجد وارث خنثى – يُحجز نصيب الأنثى ويُعطى الزائد بعد التحديد الطبي');
    }
    if (willExceedsThird && !willHasHeirConsent) {
      warnings.add('الوصية تتجاوز الثلث بدون موافقة الورثة – تُنفَّذ في حدود الثلث فقط');
    }

    final List<HeirShare> result;
    final String path;
    if (isAmiriaLand) {
      path = 'أميري (تساوي الذكور والإناث)';
      result = _calculateAmiria(activeHeirs);
    } else {
      path = 'شرعي (للذكر مثل حظ الأنثيين)';
      result = _calculateSharia(activeHeirs, isKalala);
    }

    if (excluded.isNotEmpty) warnings.addAll(excluded);

    return InheritanceResult(
      shares: result,
      totalShares: totalShares,
      hasExcludedHeirs: excluded.isNotEmpty,
      warnings: warnings,
      isKalala: isKalala,
      hasPendingPregnancy: activeHeirs.any((h) => h.isPregnant),
      path: path,
    );
  }

  List<HeirShare> _calculateAmiria(List<Heir> heirs) {
    if (heirs.isEmpty) return <HeirShare>[];
    final n = heirs.length;
    final base = totalShares ~/ n;
    var rem = totalShares - base * n;
    return heirs.map((h) {
      var s = base;
      if (rem > 0) { s++; rem--; }
      return HeirShare(
        heirId: h.person.id,
        heirName: h.person.fullName,
        relation: h.relation,
        shares: s,
        fraction: s / totalShares,
        fractionLabel: _simplifyFraction(s, totalShares),
      );
    }).toList();
  }

  List<HeirShare> _calculateSharia(List<Heir> heirs, bool isKalala) {
    if (heirs.isEmpty) return <HeirShare>[];

    final wives = heirs.where((h) => h.relation == 'زوجة').toList();
    final husbands = heirs.where((h) => h.relation == 'زوج').toList();
    final sons = heirs.where((h) => h.relation == 'ابن').toList();
    final daughters = heirs.where((h) => h.relation == 'ابنة').toList();
    final fathers = heirs.where((h) => h.relation == 'أب').toList();
    final mothers = heirs.where((h) => h.relation == 'أم').toList();
    final pGrandfathers = heirs.where((h) => h.relation == 'جد').toList();
    final pGrandmothers = heirs.where((h) => h.relation == 'جدة').toList();
    final fullBrothers = heirs.where((h) => h.relation == 'أخ شقيق').toList();
    final fullSisters = heirs.where((h) => h.relation == 'أخت شقيقة').toList();
    final patBrothers = heirs.where((h) => h.relation == 'أخ لأب').toList();
    final patSisters = heirs.where((h) => h.relation == 'أخت لأب').toList();
    final grandSons = heirs.where((h) => h.relation == 'ابن ابن').toList();
    final grandDaughters = heirs.where((h) => h.relation == 'بنت ابن').toList();
    final uncles = heirs.where((h) => h.relation == 'عم').toList();
    final cousinSons = heirs.where((h) => h.relation == 'ابن عم').toList();

    final allocation = <String, int>{};
    final hasDescendants = sons.isNotEmpty || daughters.isNotEmpty || grandSons.isNotEmpty || grandDaughters.isNotEmpty;
    final siblingsCount = fullBrothers.length + fullSisters.length + patBrothers.length + patSisters.length;

    var remaining = totalShares;

    if (wives.isNotEmpty) {
      final wifeTotal = hasDescendants ? totalShares ~/ 8 : totalShares ~/ 4;
      final perWife = wifeTotal ~/ wives.length;
      var wRem = wifeTotal - perWife * wives.length;
      for (var i = 0; i < wives.length; i++) {
        allocation[wives[i].person.id] = perWife + (i < wRem ? 1 : 0);
      }
      remaining -= wifeTotal;
    }

    if (husbands.isNotEmpty) {
      final husTotal = hasDescendants ? totalShares ~/ 4 : totalShares ~/ 2;
      allocation[husbands.first.person.id] = husTotal;
      remaining -= husTotal;
    }

    if (fathers.isNotEmpty && hasDescendants) {
      final fShare = totalShares ~/ 6;
      allocation[fathers.first.person.id] = fShare;
      remaining -= fShare;
    }

    if (mothers.isNotEmpty) {
      if (hasDescendants || siblingsCount >= 2) {
        final mShare = totalShares ~/ 6;
        allocation[mothers.first.person.id] = mShare;
        remaining -= mShare;
      } else {
        final mShare = totalShares ~/ 3;
        allocation[mothers.first.person.id] = mShare;
        remaining -= mShare;
      }
    }

    if (fathers.isEmpty && pGrandfathers.isNotEmpty && !hasDescendants) {
      final gfShare = totalShares ~/ 6;
      allocation[pGrandfathers.first.person.id] = gfShare;
      remaining -= gfShare;
    }

    if (mothers.isEmpty && pGrandmothers.isNotEmpty) {
      final gmShare = totalShares ~/ 6;
      allocation[pGrandmothers.first.person.id] = gmShare;
      remaining -= gmShare;
    }

    if (remaining > 0 && (sons.isNotEmpty || daughters.isNotEmpty)) {
      final effectiveMales = sons.length * 2;
      final effectiveFemales = daughters.length;
      final totalParts = effectiveMales + effectiveFemales;
      if (totalParts > 0) {
        final partValue = remaining ~/ totalParts;
        var distRem = remaining - partValue * totalParts;
        for (final s in sons) {
          var give = partValue * 2;
          if (distRem > 0) { give++; distRem--; }
          allocation[s.person.id] = (allocation[s.person.id] ?? 0) + give;
        }
        for (final d in daughters) {
          var give = partValue;
          if (distRem > 0) { give++; distRem--; }
          allocation[d.person.id] = (allocation[d.person.id] ?? 0) + give;
        }
        remaining = 0;
      }
    }

    if (remaining > 0 && sons.isEmpty && daughters.isNotEmpty && !hasDescendants) {
      if (daughters.length == 1) {
        final dShare = totalShares ~/ 2;
        allocation[daughters.first.person.id] = (allocation[daughters.first.person.id] ?? 0) + dShare;
        remaining -= dShare;
      } else {
        final dTotal = (totalShares * 2) ~/ 3;
        final perD = dTotal ~/ daughters.length;
        var dRem = dTotal - perD * daughters.length;
        for (var i = 0; i < daughters.length; i++) {
          allocation[daughters[i].person.id] = (allocation[daughters[i].person.id] ?? 0) + perD + (i < dRem ? 1 : 0);
        }
        remaining -= dTotal;
      }
    }

    if (remaining > 0 && sons.isEmpty && daughters.isEmpty) {
      final gsTotalParts = grandSons.length * 2 + grandDaughters.length;
      if (gsTotalParts > 0) {
        final partV = remaining ~/ gsTotalParts;
        var gsRem = remaining - partV * gsTotalParts;
        for (final gs in grandSons) {
          var give = partV * 2;
          if (gsRem > 0) { give++; gsRem--; }
          allocation[gs.person.id] = (allocation[gs.person.id] ?? 0) + give;
        }
        for (final gd in grandDaughters) {
          var give = partV;
          if (gsRem > 0) { give++; gsRem--; }
          allocation[gd.person.id] = (allocation[gd.person.id] ?? 0) + give;
        }
        remaining = 0;
      }
    }

    if (isKalala && remaining > 0 && fathers.isEmpty && sons.isEmpty && daughters.isEmpty) {
      final siblingsM = fullBrothers.length * 2 + fullSisters.length;
      if (siblingsM > 0) {
        final partV = remaining ~/ siblingsM;
        var sRem = remaining - partV * siblingsM;
        for (final fb in fullBrothers) {
          var give = partV * 2;
          if (sRem > 0) { give++; sRem--; }
          allocation[fb.person.id] = (allocation[fb.person.id] ?? 0) + give;
        }
        for (final fs in fullSisters) {
          var give = partV;
          if (sRem > 0) { give++; sRem--; }
          allocation[fs.person.id] = (allocation[fs.person.id] ?? 0) + give;
        }
        remaining = 0;
      } else {
        final patSibM = patBrothers.length * 2 + patSisters.length;
        if (patSibM > 0) {
          final partV = remaining ~/ patSibM;
          var pRem = remaining - partV * patSibM;
          for (final pb in patBrothers) {
            var give = partV * 2;
            if (pRem > 0) { give++; pRem--; }
            allocation[pb.person.id] = (allocation[pb.person.id] ?? 0) + give;
          }
          for (final ps in patSisters) {
            var give = partV;
            if (pRem > 0) { give++; pRem--; }
            allocation[ps.person.id] = (allocation[ps.person.id] ?? 0) + give;
          }
          remaining = 0;
        }
      }
    }

    if (remaining > 0 && uncles.isNotEmpty) {
      final perU = remaining ~/ uncles.length;
      var uRem = remaining - perU * uncles.length;
      for (var i = 0; i < uncles.length; i++) {
        allocation[uncles[i].person.id] = (allocation[uncles[i].person.id] ?? 0) + perU + (i < uRem ? 1 : 0);
      }
      remaining = 0;
    }

    if (remaining > 0 && cousinSons.isNotEmpty) {
      final perC = remaining ~/ cousinSons.length;
      var cRem = remaining - perC * cousinSons.length;
      for (var i = 0; i < cousinSons.length; i++) {
        allocation[cousinSons[i].person.id] = (allocation[cousinSons[i].person.id] ?? 0) + perC + (i < cRem ? 1 : 0);
      }
      remaining = 0;
    }

    if (remaining > 0 && fathers.isNotEmpty) {
      allocation[fathers.first.person.id] = (allocation[fathers.first.person.id] ?? 0) + remaining;
      remaining = 0;
    }

    final actualTotal = allocation.values.fold(0, (a, b) => a + b);
    if (actualTotal < totalShares && allocation.isNotEmpty) {
      final lastKey = allocation.keys.last;
      allocation[lastKey] = (allocation[lastKey] ?? 0) + (totalShares - actualTotal);
    }

    return heirs.map((h) {
      final s = allocation[h.person.id] ?? 0;
      return HeirShare(
        heirId: h.person.id,
        heirName: h.person.fullName,
        relation: h.relation,
        shares: s,
        fraction: s / totalShares,
        fractionLabel: _simplifyFraction(s, totalShares),
        isExcluded: h.isKiller || h.isApostate,
        exclusionReason: h.isKiller ? 'قاتل المورث' : h.isApostate ? 'مرتد' : '',
      );
    }).toList();
  }

  String _simplifyFraction(int numerator, int denominator) {
    if (numerator == 0) return '٠';
    if (denominator == 0) return '٠';
    var a = numerator.abs();
    var b = denominator.abs();
    while (b != 0) { final t = b; b = a % b; a = t; }
    final g = a == 0 ? 1 : a;
    final n = numerator ~/ g;
    final d = denominator ~/ g;
    if (d == 1) return ArabicTextHelpers.toArabicDigits(n);
    return '${ArabicTextHelpers.toArabicDigits(n)}/${ArabicTextHelpers.toArabicDigits(d)}';
  }
}