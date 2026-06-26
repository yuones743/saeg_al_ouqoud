import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';

class AnnexManagerScreen extends StatefulWidget {
  const AnnexManagerScreen({super.key});

  @override
  State<AnnexManagerScreen> createState() => _AnnexManagerScreenState();
}

class _AnnexManagerScreenState extends State<AnnexManagerScreen> {
  void _addAnnex() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إضافة ملحق'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: titleCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'عنوان الملحق', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: bodyCtrl, textDirection: TextDirection.rtl, maxLines: 5, decoration: const InputDecoration(labelText: 'نص الملحق', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(onPressed: () {
          if (titleCtrl.text.trim().isNotEmpty) {
            final provider = context.read<ContractProvider>();
            final count = provider.contract.annexes.length + 1;
            provider.addAnnex(ContractAnnex(number: count, titleAr: titleCtrl.text, bodyAr: bodyCtrl.text));
            Navigator.pop(ctx);
          }
        }, child: const Text('إضافة')),
      ],
    )).then((_) { titleCtrl.dispose(); bodyCtrl.dispose(); });
  }

  @override
  Widget build(BuildContext context) {
    final annexes = context.watch<ContractProvider>().contract.annexes;
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الملاحق'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addAnnex, tooltip: 'إضافة ملحق')]),
      body: annexes.isEmpty
        ? const Center(child: Text('لا توجد ملاحق. اضغط + لإضافة ملحق.'))
        : ListView.builder(padding: const EdgeInsets.all(12),
            itemCount: annexes.length,
            itemBuilder: (_, index) {
              final annex = annexes[index];
              return Card(child: ListTile(
                leading: CircleAvatar(child: Text('${annex.number}')),
                title: Text(annex.titleAr, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(annex.bodyAr, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => context.read<ContractProvider>().removeAnnex(index)),
              ));
            }),
      floatingActionButton: FloatingActionButton(onPressed: _addAnnex, child: const Icon(Icons.add)),
    );
  }
}