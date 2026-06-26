import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/services/export_service.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';

class ExportOptionsScreen extends StatefulWidget {
  const ExportOptionsScreen({super.key});

  @override
  State<ExportOptionsScreen> createState() => _ExportOptionsScreenState();
}

class _ExportOptionsScreenState extends State<ExportOptionsScreen> {
  final ExportService _export = ExportService();
  bool _isExporting = false;

  Future<void> _exportAs({required String format}) async {
    setState(() => _isExporting = true);
    try {
      final contract = context.read<ContractProvider>().contract;
      File? file;
      switch (format) {
        case 'pdf':
          file = await _export.exportPdf(contract);
          break;
        case 'blank_pdf':
          file = await _export.exportPdf(contract, blank: true);
          break;
        case 'txt':
          file = await _export.exportTxt(contract);
          break;
        case 'image':
          file = await _export.exportJpg(contract);
          break;
      }
      if (file != null && mounted) {
        AppNotification.success(context, 'تم التصدير: ${file.path}');
      } else if (mounted) {
        AppNotification.error(context, 'فشل التصدير');
      }
    } catch (e) {
      if (mounted) AppNotification.error(context, 'خطأ: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    return Scaffold(
      appBar: AppBar(title: const Text('خيارات التصدير')),
      body: Stack(children: [
        ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(ContractTypeHelpers.getTitle(contract.type), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('الثمن: ${ArabicTextHelpers.toArabicDigits(contract.payment.totalPrice)} ل.س', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _exportTile('تصدير PDF كامل', 'العقد المعبأ بجميع البيانات', Icons.picture_as_pdf, Colors.red, () => _exportAs(format: 'pdf')),
          _exportTile('قالب فارغ PDF', 'قالب بدون بيانات للكتابة باليد', Icons.edit_document, Colors.blue, () => _exportAs(format: 'blank_pdf')),
          _exportTile('تصدير TXT', 'نص مبسط قابل للنسخ', Icons.text_snippet, Colors.green, () => _exportAs(format: 'txt')),
          _exportTile('تصدير صورة PNG', 'صورة للمشاركة السريعة', Icons.image, Colors.orange, () => _exportAs(format: 'image')),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Colors.amber),
              SizedBox(width: 8),
              Expanded(child: Text('القالب الفارغ مخصص للتعبئة بالقلم الأزرق وفقاً للعرف السوري.', style: TextStyle(fontSize: 11))),
            ]),
          ),
        ]),
        if (_isExporting) Container(
          color: Colors.black54,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _exportTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}