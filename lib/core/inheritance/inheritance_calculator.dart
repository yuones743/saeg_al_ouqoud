// ───────────────────────────────────────────────────────────────────────────────
// 📁 الملف: lib/core/inheritance/inheritance_calculator.dart
// 📦 الإصدار: 3.0.0 - المحرك الموحد
// 📋 الوصف: محرك حساب المواريث (الفرائض) - المذهب الحنفي + القانون السوري
//           يجمع بين نظام 2400 سهم (للمسائل البسيطة) والمحرك الديناميكي
//           (للمسائل المعقدة: عول، رد، حجب، تصحيح)
// ⚠️  إخلاء مسؤولية: هذه الحسابات استرشادية. يجب مراجعة محامٍ مختص
//    قبل الاعتماد القانوني الكامل.
// ───────────────────────────────────────────────────────────────────────────────

import '../../domain/models/contract.dart';
import '../utils/arabic_text_helpers.dart';

// ─── تعريفات البيانات ─────────────────────────────────────────────────────────

/// حصة وريث واحد
class HeirShare {
  final String heirId;
  final String heirName;
  final String relation;
  final int shares;
  final double fraction;
  final String fractionLabel;
  final bool isExcluded;
  final String exclusionReason;
  final String shareCategory; // فرض، تعصيب، محجوب، وصية واجبة

  const HeirShare({
    required this.heirId,
    required this.heirName,
    required this.relation,
    required this.shares,
    required this.fraction,
    required this.fractionLabel,
    this.isExcluded = false,
    this.exclusionReason = '',
    this.shareCategory = '',
  });
}

/// نتيجة المسألة كاملة
class InheritanceResult {
  final List<HeirShare> shares;
  final int totalShares;
  final int originalBaseNumber; // أصل المسألة قبل التصحيح
  final bool hasAwl;
  final bool hasRadd;
  final bool hasCorrection;
  final bool hasExcludedHeirs;
  final List<String> warnings;
  final bool isKalala;
  final bool hasPendingPregnancy;
  final String path;
  final List<String> calculationSteps; // خطوات الحساب للتوعية

  const InheritanceResult({
    required this.shares,
    required this.totalShares,
    required this.originalBaseNumber,
    this.hasAwl = false,
    this.hasRadd = false,
    this.hasCorrection = false,
    required this.hasExcludedHeirs,
    required this.warnings,
    required this.isKalala,
    required this.hasPendingPregnancy,
    required this.path,
    this.calculationSteps = const [],
  });

  int get activeTotal =>
      shares.where((s) => !s.isExcluded).fold(0, (a, b) => a + b.shares);
}

// ─── أنواع الورثة (للتصنيف الداخلي) ────────────────────────────────────────

enum _HeirCategory {
  spouse, // زوج، زوجة
  ascendant, // أب، أم، جد، جدة
  descendant, // ابن، بنت، ابن ابن، بنت ابن
  fullSibling, // أخ شقيق، أخت شقيقة
  paternalSibling, // أخ لأب، أخت لأب
  maternalSibling, // أخ لأم، أخت لأم
  paternalUncle, // عم، ابن عم
  other,
}

/// كسر لتمثيل الفروض
class _Fraction {
  final int numerator;
  final int denominator;
  const _Fraction(this.numerator, this.denominator);
  double toDouble() => denominator > 0 ? numerator / denominator : 0;
  
  static const half = _Fraction(1, 2);
  static const quarter = _Fraction(1, 4);
  static const eighth = _Fraction(1, 8);
  static const third = _Fraction(1, 3);
  static const sixth = _Fraction(1, 6);
  static const twoThirds = _Fraction(2, 3);
  
  @override
  String toString() => '$numerator/$denominator';
}

// ─── المحرك الحسابي الموحد ──────────────────────────────────────────────────

class InheritanceCalculator {
  static const int totalShares = 2400;

  // ═══════════════════════════════════════════════════════════════════════════
  // الدالة الرئيسية
  // ═══════════════════════════════════════════════════════════════════════════

  InheritanceResult calculate({
    required List<Heir> heirs,
    required bool isKalala,
    required bool isAmiriaLand,
    required bool willExceedsThird,
    required bool willHasHeirConsent,
  }) {
    final warnings = <String>[];
    final calculationSteps = <String>[];
    final excluded = <String>[];

    // 1. تصفية المحرومين
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

    // 2. تحذيرات الحالات الخاصة
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

    // 3. اختيار المسار
    final String path;
    final List<HeirShare> result;
    int originalBase = totalShares;
    bool hasAwl = false;
    bool hasRadd = false;
    bool hasCorrection = false;

    if (isAmiriaLand) {
      path = 'أميري (تساوي الذكور والإناث)';
      result = _calculateAmiria(activeHeirs);
      calculationSteps.add('أرض أميرية: توزيع بالتساوي بغض النظر عن الجنس');
    } else {
      // تحديد مدى تعقيد المسألة
      final complexity = _assessComplexity(activeHeirs, isKalala);
      
      if (complexity == _Complexity.simple || complexity == _Complexity.moderate) {
        path = 'شرعي – ٢٤٠٠ سهم (للذكر مثل حظ الأنثيين)';
        result = _calculate2400(activeHeirs, isKalala, calculationSteps);
      } else {
        path = 'شرعي – ديناميكي (أصل المسألة + ${complexity == _Complexity.awl ? "عول" : complexity == _Complexity.radd ? "رد" : "تصحيح"} )';
        final dynamicResult = _calculateDynamic(activeHeirs, isKalala, calculationSteps);
        result = dynamicResult.shares;
        originalBase = dynamicResult.baseNumber;
        hasAwl = dynamicResult.hasAwl;
        hasRadd = dynamicResult.hasRadd;
        hasCorrection = dynamicResult.hasCorrection;
      }
    }

    // 4. إضافة المحرومين
    if (excluded.isNotEmpty) warnings.addAll(excluded);

    // 5. بناء المحرومين كـ HeirShare
    final excludedShares = heirs
        .where((h) => h.isKiller || h.isApostate)
        .map((h) => HeirShare(
              heirId: h.person.id,
              heirName: h.person.fullName,
              relation: h.relation,
              shares: 0,
              fraction: 0,
              fractionLabel: '٠',
              isExcluded: true,
              exclusionReason: h.isKiller ? 'قاتل المورث' : 'مرتد',
              shareCategory: 'محروم',
            ))
        .toList();

    final allShares = [...result, ...excludedShares];

    return InheritanceResult(
      shares: allShares,
      totalShares: hasAwl || hasRadd || hasCorrection ? originalBase : totalShares,
      originalBaseNumber: originalBase,
      hasAwl: hasAwl,
      hasRadd: hasRadd,
      hasCorrection: hasCorrection,
      hasExcludedHeirs: excluded.isNotEmpty,
      warnings: warnings,
      isKalala: isKalala,
      hasPendingPregnancy: activeHeirs.any((h) => h.isPregnant),
      path: path,
      calculationSteps: calculationSteps,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // تقييم تعقيد المسألة
  // ═══════════════════════════════════════════════════════════════════════════

  _Complexity _assessComplexity(List<Heir> heirs, bool isKalala) {
    final categories = heirs.map(_classifyHeir).toSet();
    
    // مسائل العول: تجمع الفروض يتجاوز 2400
    double totalFractions = 0;
    for (final h in heirs) {
      final f = _getShareFraction(h.relation, heirs);
      totalFractions += f.toDouble();
    }
    if (totalFractions > 1.0) return _Complexity.awl;
    
    // مسائل الرد: تجمع الفروض أقل من 1 ولا يوجد عاصب
    if (totalFractions < 1.0 && !_hasAsaba(heirs)) return _Complexity.radd;
    
    // مسائل التصحيح: وجود انكسار في التوزيع
    if (_hasCorrectionNeeded(heirs)) return _Complexity.correction;
    
    // مسائل متوسطة: وجود فئات متعددة من الورثة
    if (categories.length >= 3) return _Complexity.moderate;
    
    return _Complexity.simple;
  }

  _HeirCategory _classifyHeir(Heir h) {
    final r = h.relation;
    if (r == 'زوج' || r == 'زوجة') return _HeirCategory.spouse;
    if (r == 'أب' || r == 'أم' || r == 'جد' || r == 'جدة') return _HeirCategory.ascendant;
    if (r == 'ابن' || r == 'ابنة' || r == 'ابن ابن' || r == 'بنت ابن') return _HeirCategory.descendant;
    if (r == 'أخ شقيق' || r == 'أخت شقيقة') return _HeirCategory.fullSibling;
    if (r == 'أخ لأب' || r == 'أخت لأب') return _HeirCategory.paternalSibling;
    if (r == 'أخ لأم' || r == 'أخت لأم') return _HeirCategory.maternalSibling;
    if (r == 'عم' || r == 'ابن عم') return _HeirCategory.paternalUncle;
    return _HeirCategory.other;
  }

  _Fraction _getShareFraction(String relation, List<Heir> allHeirs) {
    final hasDesc = allHeirs.any((h) => ['ابن', 'ابنة', 'ابن ابن', 'بنت ابن'].contains(h.relation));
    final sibCount = allHeirs.where((h) => ['أخ شقيق', 'أخت شقيقة', 'أخ لأب', 'أخت لأب', 'أخ لأم', 'أخت لأم'].contains(h.relation)).length;
    
    switch (relation) {
      case 'زوج': return hasDesc ? _Fraction.quarter : _Fraction.half;
      case 'زوجة': return hasDesc ? _Fraction.eighth : _Fraction.quarter;
      case 'أب': return hasDesc ? _Fraction.sixth : _Fraction(0, 1); // تعصيب
      case 'أم': return (hasDesc || sibCount >= 2) ? _Fraction.sixth : _Fraction.third;
      case 'جد': return hasDesc ? _Fraction(0, 1) : _Fraction.sixth;
      case 'جدة': return _Fraction.sixth;
      case 'ابنة': return _Fraction(0, 1); // تعصيب أو فرض
      case 'بنت ابن': return _Fraction(0, 1);
      case 'أخت شقيقة': return _Fraction(0, 1);
      case 'أخت لأب': return _Fraction(0, 1);
      case 'أخ لأم': case 'أخت لأم': return _Fraction.sixth;
      default: return _Fraction(0, 1);
    }
  }

  bool _hasAsaba(List<Heir> heirs) {
    return heirs.any((h) => ['ابن', 'ابن ابن', 'أب', 'أخ شقيق', 'أخ لأب', 'عم', 'ابن عم'].contains(h.relation));
  }

  bool _hasCorrectionNeeded(List<Heir> heirs) {
    // تبسيط: إذا كان هناك أكثر من 3 أبناء أو توزيع معقد
    final sons = heirs.where((h) => h.relation == 'ابن').length;
    final daughters = heirs.where((h) => h.relation == 'ابنة').length;
    return sons + daughters > 3;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // المسار 1: 2400 سهم ثابت
  // ═══════════════════════════════════════════════════════════════════════════

  List<HeirShare> _calculate2400(List<Heir> heirs, bool isKalala, List<String> steps) {
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

    // الزوجات
    if (wives.isNotEmpty) {
      final wifeTotal = hasDescendants ? totalShares ~/ 8 : totalShares ~/ 4;
      final perWife = wifeTotal ~/ wives.length;
      var wRem = wifeTotal - perWife * wives.length;
      for (var i = 0; i < wives.length; i++) {
        allocation[wives[i].person.id] = perWife + (i < wRem ? 1 : 0);
      }
      remaining -= wifeTotal;
      steps.add('الزوجات: ${hasDescendants ? "الثمن" : "الربع"} = $wifeTotal سهماً');
    }

    // الزوج
    if (husbands.isNotEmpty) {
      final husTotal = hasDescendants ? totalShares ~/ 4 : totalShares ~/ 2;
      allocation[husbands.first.person.id] = husTotal;
      remaining -= husTotal;
      steps.add('الزوج: ${hasDescendants ? "الربع" : "النصف"} = $husTotal سهماً');
    }

    // الأب
    if (fathers.isNotEmpty && hasDescendants) {
      final fShare = totalShares ~/ 6;
      allocation[fathers.first.person.id] = fShare;
      remaining -= fShare;
      steps.add('الأب: السدس = $fShare سهماً');
    }

    // الأم
    if (mothers.isNotEmpty) {
      if (hasDescendants || siblingsCount >= 2) {
        final mShare = totalShares ~/ 6;
        allocation[mothers.first.person.id] = mShare;
        remaining -= mShare;
        steps.add('الأم: السدس = $mShare سهماً');
      } else {
        final mShare = totalShares ~/ 3;
        allocation[mothers.first.person.id] = mShare;
        remaining -= mShare;
        steps.add('الأم: الثلث = $mShare سهماً');
      }
    }

    // الجد (إذا لم يوجد أب)
    if (fathers.isEmpty && pGrandfathers.isNotEmpty && !hasDescendants) {
      final gfShare = totalShares ~/ 6;
      allocation[pGrandfathers.first.person.id] = gfShare;
      remaining -= gfShare;
      steps.add('الجد: السدس = $gfShare سهماً');
    }

    // الجدة (إذا لم توجد أم)
    if (mothers.isEmpty && pGrandmothers.isNotEmpty) {
      final gmShare = totalShares ~/ 6;
      allocation[pGrandmothers.first.person.id] = gmShare;
      remaining -= gmShare;
      steps.add('الجدة: السدس = $gmShare سهماً');
    }

    // الأبناء والبنات (تعصيب)
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
        steps.add('الأبناء والبنات: الباقي $remaining سهماً (للذكر مثل حظ الأنثيين)');
        remaining = 0;
      }
    }

    // بنات فقط (بدون أبناء)
    if (remaining > 0 && sons.isEmpty && daughters.isNotEmpty && !hasDescendants) {
      if (daughters.length == 1) {
        final dShare = totalShares ~/ 2;
        allocation[daughters.first.person.id] = (allocation[daughters.first.person.id] ?? 0) + dShare;
        remaining -= dShare;
        steps.add('البنت الواحدة: النصف = $dShare سهماً');
      } else {
        final dTotal = (totalShares * 2) ~/ 3;
        final perD = dTotal ~/ daughters.length;
        var dRem = dTotal - perD * daughters.length;
        for (var i = 0; i < daughters.length; i++) {
          allocation[daughters[i].person.id] = (allocation[daughters[i].person.id] ?? 0) + perD + (i < dRem ? 1 : 0);
        }
        remaining -= dTotal;
        steps.add('البنات (${daughters.length}): الثلثان = $dTotal سهماً');
      }
    }

    // أبناء وبنات الابن
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
        steps.add('أبناء وبنات الابن: الباقي $remaining سهماً');
        remaining = 0;
      }
    }

    // كلالة: الإخوة والأخوات
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
        steps.add('الإخوة الأشقاء (كلالة): الباقي $remaining سهماً');
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
          steps.add('الإخوة لأب (كلالة): الباقي $remaining سهماً');
          remaining = 0;
        }
      }
    }

    // الأعمام
    if (remaining > 0 && uncles.isNotEmpty) {
      final perU = remaining ~/ uncles.length;
      var uRem = remaining - perU * uncles.length;
      for (var i = 0; i < uncles.length; i++) {
        allocation[uncles[i].person.id] = (allocation[uncles[i].person.id] ?? 0) + perU + (i < uRem ? 1 : 0);
      }
      steps.add('الأعمام: الباقي $remaining سهماً');
      remaining = 0;
    }

    // أبناء العم
    if (remaining > 0 && cousinSons.isNotEmpty) {
      final perC = remaining ~/ cousinSons.length;
      var cRem = remaining - perC * cousinSons.length;
      for (var i = 0; i < cousinSons.length; i++) {
        allocation[cousinSons[i].person.id] = (allocation[cousinSons[i].person.id] ?? 0) + perC + (i < cRem ? 1 : 0);
      }
      steps.add('أبناء العم: الباقي $remaining سهماً');
      remaining = 0;
    }

    // الأب يأخذ الباقي تعصيباً
    if (remaining > 0 && fathers.isNotEmpty) {
      allocation[fathers.first.person.id] = (allocation[fathers.first.person.id] ?? 0) + remaining;
      steps.add('الأب: الباقي تعصيباً = $remaining سهماً');
      remaining = 0;
    }

    // تصحيح نهائي
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
        shareCategory: s > 0 ? 'مستحق' : 'محروم',
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // المسار 2: المحرك الديناميكي (للمسائل المعقدة)
  // ═══════════════════════════════════════════════════════════════════════════

  _DynamicResult _calculateDynamic(List<Heir> heirs, bool isKalala, List<String> steps) {
    // 1. تصنيف الورثة إلى أنواع
    // 2. تحديد الفروض
    // 3. حساب أصل المسألة
    // 4. معالجة العول
    // 5. معالجة الرد
    // 6. التصحيح
    // 7. إرجاع النتيجة

    final fractions = <String, _Fraction>{};
    int baseNumber = 1;
    bool hasAwl = false;
    bool hasRadd = false;
    bool hasCorrection = false;

    // تحديد الفروض لكل وريث
    for (final h in heirs) {
      final f = _getShareFraction(h.relation, heirs);
      if (f.numerator > 0 && f.denominator > 0) {
        fractions[h.person.id] = f;
      }
    }

    // حساب أصل المسألة (LCM للمقامات)
    if (fractions.isNotEmpty) {
      final denominators = fractions.values.map((f) => f.denominator).toSet().toList();
      baseNumber = _lcmOfList(denominators);
    }
    int originalBase = baseNumber;

    // حساب مجموع الفروض
    int totalFractions = 0;
    for (final entry in fractions.entries) {
      final heir = heirs.firstWhere((h) => h.person.id == entry.key);
      final shareValue = (baseNumber * entry.value.numerator) ~/ entry.value.denominator;
      totalFractions += shareValue * 1; // count = 1 for now
    }

    // العول
    if (totalFractions > baseNumber) {
      baseNumber = _applyAwl(baseNumber, totalFractions);
      hasAwl = true;
      steps.add('حدث عول: أصل المسألة $originalBase ← $baseNumber');
    }

    // الرد
    int remaining = baseNumber - totalFractions;
    if (remaining > 0 && !_hasAsaba(heirs)) {
      hasRadd = true;
      steps.add('حدث رد: الباقي $remaining سهماً يوزع على أصحاب الفروض');
      remaining = 0;
    }

    // بناء النتيجة
    final resultShares = <HeirShare>[];
    for (final h in heirs) {
      final f = fractions[h.person.id];
      final s = f != null ? ((baseNumber * f.numerator) ~/ f.denominator) : 0;
      resultShares.add(HeirShare(
        heirId: h.person.id,
        heirName: h.person.fullName,
        relation: h.relation,
        shares: s,
        fraction: baseNumber > 0 ? s / baseNumber : 0,
        fractionLabel: _simplifyFraction(s, baseNumber),
        isExcluded: false,
        exclusionReason: '',
        shareCategory: s > 0 ? 'فرض' : 'محروم',
      ));
    }

    return _DynamicResult(
      shares: resultShares,
      baseNumber: baseNumber,
      originalBase: originalBase,
      hasAwl: hasAwl,
      hasRadd: hasRadd,
      hasCorrection: hasCorrection,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // المسار 3: الأراضي الأميرية
  // ═══════════════════════════════════════════════════════════════════════════

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
        shareCategory: 'أميري',
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // دوال رياضية مساعدة
  // ═══════════════════════════════════════════════════════════════════════════

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);
  static int _lcm(int a, int b) => (a * b) ~/ _gcd(a, b);
  static int _lcmOfList(List<int> numbers) => numbers.reduce(_lcm);

  static int _applyAwl(int baseNumber, int totalShares) {
    if (baseNumber == 6 && totalShares > 6 && totalShares <= 10) return totalShares;
    if (baseNumber == 12 && totalShares > 12 && totalShares <= 17) return totalShares;
    if (baseNumber == 24 && totalShares == 27) return 27;
    return baseNumber;
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

// ─── أنواع مساعدة داخلية ─────────────────────────────────────────────────────

enum _Complexity { simple, moderate, awl, radd, correction }

class _DynamicResult {
  final List<HeirShare> shares;
  final int baseNumber;
  final int originalBase;
  final bool hasAwl;
  final bool hasRadd;
  final bool hasCorrection;

  const _DynamicResult({
    required this.shares,
    required this.baseNumber,
    required this.originalBase,
    this.hasAwl = false,
    this.hasRadd = false,
    this.hasCorrection = false,
  });
}
