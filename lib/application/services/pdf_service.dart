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
      final fontData = await rootBundle.load(SystemConfig.contractFontAssetPath);
      return pw.Font.ttf(fontData);
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
      final fontData = await rootBundle.load(SystemConfig.contractFontBoldAssetPath);
      return pw.Font.ttf(fontData);
    } catch (_) {
      return _loadFont();
    }
  }

  // ✅ تم إصلاح هذه الدالة بإضافة default
  PdfPageFormat _pdfPageFormat() {
    switch (SystemConfig.pageFormat) {
      case ContractPageFormat.a4:
        return PdfPageFormat.a4;
      case ContractPageFormat.a5:
        return PdfPageFormat.a5;
      case ContractPageFormat.letter:
        return PdfPageFormat.letter;
      default:
        return PdfPageFormat.a4; // <--- إصلاح الخطأ
    }
  }

  Future<File> generate(Contract contract, {bool blankTemplate = false}) async {
    final doc = pw.Document();
    final baseFont = await _loadFont();
    final boldFont = await _loadBoldFont();
    final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);
    final pageFormat = _pdfPageFormat();

    doc.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: pageFormat,
        textDirection: pw.TextDirection.rtl, // ✅ MultiPage يقبل textDirection
        margin: pw.EdgeInsets.fromLTRB(2.5 * PdfPageFormat.cm, 2.5 * PdfPageFormat.cm, 2.5 * PdfPageFormat.cm, 2.5 * PdfPageFormat.cm),
        build: (context) => _buildContent(contract, blankTemplate),
        header: (context) => _buildHeader(blankTemplate),
        footer: (context) => _buildFooter(context),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/عقود_صائغ');
    if (!await folder.exists()) await folder.create(recursive: true);
    final fileName = blankTemplate ? 'قالب_فارغ_${contract.id}.pdf' : 'عقد_${contract.id}.pdf';
    final file = File('${folder.path}/$fileName');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  // ✅ تم إصلاح _buildHeader: استخدام Directionality حول Column
  pw.Widget _buildHeader(bool blank) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 1, color: PdfColors.black),
          left: pw.BorderSide(width: 1, color: PdfColors.black),
          right: pw.BorderSide(width: 1, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
          children: [
            pw.Text(LegalPhrases.bismillah, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text(LegalPhrases.syria, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ✅ تم إصلاح _buildFooter: استخدام Directionality حول Text
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 1, color: PdfColors.black),
          left: pw.BorderSide(width: 1, color: PdfColors.black),
          right: pw.BorderSide(width: 1, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      alignment: pw.Alignment.center,
      child: pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text('صائغ العقود السوري – صفحة ${context.pageNumber} من ${context.pagesCount}', style: const pw.TextStyle(fontSize: 9)),
      ),
    );
  }

  List<pw.Widget> _buildContent(Contract contract, bool blank) {
    final widgets = <pw.Widget>[];
    widgets.add(_divider());
    widgets.add(_title(_contractTitle(contract), 16));
    widgets.add(_divider());
    widgets.add(_text('في هذا اليوم الـ ${blank ? '___________' : (contract.contractDate.isEmpty ? '...' : contract.contractDate)} في مدينة ${blank ? '___________' : (contract.city.isEmpty ? '...' : contract.city)}، المحافظة ${blank ? '___________' : (contract.governorate.isEmpty ? '...' : contract.governorate)}، تم التعاقد ما بين:'));
    widgets.add(_sectionTitle('الفريق الأول (البائع)'));
    if (contract.sellers.isNotEmpty) {
      widgets.add(_personBlock(contract.sellers.first, blank));
    } else {
      widgets.add(_personBlock(const Person(id: '_'), blank));
    }
    widgets.add(_text('ويشار إليه بـ (البائع).'));
    widgets.add(_divider());
    if (contract.buyers.isNotEmpty) {
      widgets.add(_sectionTitle('الفريق الثاني (المشتري)'));
      widgets.add(_personBlock(contract.buyers.first, blank));
      widgets.add(_text('ويشار إليه بـ (المشتري).'));
      widgets.add(_divider());
    }
    widgets.add(_sectionTitle('مقدمة'));
    widgets.add(_propertyBlock(contract, blank));
    widgets.add(_divider());

    if (contract.type == ContractType.judicialSale || contract.type == ContractType.judicialInheritance ||
        contract.type == ContractType.judicialPartition || contract.type == ContractType.judicialExit) {
      widgets.add(_sectionTitle('بيانات الحكم القضائي'));
      widgets.add(_judicialBlock(contract, blank));
      widgets.add(_divider());
    }

    if (contract.type == ContractType.inheritanceAgreement || contract.type == ContractType.judicialInheritance) {
      widgets.add(_sectionTitle('الورثة'));
      widgets.add(_heirsBlock(contract, blank));
      widgets.add(_divider());
    }

    if (contract.type == ContractType.complexProperty) {
      widgets.add(_sectionTitle('تفاصيل الوحدات العقارية'));
      for (final c in contract.customClauses.where((cl) => cl.isVisible)) {
        widgets.add(_bullet('${c.titleAr} – ${c.bodyAr}'));
      }
      widgets.add(_divider());
    }

    widgets.add(_clausesBlock(contract, blank));
    widgets.add(_divider());
    widgets.add(_legalNotice());
    widgets.add(_divider());
    widgets.add(_signaturesBlock(contract, blank));

    for (final annex in contract.annexes) {
      widgets.add(_annexBlock(annex, blank));
    }
    return widgets;
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

  // ✅ تم إصلاح _title: استخدام Directionality حول Text
  pw.Widget _title(String text, double size) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 8),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(text, style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
    ),
  );

  // ✅ تم إصلاح _sectionTitle
  pw.Widget _sectionTitle(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(text, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
    ),
  );

  // ✅ تم إصلاح _text
  pw.Widget _text(String text) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
    ),
  );

  // ✅ تم إصلاح _bullet: إزالة textDirection من pw.Text ووضع Directionality
  pw.Widget _bullet(String text) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Text('• ', style: const pw.TextStyle(fontSize: 12)),
        ),
        pw.Expanded(
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
          ),
        ),
      ],
    ),
  );

  pw.Widget _divider() => pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 4),
    height: 0.5, color: PdfColors.black,
  );

  pw.Widget _personBlock(Person p, bool blank) {
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text('السيد/السيدة: ${v(p.fullName)} بن ${v(p.fatherName)} والدته ${v(p.motherName)} تولد عام ${v(p.birthYear)}'),
        _text('المسجل بالمسكن ${v(p.residency)} خانة / ${v(p.familyId)} /'),
        _text('الرقم الوطني: ${v(p.nationalId)}'),
        _text('رقم البطاقة الشخصية: ${v(p.idNumber)} الصادرة عن: ${v(p.idIssuedBy)} بتاريخ ${v(p.idIssuedDate)}'),
        _text('المهنة: ${v(p.profession)}  الحالة العائلية: ${_maritalStatusAr(p.maritalStatus)}'),
        _text('العنوان: ${v(p.address)}'),
        _text('رقم الهاتف: ${v(p.phone)}'),
        if (p.hasPowerOfAttorney) _text('صفة التوقيع: وكالة بموجب الوكالة رقم ${v(p.poaNumber)} وتاريخ ${v(p.poaDate)}'),
      ],
    );
  }

  String _maritalStatusAr(MaritalStatus s) {
    switch (s) {
      case MaritalStatus.single: return 'أعزب';
      case MaritalStatus.married: return 'متزوج';
      case MaritalStatus.divorced: return 'مطلق';
      case MaritalStatus.widowed: return 'أرمل';
    }
  }

  String _propertyTypeAr(PropertyType t) {
    switch (t) {
      case PropertyType.apartment: return 'شقة';
      case PropertyType.shop: return 'محل تجاري';
      case PropertyType.ownedLand: return 'أرض ملك';
      case PropertyType.amiriaLand: return 'أرض أميرية';
      case PropertyType.privateVehicle: return 'سيارة خصوصي';
      case PropertyType.taxiVehicle: return 'سيارة أجرة';
      case PropertyType.truck: return 'شاحنة';
      case PropertyType.heavyMachinery: return 'آلية ثقيلة';
      case PropertyType.agriculturalTractor: return 'جرار زراعي';
      case PropertyType.rooftop: return 'سطح';
      case PropertyType.basement: return 'قبو';
      case PropertyType.annex: return 'ملحق';
      case PropertyType.villa: return 'فيلا';
      case PropertyType.arabicHouse: return 'بيت عربي';
      case PropertyType.farm: return 'مزرعة';
      case PropertyType.agriculturalLand: return 'أرض زراعية';
      case PropertyType.multiUnit: return 'متعدد الوحدات';
    }
  }

  pw.Widget _propertyBlock(Contract c, bool blank) {
    final p = c.property;
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text('يملك الفريق الأول العقار رقم (${v(p.registryNumber)}) من منطقة ${v(p.zone)} العقارية، المخطط رقم (${v(p.planNumber)})، القسيمة رقم (${v(p.plotNumber)})'),
        _text('نوع العقار: ${_propertyTypeAr(p.type)} – المساحة: ${p.area > 0 ? ArabicTextHelpers.toArabicDigits(p.area) : (blank ? '___________' : '...')} م²'),
        _text('بموجب سند الملكية رقم ${v(p.ownershipDocNumber)} تاريخ ${v(p.ownershipDocDate)} الصادر عن ${v(p.ownershipDocSource)}'),
        if (p.boundaries.isNotEmpty) _text('الحدود العامة: ${v(p.boundaries)}'),
        if (p.northBoundary.isNotEmpty) _text('شمالاً: ${v(p.northBoundary)}'),
        if (p.southBoundary.isNotEmpty) _text('جنوباً: ${v(p.southBoundary)}'),
        if (p.eastBoundary.isNotEmpty) _text('شرقاً: ${v(p.eastBoundary)}'),
        if (p.westBoundary.isNotEmpty) _text('غرباً: ${v(p.westBoundary)}'),
        if (p.isCommonShare) _text('الحصة الشائعة: ${ArabicTextHelpers.toArabicDigits(p.commonShareNumerator)} / ${ArabicTextHelpers.toArabicDigits(p.commonShareDenominator)}'),
        _text('وبعد المعاينة التامة النافية للجهالة، اتفقا على:'),
      ],
    );
  }

  pw.Widget _judicialBlock(Contract c, bool blank) {
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text('رقم الحكم: ${v(c.judgmentNumber)}'),
        _text('تاريخ الحكم: ${v(c.judgmentDate)}'),
        _text('المحكمة المصدِرة: ${v(c.judgmentCourt)}'),
        _text('صفة الحكم: ${c.judgmentIsFinal ? 'مبرم (بات)' : 'غير مبرم'}'),
      ],
    );
  }

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

  pw.Widget _clausesBlock(Contract c, bool blank) {
    String v(String val) => blank ? '___________' : (val.isEmpty ? '...' : val);
    final price = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.totalPrice);
    final paid = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.paidAmount);
    final balance = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.balance);
    final penalty = blank ? '___________' : ArabicTextHelpers.toArabicDigits(c.payment.penaltyAmount);
    final tax = blank ? '___________' : ArabicTextHelpers.toArabicDigits((c.payment.totalPrice * 0.03).round());
    final clauses = <pw.Widget>[];

    clauses.add(_sectionTitle('البند الأول (البيع والثمن)'));
    clauses.add(_text('باع البائع للمشتري العقار المذكور، بيعاً قطعياً، لقاء ثمن إجمالي قدره ($price) ${_currencyAr(c.payment.currency)}. قبض منه مبلغ ($paid) ${_currencyAr(c.payment.currency)}، والرصيد ($balance) ${_currencyAr(c.payment.currency)} يدفع بتاريخ ${v(c.payment.balanceDueDate)} ${c.payment.method == PaymentMethod.installments ? 'وفق جدول الدفعات المرفق' : ''}.'));
    clauses.add(_sectionTitle('البند الثاني (براءة الذمة)'));
    clauses.add(_text('يقر البائع بأن العقار صافٍ من الديون والرهونات حتى تاريخه، وأي دين يظهر مستقبلاً يلتزم البائع بسداده.'));
    clauses.add(_sectionTitle('البند الثالث (الموافقة الأمنية - الشرط الفاسخ)'));
    clauses.add(_text('يُفسخ العقد تلقائياً إذا لم تحصل الموافقة الأمنية خلال 60 يوماً من تاريخه، ويلتزم البائع برد المبالغ فوراً.'));
    clauses.add(_sectionTitle('البند الرابع (الشرط الجزائي)'));
    clauses.add(_text('في حال النكوص بعد الموافقة الأمنية، يلتزم الطرف المخِل بدفع شرط جزائي قدره ($penalty) ${_currencyAr(c.payment.currency)}.'));
    clauses.add(_sectionTitle('البند الخامس (ضريبة البيوع)'));
    clauses.add(_text('تُحتسب الضريبة بنسبة 3% من الثمن المتفق عليه، وقدرها ($tax) ${_currencyAr(c.payment.currency)} تقريباً، ويتعهد المشتري بسدادها. ${c.payment.taxExemptOnNkoul ? 'وفي حال النكول، يُعفى الطرفان من أدائها.' : ''}'));
    clauses.add(_sectionTitle('البند السادس (الالتزامات المالية)'));
    clauses.add(_text('جميع النفقات الأخرى يتحملها ${_expenseAllocationAr(c.payment.expenseAllocation)} بالكامل.'));
    clauses.add(_sectionTitle('البند السابع (ضمان التعرض والاستحقاق)'));
    clauses.add(_text('يضمن البائع عدم تعرض أي شخص للمشتري، ويكون مسؤولاً عن أي استحقاق يظهر.'));

    for (final clause in c.customClauses.where((cl) => cl.isVisible)) {
      clauses.add(_sectionTitle(clause.titleAr));
      clauses.add(_text(blank ? '___________' : clause.bodyAr));
    }
    return pw.Column(children: clauses);
  }

  String _currencyAr(Currency c) {
    switch (c) {
      case Currency.syp: return 'ل.س';
      case Currency.usd: return 'دولار أمريكي';
      case Currency.eur: return 'يورو';
      case Currency.sar: return 'ريال سعودي';
      case Currency.gbp: return 'جنيه إسترليني';
      case Currency.aed: return 'درهم إماراتي';
    }
  }

  String _expenseAllocationAr(ExpenseAllocation e) {
    switch (e) {
      case ExpenseAllocation.buyer: return 'المشتري';
      case ExpenseAllocation.seller: return 'البائع';
      case ExpenseAllocation.halved: return 'الطرفان مناصفة';
      case ExpenseAllocation.custom: return 'حسب الاتفاق';
    }
  }

  // ✅ تم إصلاح _legalNotice
  pw.Widget _legalNotice() => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text('تنبيه قانوني إلزامي: ${LegalPhrases.legalNotice}\n\n${LegalPhrases.twoCopies}', style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
    ),
  );

  // ✅ تم إصلاح _signaturesBlock: إزالة textDirection من pw.Row و pw.Text
  pw.Widget _signaturesBlock(Contract c, bool blank) {
    final sellerName = blank ? '___________' : (c.sellers.isNotEmpty ? c.sellers.first.fullName : '...');
    final buyerName = blank ? '___________' : (c.buyers.isNotEmpty ? c.buyers.first.fullName : '...');
    return pw.Column(
      children: [
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _signatureBox('الفريق الأول (البائع)\n$sellerName'),
            _signatureBox('الفريق الثاني (المشتري)\n$buyerName'),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Text('الشهود:'),
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _signatureBox(c.witnesses.isNotEmpty && !blank ? c.witnesses.first.fullName : '___________'),
            _signatureBox(c.witnesses.length > 1 && !blank ? c.witnesses[1].fullName : '___________'),
          ],
        ),
      ],
    );
  }

  // ✅ تم إصلاح _signatureBox
  pw.Widget _signatureBox(String label) => pw.Container(
    width: 220, height: 100,
    decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
    padding: const pw.EdgeInsets.all(8),
    child: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
    ),
  );

  // ✅ تم إصلاح _annexBlock
  pw.Widget _annexBlock(ContractAnnex annex, bool blank) => pw.Column(
    children: [
      pw.SizedBox(height: 12),
      pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5, color: PdfColors.grey)),
        padding: const pw.EdgeInsets.all(6),
        child: pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Text('ملحق رقم ${annex.number}: ${annex.titleAr}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        ),
      ),
      pw.SizedBox(height: 6),
      _text(blank ? '___________' : annex.bodyAr),
    ],
  );
}
