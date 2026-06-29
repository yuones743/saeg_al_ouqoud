import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../core/utils/constants.dart';
import '../../core/config/system_config.dart';

class PdfService {
  Future<pw.Font> _loadFont() async {
    try {
      final data = await rootBundle.load(SystemConfig.contractFontAssetPath);
      return pw.Font.ttf(data);
    } catch (_) {
      try {
        final fallback = await rootBundle.load('assets/fonts/TraditionalArabic.ttf');
        return pw.Font.ttf(fallback);
      } catch (_) {
        return pw.Font.times();
      }
    }
  }

  Future<pw.Font> _loadBoldFont() async {
    try {
      final data = await rootBundle.load(SystemConfig.contractFontBoldAssetPath);
      return pw.Font.ttf(data);
    } catch (_) {
      return _loadFont();
    }
  }

  PdfPageFormat _pdfPageFormat() {
    switch (SystemConfig.pageFormat) {
      case ContractPageFormat.a4: return PdfPageFormat.a4;
      case ContractPageFormat.a5: return PdfPageFormat.a5;
      case ContractPageFormat.letter: return PdfPageFormat.letter;
      default: return PdfPageFormat.a4;
    }
  }

  double _getDynamicMargin(Contract contract) {
    final baseMargin = SystemConfig.margin.clamp(0.7, 2.5);
    final contentLength = _estimateContentLength(contract);
    final reduction = (contentLength / 500) * 0.2;
    return (baseMargin - reduction).clamp(0.7, 2.5);
  }

  int _estimateContentLength(Contract c) {
    int length = 100;
    length += c.sellers.length * 50;
    length += c.buyers.length * 50;
    length += c.customClauses.length * 30;
    length += c.annexes.length * 20;
    length += c.heirs.length * 20;
    length += c.property.description.length ~/ 2;
    return length;
  }

  Future<File> generate(Contract contract, {bool blankTemplate = false}) async {
    final doc = pw.Document();
    final baseFont = await _loadFont();
    final boldFont = await _loadBoldFont();
    final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);
    final pageFormat = _pdfPageFormat();
    final margin = _getDynamicMargin(contract);
    final headerSize = SystemConfig.headerFontSize.clamp(12.0, 22.0);

    doc.addPage(pw.MultiPage(
      theme: theme,
      pageFormat: pageFormat,
      textDirection: pw.TextDirection.rtl,
      margin: pw.EdgeInsets.fromLTRB(
        margin * PdfPageFormat.cm,
        margin * PdfPageFormat.cm,
        margin * PdfPageFormat.cm,
        margin * PdfPageFormat.cm,
      ),
      build: (context) => _buildContent(contract, blankTemplate, headerSize),
      header: (context) => _buildHeader(contract, blankTemplate, headerSize),
      footer: (context) => _buildFooter(context),
    ));

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/عقود_صائغ');
    if (!await folder.exists()) await folder.create(recursive: true);
    final fileName = blankTemplate ? 'قالب_فارغ_${contract.id}.pdf' : 'عقد_${contract.id}.pdf';
    final file = File('${folder.path}/$fileName');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  pw.Widget _buildHeader(Contract contract, bool blank, double headerSize) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 0.5, color: PdfColors.black),
          left: pw.BorderSide(width: 0.5, color: PdfColors.black),
          right: pw.BorderSide(width: 0.5, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(children: [
          pw.Text(
            LegalPhrases.bismillah,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: headerSize, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            blank ? 'قالب عقد فارغ' : _contractTitle(contract),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: headerSize * 0.7, fontWeight: pw.FontWeight.bold),
          ),
        ]),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
          left: pw.BorderSide(width: 0.5, color: PdfColors.black),
          right: pw.BorderSide(width: 0.5, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      alignment: pw.Alignment.center,
      child: pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          'صائغ العقود السوري – صفحة ${context.pageNumber} من ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ),
    );
  }

  String _contractTitle(Contract c) {
    switch (c.type) {
      case ContractType.directSale: return 'عقد بيع قطعي';
      case ContractType.usufructSale: return 'عقد بيع حق انتفاع';
      case ContractType.commonShareSale: return 'عقد بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'محضر اتفاق ورثة';
      case ContractType.partition: return 'عقد قسمة رضائية';
      case ContractType.settlement: return 'عقد صلح ووساطة';
      case ContractType.promise: return 'عقد وعد بالبيع';
      case ContractType.judicialSale: return 'عقد بيع بموجب حكم قضائي';
      case ContractType.judicialInheritance: return 'محضر حصر إرث قضائي';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'عقد تخارج قضائي';
      case ContractType.complexProperty: return 'محضر عقاري متعدد الوحدات';
    }
  }

  List<pw.Widget> _buildContent(Contract contract, bool blank, double headerSize) {
    final widgets = <pw.Widget>[];
    final isInheritance = contract.type == ContractType.inheritanceAgreement ||
                          contract.type == ContractType.judicialInheritance;

    widgets.add(_divider());
    widgets.add(_text(
      'في هذا اليوم الـ ${blank ? '___________' : (contract.contractDate.isEmpty ? '...' : contract.contractDate)}'
      ' في مدينة ${blank ? '___________' : (contract.city.isEmpty ? '...' : contract.city)}'
      '، المحافظة ${blank ? '___________' : (contract.governorate.isEmpty ? '...' : contract.governorate)}'
      '، تم التعاقد ما بين:',
    ));

    // ── البائعون ──
    widgets.add(_sectionTitle(
      contract.sellers.length > 1 ? 'الفريق الأول (البائعون)' : 'الفريق الأول (البائع)',
      headerSize * 0.65,
    ));
    if (contract.sellers.isEmpty) {
      widgets.add(_text('...'));
    } else {
      for (var i = 0; i < contract.sellers.length; i++) {
        final share = _getSellerShare(contract, i);
        widgets.add(_compactPerson(contract.sellers[i], blank, role: 'البائع', number: i + 1, share: share));
      }
    }
    widgets.add(_text(contract.sellers.length > 1 ? 'ويُشار إليهم مجتمعين بـ (البائعون).' : 'ويُشار إليه بـ (البائع).'));
    widgets.add(_divider());

    // ── المشترون ──
    if (contract.buyers.isNotEmpty) {
      widgets.add(_sectionTitle(
        contract.buyers.length > 1 ? 'الفريق الثاني (المشترون)' : 'الفريق الثاني (المشتري)',
        headerSize * 0.65,
      ));
      for (var i = 0; i < contract.buyers.length; i++) {
        final share = _getBuyerShare(contract, i);
        widgets.add(_compactPerson(contract.buyers[i], blank, role: 'المشتري', number: i + 1, share: share));
      }
      widgets.add(_text(contract.buyers.length > 1 ? 'ويُشار إليهم مجتمعين بـ (المشترون).' : 'ويُشار إليه بـ (المشتري).'));
      widgets.add(_divider());
    }

    // ── المقدمة والعقار ──
    widgets.add(_sectionTitle('المقدمة', headerSize * 0.65));
    widgets.add(_compactProperty(contract, blank));
    widgets.add(_divider());

    // ── الأحكام القضائية ──
    if (contract.type == ContractType.judicialSale ||
        contract.type == ContractType.judicialInheritance ||
        contract.type == ContractType.judicialPartition ||
        contract.type == ContractType.judicialExit) {
      widgets.add(_sectionTitle('بيانات الحكم القضائي', headerSize * 0.65));
      widgets.add(_judicialBlock(contract, blank));
      widgets.add(_divider());
    }

    // ── الورثة ──
    if (isInheritance) {
      widgets.add(_sectionTitle('الورثة', headerSize * 0.65));
      widgets.add(_heirsBlock(contract, blank));
      widgets.add(_divider());
    }

    // ── الوحدات العقارية ──
    if (contract.type == ContractType.complexProperty) {
      widgets.add(_sectionTitle('تفاصيل الوحدات العقارية', headerSize * 0.65));
      for (final c in contract.customClauses.where((cl) => cl.isVisible)) {
        widgets.add(_bullet('${c.titleAr} – ${c.bodyAr}'));
      }
      widgets.add(_divider());
    }

    // ── البنود الأساسية مع ضريبة مرنة ──
    widgets.add(_compactClauses(contract, blank));

    // ── البنود الإضافية ──
    for (final clause in contract.customClauses.where((cl) => cl.isVisible)) {
      widgets.add(_bullet('${clause.titleAr}: ${blank ? '___________' : clause.bodyAr}'));
    }

    // ── التنبيه القانوني ──
    widgets.add(_legalNotice());
    widgets.add(_divider());

    // ── التواقيع ──
    widgets.add(_signaturesBlock(contract, blank));

    // ── الملاحق ──
    for (final annex in contract.annexes) {
      widgets.add(_compactAnnex(annex, blank));
    }

    return widgets;
  }

  // ─── شخص مدمج ──────────────────────────────────────────────────────────────

  pw.Widget _compactPerson(Person p, bool blank, {required String role, required int number, required double share}) {
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    final shareText = share > 0 ? '، حصته: ${ArabicTextHelpers.toArabicDigits(share)} سهماً (من 2400)' : '';
    final capacityText = _getCapacityText(p);
    final poaText = p.hasPowerOfAttorney ? '، وكيل عن: ${v(p.poaNumber)} (${v(p.poaDate)})' : '';
    final minorText = p.isMinor ? ' (قاصر)' : '';
    final expatText = p.isExpatriate ? ' (مغترب)' : '';

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1),
      child: pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          '$role $number: ${v(p.fullName)} بن ${v(p.fatherName)} والدته ${v(p.motherName)}، '
          'الرقم الوطني: ${v(p.nationalId)}، هاتف: ${v(p.phone)}، العنوان: ${v(p.address)}'
          '$shareText$capacityText$poaText$minorText$expatText',
          style: const pw.TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  String _getCapacityText(Person p) {
    if (p.hasPowerOfAttorney) return ' (وكيل)';
    if (p.isMinor) return ' (قاصر)';
    return '';
  }

  double _getSellerShare(Contract contract, int index) {
    if (contract.heirs.isNotEmpty && index < contract.heirs.length) {
      return contract.heirs[index].shares.toDouble();
    }
    if (contract.sellers.isNotEmpty) {
      return 2400 / contract.sellers.length;
    }
    return 0;
  }

  double _getBuyerShare(Contract contract, int index) {
    if (contract.buyers.isNotEmpty) {
      return 2400 / contract.buyers.length;
    }
    return 0;
  }

  // ─── عقار مدمج ──────────────────────────────────────────────────────────────

  pw.Widget _compactProperty(Contract c, bool blank) {
    final p = c.property;
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        'العقار رقم ${v(p.registryNumber)}، منطقة ${v(p.zone)}، نوع ${_propertyTypeAr(p.type)}، '
        'مساحة ${p.area > 0 ? ArabicTextHelpers.toArabicDigits(p.area) : (blank ? '___________' : '...')} م²، '
        'سند رقم ${v(p.ownershipDocNumber)} تاريخ ${v(p.ownershipDocDate)}. '
        'الحدود: ${v(p.boundaries)}.'
        '${p.isCommonShare ? ' حصة شائعة: ${ArabicTextHelpers.toArabicDigits(p.commonShareNumerator)}/${ArabicTextHelpers.toArabicDigits(p.commonShareDenominator)}' : ''}'
        '${p.hasSeizure ? ' (عليه حجز)' : ''}'
        '${p.hasMortgage ? ' (عليه رهن)' : ''}'
        '${p.isEndowment ? ' (موقوف)' : ''}',
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  // ─── بنود مدمجة مع ضريبة مرنة ─────────────────────────────────────────────

  pw.Widget _compactClauses(Contract c, bool blank) {
    final price = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.totalPrice);
    final paid = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.paidAmount);
    final balance = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.balance);
    final penalty = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.penaltyAmount);

    // ✅ ضريبة البيوع مرنة (تقرأ من SystemConfig)
    final taxRate = SystemConfig.taxRate;
    final taxAmount = c.payment.totalPrice * taxRate;
    final tax = blank ? '___________' : ArabicTextHelpers.toArabicDigits(taxAmount.round());
    final taxPercent = (taxRate * 100).toStringAsFixed(1);

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          _bullet('الثمن: $price ${_currencyAr(c.payment.currency)}، دفع: $paid، رصيد: $balance'),
          _bullet('الشرط الجزائي: $penalty ${_currencyAr(c.payment.currency)}'),
          _bullet('ضريبة البيوع العقارية ($taxPercent%): $tax ${_currencyAr(c.payment.currency)}'),
          _bullet('التسليم والفراغ فوراً، العقار خالٍ من الشواغل.'),
        ],
      ),
    );
  }

  // ─── التنبيه القانوني ──────────────────────────────────────────────────────

  pw.Widget _legalNotice() => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        'تنبيه قانوني إلزامي:\n'
        '${LegalPhrases.legalNotice}\n\n'
        '${LegalPhrases.twoCopies}\n\n'
        'ملاحظة: عقود الإيجار الخاضعة للقانون رقم 20 لعام 2015 تعتبر سنداً تنفيذياً لإخلاء العقار فور انتهاء المدة.',
        style: pw.TextStyle(
          fontSize: 8,
          fontStyle: pw.FontStyle.italic,
          color: PdfColors.grey700,
        ),
      ),
    ),
  );

  // ─── الورثة ──────────────────────────────────────────────────────────────────

  pw.Widget _heirsBlock(Contract c, bool blank) {
    if (c.heirs.isEmpty) return _text('لم يُدخل ورثة.');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: c.heirs.map((h) {
        final name = blank ? '___________' : h.person.fullName;
        final rel = h.relation.isEmpty ? '...' : h.relation;
        final shares = blank ? '___________' : ArabicTextHelpers.toArabicDigits(h.shares);
        return _bullet('$name ($rel) – أسهم: $shares / 2400');
      }).toList(),
    );
  }

  // ─── الأحكام القضائية ──────────────────────────────────────────────────────

  pw.Widget _judicialBlock(Contract c, bool blank) {
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text('رقم الحكم: ${v(c.judgmentNumber)}'),
        _text('تاريخ الحكم: ${v(c.judgmentDate)}'),
        _text('المحكمة: ${v(c.judgmentCourt)}'),
        _text('صفة الحكم: ${c.judgmentIsFinal ? 'مبرم (بات)' : 'غير مبرم'}'),
      ],
    );
  }

  // ─── التواقيع ────────────────────────────────────────────────────────────────

  pw.Widget _signaturesBlock(Contract c, bool blank) {
    final sellers = c.sellers.isNotEmpty ? c.sellers : [const Person(id: '_')];
    final buyers = c.buyers.isNotEmpty ? c.buyers : [const Person(id: '_')];
    final witnesses = c.witnesses.isNotEmpty ? c.witnesses : [const Person(id: '_')];

    return pw.Column(children: [
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text('التواقيع:', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ),
      pw.SizedBox(height: 4),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _signatureColumn('البائعون (${sellers.length})', sellers, blank),
          _signatureColumn('المشترون (${buyers.length})', buyers, blank),
          _signatureColumn('الشهود (${witnesses.length})', witnesses, blank),
        ],
      ),
    ]);
  }

  pw.Widget _signatureColumn(String label, List<Person> parties, bool blank) {
    final names = parties.map((p) => blank ? '___________' : (p.fullName.isEmpty ? '___________' : p.fullName)).toList();
    return pw.Container(
      width: 150,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 2),
          ...names.map((name) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(name, style: const pw.TextStyle(fontSize: 8)),
            ),
          )),
          pw.SizedBox(height: 4),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text('التوقيع: .................', style: const pw.TextStyle(fontSize: 7)),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text('البصمة: .................', style: const pw.TextStyle(fontSize: 7)),
          ),
        ],
      ),
    );
  }

  // ─── ملاحق ──────────────────────────────────────────────────────────────────

  pw.Widget _compactAnnex(ContractAnnex annex, bool blank) => pw.Column(children: [
    pw.SizedBox(height: 4),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        'ملحق ${annex.number}: ${annex.titleAr} — ${blank ? '___________' : annex.bodyAr}',
        style: const pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic),
      ),
    ),
  ]);

  // ─── دوال مساعدة ─────────────────────────────────────────────────────────────

  pw.Widget _sectionTitle(String text, double fontSize) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(text, style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
    ),
  );

  pw.Widget _text(String text) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    ),
  );

  pw.Widget _bullet(String text) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1),
    child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Directionality(textDirection: pw.TextDirection.rtl, child: pw.Text('• ', style: const pw.TextStyle(fontSize: 9))),
      pw.Expanded(child: pw.Directionality(textDirection: pw.TextDirection.rtl, child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)))),
    ]),
  );

  pw.Widget _divider() => pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 2),
    height: 0.3,
    color: PdfColors.black,
  );

  String _propertyTypeAr(PropertyType t) {
    switch (t) {
      case PropertyType.apartment: return 'شقة';
      case PropertyType.shop: return 'محل تجاري';
      case PropertyType.ownedLand: return 'أرض ملك';
      case PropertyType.amiriaLand: return 'أرض أميرية';
      case PropertyType.villa: return 'فيلا';
      case PropertyType.arabicHouse: return 'بيت عربي';
      case PropertyType.farm: return 'مزرعة';
      case PropertyType.agriculturalLand: return 'أرض زراعية';
      case PropertyType.rooftop: return 'سطح';
      case PropertyType.basement: return 'قبو';
      case PropertyType.annex: return 'ملحق';
      case PropertyType.privateVehicle: return 'سيارة خصوصي';
      case PropertyType.taxiVehicle: return 'سيارة أجرة';
      case PropertyType.truck: return 'شاحنة';
      case PropertyType.heavyMachinery: return 'آلية ثقيلة';
      case PropertyType.agriculturalTractor: return 'جرار زراعي';
      case PropertyType.multiUnit: return 'متعدد الوحدات';
      default: return 'عقار';
    }
  }

  String _currencyAr(Currency c) {
    switch (c) {
      case Currency.syp: return 'ل.س';
      case Currency.usd: return 'دولار أمريكي';
      case Currency.eur: return 'يورو';
      case Currency.sar: return 'ريال سعودي';
      case Currency.gbp: return 'جنيه إسترليني';
      case Currency.aed: return 'درهم إماراتي';
      default: return '';
    }
  }
}
