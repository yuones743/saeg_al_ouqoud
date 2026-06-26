import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    final contracts = provider.savedContracts;
    final totalPrice = contracts.fold<double>(0, (a, c) => a + c.payment.totalPrice);
    final totalHeirs = contracts.fold<int>(0, (a, c) => a + c.heirs.length);

    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _statCard('عدد العقود المحفوظة', ArabicTextHelpers.toArabicDigits(contracts.length), Icons.description, Colors.blue),
        const SizedBox(height: 8),
        _statCard('إجمالي قيمة العقود', '${ArabicTextHelpers.toArabicDigits(totalPrice.toInt())} ل.س', Icons.attach_money, Colors.green),
        const SizedBox(height: 8),
        _statCard('عدد الورثة المعالجين', ArabicTextHelpers.toArabicDigits(totalHeirs), Icons.people, Colors.orange),
        const SizedBox(height: 16),
        const Text('توزيع العقود حسب النوع:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._countByType(contracts).entries.map((e) => Card(child: ListTile(
          leading: const Icon(Icons.folder),
          title: Text(e.key, style: const TextStyle(fontSize: 13)),
          trailing: Text(ArabicTextHelpers.toArabicDigits(e.value), style: const TextStyle(fontWeight: FontWeight.bold)),
        ))),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ]),
      ),
    );
  }

  Map<String, int> _countByType(List contracts) {
    final map = <String, int>{};
    for (final c in contracts) {
      final t = c.type.toString().split('.').last;
      map[t] = (map[t] ?? 0) + 1;
    }
    return map;
  }
}