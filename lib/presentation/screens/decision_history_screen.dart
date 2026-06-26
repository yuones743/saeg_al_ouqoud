import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/audit/audit_service.dart';
import '../../core/utils/arabic_text_helpers.dart';

class DecisionHistoryScreen extends StatefulWidget {
  const DecisionHistoryScreen({super.key});

  @override
  State<DecisionHistoryScreen> createState() => _DecisionHistoryScreenState();
}

class _DecisionHistoryScreenState extends State<DecisionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final records = AuditService.instance.records;
    return Scaffold(
      appBar: AppBar(title: const Text('تاريخ القرارات')),
      body: records.isEmpty
        ? const Center(child: Text('لا توجد قرارات مسجلة بعد', style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: records.length,
            itemBuilder: (_, index) {
              final r = records[index];
              return Card(
                child: ExpansionTile(
                  leading: Icon(
                    r.decisionResult == 'blocked' ? Icons.error : Icons.check_circle,
                    color: r.decisionResult == 'blocked' ? Colors.red : Colors.green,
                  ),
                  title: Text('العقد #${r.contractId.substring(0, 8)}'),
                  subtitle: Text('${ArabicTextHelpers.toArabicDigits(r.decisions.length)} قرار – ${ArabicTextHelpers.toArabicDigits(r.timestamp.hour)}:${ArabicTextHelpers.toArabicDigits(r.timestamp.minute)}'),
                  children: r.decisions.map((d) => ListTile(
                    leading: Icon(Icons.arrow_left, size: 14),
                    title: Text('[${d.ruleId}] ${d.messageAr}', style: const TextStyle(fontSize: 12)),
                  )).toList(),
                ),
              );
            },
          ),
    );
  }
}