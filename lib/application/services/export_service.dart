import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/models/contract.dart';
import 'pdf_service.dart';

class ExportService {
  final PdfService _pdfService = PdfService();

  Future<File> exportPdf(Contract contract, {bool blank = false}) async {
    return await _pdfService.generate(contract, blankTemplate: blank);
  }

  Future<File> exportTxt(Contract contract) async {
    final buffer = StringBuffer();
    buffer.writeln('بسم الله الرحمن الرحيم');
    buffer.writeln('الجمهورية العربية السورية');
    buffer.writeln('صائغ العقود السوري');
    buffer.writeln('=' * 40);
    buffer.writeln('نوع العقد: ${_typeAr(contract)}');
    buffer.writeln('التاريخ: ${contract.contractDate}');
    buffer.writeln('المدينة: ${contract.city} – ${contract.governorate}');
    buffer.writeln('=' * 40);
    if (contract.sellers.isNotEmpty) {
      final s = contract.sellers.first;
      buffer.writeln('البائع: ${s.fullName} بن ${s.fatherName}');
      buffer.writeln('الرقم الوطني: ${s.nationalId}');
      buffer.writeln('الهاتف: ${s.phone}');
    }
    if (contract.buyers.isNotEmpty) {
      final b = contract.buyers.first;
      buffer.writeln('المشتري: ${b.fullName} بن ${b.fatherName}');
      buffer.writeln('الرقم الوطني: ${b.nationalId}');
      buffer.writeln('الهاتف: ${b.phone}');
    }
    buffer.writeln('=' * 40);
    buffer.writeln('العقار: ${contract.property.registryNumber}');
    buffer.writeln('المنطقة: ${contract.property.zone}');
    buffer.writeln('المساحة: ${contract.property.area} م²');
    buffer.writeln('=' * 40);
    buffer.writeln('الثمن الإجمالي: ${contract.payment.totalPrice} ل.س');
    buffer.writeln('المدفوع: ${contract.payment.paidAmount} ل.س');
    buffer.writeln('الرصيد: ${contract.payment.balance} ل.س');
    buffer.writeln('=' * 40);
    buffer.writeln('تنبيه: هذا العقد لا ينقل الملكية. يجب التسجيل في المصالح العقارية.');
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/عقود_صائغ');
    if (!await folder.exists()) await folder.create(recursive: true);
    final file = File('${folder.path}/عقد_${contract.id}.txt');
    await file.writeAsString(buffer.toString());
    return file;
  }

  Future<File?> exportJpg(Contract contract) async {
    try {
      final pdfFile = await exportPdf(contract);
      final bytes = await pdfFile.readAsBytes();
      await for (final page in Printing.raster(bytes, dpi: 150)) {
        final ui.Image img = await page.toImage();
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) return null;
        final dir = await getApplicationDocumentsDirectory();
        final folder = Directory('${dir.path}/عقود_صائغ');
        if (!await folder.exists()) await folder.create(recursive: true);
        final out = File('${folder.path}/عقد_${contract.id}.png');
        await out.writeAsBytes(byteData.buffer.asUint8List());
        return out;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> shareFile(File file, {String? text}) async {
    await Share.shareXFiles([XFile(file.path)], text: text);
  }

  String _typeAr(Contract c) {
    switch (c.type) {
      case ContractType.directSale: return 'بيع مباشر';
      case ContractType.usufructSale: return 'بيع حق انتفاع';
      case ContractType.commonShareSale: return 'بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'اتفاق ورثة';
      case ContractType.partition: return 'قسمة رضائية';
      case ContractType.settlement: return 'صلح ووساطة';
      case ContractType.promise: return 'وعد بالبيع';
      case ContractType.judicialSale: return 'بيع قضائي';
      case ContractType.judicialInheritance: return 'حصر إرث قضائي';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'تخارج قضائي';
      case ContractType.complexProperty: return 'محضر عقاري متعدد';
    }
  }
}
