import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../state/contract_provider.dart';

class WitnessManagerScreen extends StatefulWidget {
  const WitnessManagerScreen({super.key});

  @override
  State<WitnessManagerScreen> createState() => _WitnessManagerScreenState();
}

class _WitnessManagerScreenState extends State<WitnessManagerScreen> {
  void _addWitness() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إضافة شاهد'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'اسم الشاهد', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: idCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'الرقم الوطني', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: phoneCtrl, textDirection: TextDirection.rtl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(onPressed: () {
          if (nameCtrl.text.trim().isNotEmpty) {
            context.read<ContractProvider>().addWitness(Person(
              id: 'witness_${DateTime.now().millisecondsSinceEpoch}',
              fullName: nameCtrl.text, nationalId: idCtrl.text, phone: phoneCtrl.text, role: PersonRole.witness));
            Navigator.pop(ctx);
          }
        }, child: const Text('إضافة')),
      ],
    )).then((_) { nameCtrl.dispose(); idCtrl.dispose(); phoneCtrl.dispose(); });
  }

  @override
  Widget build(BuildContext context) {
    final witnesses = context.watch<ContractProvider>().contract.witnesses;
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الشهود'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addWitness, tooltip: 'إضافة شاهد')]),
      body: witnesses.isEmpty
        ? const Center(child: Text('لا يوجد شهود. اضغط + لإضافة شاهد.'))
        : ListView.builder(padding: const EdgeInsets.all(12),
            itemCount: witnesses.length,
            itemBuilder: (_, index) {
              final w = witnesses[index];
              return Card(child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(w.fullName),
                subtitle: Text('الرقم الوطني: ${w.nationalId.isEmpty ? 'غير محدد' : w.nationalId}\nالهاتف: ${w.phone.isEmpty ? 'غير محدد' : w.phone}'),
                isThreeLine: true,
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => context.read<ContractProvider>().removeWitness(index)),
              ));
            }),
      floatingActionButton: FloatingActionButton(onPressed: _addWitness, child: const Icon(Icons.person_add)),
    );
  }
}