import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/engine/rule_engine.dart';
import '../../core/engine/rule_metadata.dart';
import '../state/contract_provider.dart';

class WarningsCatalogScreen extends StatelessWidget {
  const WarningsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    final result = provider.lastResult;
    final allDecisions = result?.engineResult?.decisions ?? [];

    final allRules = RuleMetadata.all.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('كتالوج التحذيرات (٢٦)'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: allRules.length,
        itemBuilder: (_, index) {
          final entry = allRules[index];
          final info = entry.value;
          final triggered = allDecisions.any((d) => d.ruleId == info.id);
          return Card(
            color: triggered ? info.color.withOpacity(0.1) : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: info.color,
                child: Text(info.id.substring(1), style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
              title: Text(info.id, style: TextStyle(fontWeight: FontWeight.bold, color: triggered ? info.color : null)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الفئة: ${info.category}', style: const TextStyle(fontSize: 11)),
                  Text('المرجع: ${info.ref}', style: const TextStyle(fontSize: 11)),
                  if (triggered) Text('⚠️ مُفعّل في عقدك الحالي', style: TextStyle(fontSize: 11, color: info.color, fontWeight: FontWeight.bold)),
                ],
              ),
              isThreeLine: true,
              trailing: triggered ? Icon(Icons.check_circle, color: info.color) : const Icon(Icons.circle_outlined, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}