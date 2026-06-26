import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../../application/services/export_service.dart';
import '../../application/services/pdf_service.dart';
import '../state/contract_provider.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  final ExportService _exportService = ExportService();
  final PdfService _pdfService = PdfService();
  File? _pdfFile;
  bool _loading = true;
  bool _blankTemplate = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final contract = context.read<ContractProvider>().contract;
      final file = await _pdfService.generate(contract, blankTemplate: _blankTemplate);

      // Show font warning SnackBar if fallback was used
      if (_pdfService.usedFallbackFont &&
          _pdfService.fontWarningMessage != null &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_pdfService.fontWarningMessage!),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }

      if (mounted) setState(() { _pdfFile = file; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _sharePdf() async {
    final file = _pdfFile;
    if (file == null) return;
    await _exportService.shareFile(file, text: 'عقد من تطبيق صائغ العقود السوري');
  }

  Future<void> _exportTxt() async {
    try {
      final contract = context.read<ContractProvider>().contract;
      final file = await _exportService.exportTxt(contract);
      await _exportService.shareFile(file, text: 'عقد نصي من صائغ العقود السوري');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _exportImage() async {
    try {
      final contract = context.read<ContractProvider>().contract;
      final file = await _exportService.exportJpg(contract);
      if (file != null) {
        await _exportService.shareFile(file);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تعذر تصدير الصورة'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Fixed: save with explicit SnackBar success/failure
  Future<void> _saveContract() async {
    try {
      await context.read<ContractProvider>().saveContract();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ العقد بنجاح ✓'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل حفظ العقد: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة العقد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'مشاركة PDF',
            onPressed: _pdfFile != null ? _sharePdf : null,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'حفظ العقد',
            onPressed: _saveContract,
          ),
        ],
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.grey.shade100,
          child: Column(children: [
            Row(children: [
              const Text('حجم الخط:', style: TextStyle(fontSize: 13)),
              Expanded(
                child: Slider(
                  value: provider.fontScale,
                  min: 0.7,
                  max: 1.5,
                  divisions: 8,
                  label: '${(provider.fontScale * 100).round()}%',
                  onChanged: (v) => provider.setFontScale(v),
                ),
              ),
              Text('${(provider.fontScale * 100).round()}%',
                  style: const TextStyle(fontSize: 12)),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text('قالب فارغ للكتابة باليد'),
                  selected: _blankTemplate,
                  onSelected: (v) {
                    setState(() => _blankTemplate = v);
                    _generatePdf();
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.text_snippet, size: 18),
                  label: const Text('TXT', style: TextStyle(fontSize: 12)),
                  onPressed: _exportTxt,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image, size: 18),
                  label: const Text('صورة', style: TextStyle(fontSize: 12)),
                  onPressed: _exportImage,
                ),
              ],
            ),
          ]),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text('خطأ في توليد PDF:\n$_error',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _generatePdf,
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    )
                  : _pdfFile != null
                      ? PdfPreview(
                          build: (_) => _pdfFile!.readAsBytes(),
                          allowPrinting: true,
                          allowSharing: true,
                          canDebug: false,
                          pdfFileName: 'عقد_صائغ.pdf',
                        )
                      : const Center(child: Text('لا يوجد ملف PDF')),
        ),
      ]),
    );
  }
}
