import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InheritanceMethodsReferenceScreen extends StatefulWidget {
  const InheritanceMethodsReferenceScreen({super.key});

  @override
  State<InheritanceMethodsReferenceScreen> createState() => _InheritanceMethodsReferenceScreenState();
}

class _InheritanceMethodsReferenceScreenState extends State<InheritanceMethodsReferenceScreen> {
  final Map<String, double> _stocks = {};
  final _heirCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final total = _stocks.values.fold<double>(0, (a, b) => a + b);
    final remaining = 2400 - total;
    return Scaffold(
      appBar: AppBar(title: const Text('مرجع الإرث اليدوي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1B4F72), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('المخصص: ${2400 - remaining.toInt()}', style: const TextStyle(color: Colors.white)),
                Text('المتبقي: ${remaining.toInt()}', style: TextStyle(color: remaining < 0 ? Colors.red : Colors.greenAccent)),
                const Text('الإجمالي: 2400', style: TextStyle(color: Colors.white)),
              ]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _heirCtrl, decoration: const InputDecoration(labelText: 'اسم الوارث', border: OutlineInputBorder(), isDense: true))),
                const SizedBox(width: 8),
                SizedBox(width: 100, child: TextField(controller: _sharesCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'أسهم', border: OutlineInputBorder(), isDense: true))),
                IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () {
                  if (_heirCtrl.text.isNotEmpty && _sharesCtrl.text.isNotEmpty) {
                    setState(() {
                      _stocks[_heirCtrl.text] = double.tryParse(_sharesCtrl.text) ?? 0;
                      _heirCtrl.clear();
                      _sharesCtrl.clear();
                    });
                  }
                }),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: _stocks.entries.map((e) {
                  final percent = (e.value / 2400) * 100;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${e.value.toInt()}')),
                      title: Text(e.key),
                      subtitle: Text('${percent.toStringAsFixed(2)}%'),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _stocks.remove(e.key))),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}