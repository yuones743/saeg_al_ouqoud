import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/audit/audit_service.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  List<AuditRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final contract = context.read<ContractProvider>().contract;
    final recs = await AuditService.instance.loadForContract(contract.id);
    setState(() => _records = recs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل التدقيق'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: () async {
            await AuditService.instance.clearAll();
            await _loadRecords();
          }),
        ],
      ),
      body: _records.isEmpty
        ? const Center(child: Text('لا توجد سجلات تدقيق بعد.'))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _records.length,
            itemBuilder: (_, index) {
              final r = _records[index];
              return Card(
                child: ExpansionTile(
                  leading: Icon(
                    r.decisionResult == 'blocked' ? Icons.error : Icons.check_circle,
                    color: r.decisionResult == 'blocked' ? Colors.red : Colors.green,
                  ),
                  title: Text('العقد: ${r.contractId.substring(0, 8)}...'),
                  subtitle: Text('${ArabicTextHelpers.toArabicDigits(r.decisions.length)} قرار – ${r.timestamp.toString().substring(0, 16)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('بصمة SHA256: ${r.decisionHash.substring(0, 16)}...'),
                          const SizedBox(height: 8),
                          const Text('القرارات:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...r.decisions.map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• [${d.ruleId}] ${d.messageAr} (${d.severity.name})', style: const TextStyle(fontSize: 11)),
                          )),
                        ],
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