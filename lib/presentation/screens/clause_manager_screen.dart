import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';

class ClauseManagerScreen extends StatefulWidget {
  const ClauseManagerScreen({super.key});

  @override
  State<ClauseManagerScreen> createState() => _ClauseManagerScreenState();
}

class _ClauseManagerScreenState extends State<ClauseManagerScreen> {
  void _addClause() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إضافة بند'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: titleCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'عنوان البند', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: bodyCtrl, textDirection: TextDirection.rtl, maxLines: 4, decoration: const InputDecoration(labelText: 'نص البند', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(onPressed: () {
          if (titleCtrl.text.trim().isNotEmpty && bodyCtrl.text.trim().isNotEmpty) {
            context.read<ContractProvider>().addClause(ContractClause(
              id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
              titleAr: titleCtrl.text, bodyAr: bodyCtrl.text));
            Navigator.pop(ctx);
          }
        }, child: const Text('إضافة')),
      ],
    )).then((_) { titleCtrl.dispose(); bodyCtrl.dispose(); });
  }

  void _editClause(int index, ContractClause clause) {
    final titleCtrl = TextEditingController(text: clause.titleAr);
    final bodyCtrl = TextEditingController(text: clause.bodyAr);
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('تعديل البند'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: titleCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: bodyCtrl, textDirection: TextDirection.rtl, maxLines: 4, decoration: const InputDecoration(labelText: 'النص', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(onPressed: () {
          context.read<ContractProvider>().updateClause(index, clause.copyWith(titleAr: titleCtrl.text, bodyAr: bodyCtrl.text));
          Navigator.pop(ctx);
        }, child: const Text('حفظ')),
      ],
    )).then((_) { titleCtrl.dispose(); bodyCtrl.dispose(); });
  }

  @override
  Widget build(BuildContext context) {
    final clauses = context.watch<ContractProvider>().contract.customClauses;
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة البنود الإضافية'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addClause, tooltip: 'إضافة بند')]),
      body: clauses.isEmpty
        ? const Center(child: Text('لا توجد بنود إضافية. اضغط + لإضافة بند.'))
        : ListView.builder(padding: const EdgeInsets.all(12),
            itemCount: clauses.length,
            itemBuilder: (_, index) {
              final clause = clauses[index];
              return Card(child: ListTile(
                title: Text(clause.titleAr, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(clause.bodyAr, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editClause(index, clause)),
                  IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => context.read<ContractProvider>().removeClause(index)),
                ]),
              ));
            }),
      floatingActionButton: FloatingActionButton(onPressed: _addClause, child: const Icon(Icons.add)),
    );
  }
}