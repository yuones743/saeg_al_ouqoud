import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/engine/rule_engine.dart';
import '../../core/engine/explainability.dart';
import '../state/contract_provider.dart';

class DecisionExplainerScreen extends StatelessWidget {
  const DecisionExplainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.watch<ContractProvider>().lastResult?.engineResult;
    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('شرح القرارات')),
        body: const Center(child: Text('لا توجد قرارات للعرض. قم بفحص عقد أولاً.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('شرح القرارات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: result.decisions.length,
        itemBuilder: (_, index) {
          final d = result.decisions[index];
          return Card(
            child: ExpansionTile(
              leading: Icon(Icons.lightbulb, color: d.severity == DecisionSeverity.warning ? Colors.orange : Colors.blue),
              title: Text(d.messageAr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: Text('القاعدة: ${d.ruleId}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'الخطورة: ${d.severity.name}\n'
                    'التوصية: مراجعة المختص القانوني',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}