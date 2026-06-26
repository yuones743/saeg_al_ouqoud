import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../domain/models/contract.dart';
import '../../application/services/export_service.dart';
import '../state/contract_provider.dart';

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final ExportService _exportService = ExportService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractProvider>().loadContracts();
    });
  }

  String _typeLabel(ContractType t) {
    switch (t) {
      case ContractType.directSale: return 'بيع مباشر';
      case ContractType.usufructSale: return 'بيع انتفاع';
      case ContractType.commonShareSale: return 'بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'اتفاق ورثة';
      case ContractType.partition: return 'قسمة رضائية';
      case ContractType.settlement: return 'صلح ووساطة';
      case ContractType.promise: return 'وعد بالبيع';
      case ContractType.judicialSale: return 'بيع قضائي';
      case ContractType.judicialInheritance: return 'حصر إرث قضائي';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'تخارج قضائي';
      case ContractType.complexProperty: return 'محضر متعدد الوحدات';
    }
  }

  Future<void> _exportContract(Contract contract) async {
    try {
      final file = await _exportService.exportPdf(contract);
      await _exportService.shareFile(file);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التصدير: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteContract(BuildContext ctx, String id) async {
    final confirm = await showDialog<bool>(context: ctx, builder: (c) => AlertDialog(
      title: const Text('حذف العقد'),
      content: const Text('هل أنت متأكد من حذف هذا العقد؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
        TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
      ],
    ));
    if (confirm == true && mounted) await context.read<ContractProvider>().deleteContract(id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    final contracts = provider.savedContracts;
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الملفات'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => provider.loadContracts())]),
      body: contracts.isEmpty
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد عقود محفوظة', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ]))
        : ListView.builder(padding: const EdgeInsets.all(12),
            itemCount: contracts.length,
            itemBuilder: (_, index) {
              final c = contracts[index];
              final sellerName = c.sellers.isNotEmpty ? c.sellers.first.fullName : 'غير محدد';
              final buyerName = c.buyers.isNotEmpty ? c.buyers.first.fullName : 'غير محدد';
              return Card(child: ListTile(
                leading: CircleAvatar(backgroundColor: const Color(0xFF1B4F72),
                  child: Text(ArabicTextHelpers.toArabicDigits(index + 1), style: const TextStyle(color: Colors.white, fontSize: 12))),
                title: Text(_typeLabel(c.type), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('البائع: $sellerName'),
                  Text('المشتري: $buyerName'),
                  Text('التاريخ: ${c.contractDate.isEmpty ? 'غير محدد' : c.contractDate}'),
                ]),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(onSelected: (v) {
                  if (v == 'export') _exportContract(c);
                  if (v == 'delete') _deleteContract(context, c.id);
                }, itemBuilder: (_) => const [
                  PopupMenuItem(value: 'export', child: Row(children: [Icon(Icons.picture_as_pdf, size: 18), SizedBox(width: 6), Text('تصدير PDF')])),
                  PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 6), Text('حذف', style: TextStyle(color: Colors.red))])),
                ]),
              ));
            }),
    );
  }
}