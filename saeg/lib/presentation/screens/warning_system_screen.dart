import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/engine/rule_engine.dart';
import '../../domain/validation/contract_validator.dart';
import '../state/contract_provider.dart';
import 'pdf_preview_screen.dart';

class WarningSystemScreen extends StatelessWidget {
  const WarningSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    final result = provider.lastResult;
    final engineResult = result?.engineResult;
    final validationFailures = result?.validationFailures ?? [];
    final blockingDecisions = engineResult?.blocking ?? [];
    final warningDecisions = engineResult?.warnings ?? [];
    final infoDecisions = engineResult?.info ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('نتائج الفحص القانوني')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatusBanner(
            blockingCount: blockingDecisions.length,
            warningCount: warningDecisions.length +
                validationFailures.where((f) => f.severity == 'warning').length,
          ),
          const SizedBox(height: 12),
          if (blockingDecisions.isNotEmpty) ...[
            _SectionHeader(
                title: 'تحذيرات إلزامية (${blockingDecisions.length})',
                color: Colors.red),
            ...blockingDecisions.map((d) => _DecisionTile(decision: d)),
          ],
          if (warningDecisions.isNotEmpty) ...[
            _SectionHeader(
                title: 'تحذيرات (${warningDecisions.length})',
                color: Colors.orange),
            ...warningDecisions.map((d) => _DecisionTile(decision: d)),
          ],
          if (validationFailures.isNotEmpty) ...[
            _SectionHeader(
                title: 'ملاحظات التحقق (${validationFailures.length})',
                color: Colors.amber),
            ...validationFailures.map((f) => _ValidationTile(failure: f)),
          ],
          if (infoDecisions.isNotEmpty) ...[
            _SectionHeader(
                title: 'معلومات (${infoDecisions.length})',
                color: Colors.blue),
            ...infoDecisions.map((d) => _DecisionTile(decision: d)),
          ],
          if (blockingDecisions.isEmpty &&
              warningDecisions.isEmpty &&
              validationFailures.isEmpty &&
              infoDecisions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'لا توجد تحذيرات. العقد نظيف.',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ملاحظة: التحذيرات تظهر هنا فقط ولا تُطبع على العقد. يمكن توليد العقد في جميع الأحوال.',
                  style: TextStyle(fontSize: 11, color: Colors.green),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('معاينة العقد وتصديره',
                style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            // Fixed: use Navigator.push (not pushReplacement) to allow going back
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PdfPreviewScreen()),
            ),
          ),
          const SizedBox(height: 12),
          // Fixed: added SnackBar success/failure notification for save
          OutlinedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ العقد'),
            onPressed: () async {
              try {
                await provider.saveContract();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ العقد بنجاح ✓'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل حفظ العقد: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final int blockingCount;
  final int warningCount;
  const _StatusBanner(
      {required this.blockingCount, required this.warningCount});

  @override
  Widget build(BuildContext context) {
    final color = blockingCount > 0
        ? Colors.red
        : warningCount > 0
            ? Colors.orange
            : Colors.green;
    final icon = blockingCount > 0
        ? Icons.error
        : warningCount > 0
            ? Icons.warning_amber
            : Icons.check_circle;
    final text = blockingCount > 0
        ? 'يوجد $blockingCount تحذير إلزامي – يُنصح بمراجعة المختص'
        : warningCount > 0
            ? 'يوجد $warningCount تحذير – راجع التفاصيل'
            : 'العقد اجتاز الفحص بنجاح';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: color)),
    );
  }
}

class _DecisionTile extends StatelessWidget {
  final Decision decision;
  const _DecisionTile({required this.decision});

  @override
  Widget build(BuildContext context) {
    final color = decision.severity == DecisionSeverity.blocking
        ? Colors.red
        : decision.severity == DecisionSeverity.warning
            ? Colors.orange
            : Colors.blue;
    final icon = decision.severity == DecisionSeverity.blocking
        ? Icons.block
        : decision.severity == DecisionSeverity.warning
            ? Icons.warning_amber
            : Icons.info_outline;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(decision.messageAr,
            style: const TextStyle(fontSize: 13)),
        subtitle: Text('القاعدة: ${decision.ruleId}',
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
        dense: true,
      ),
    );
  }
}

class _ValidationTile extends StatelessWidget {
  final ValidationFailure failure;
  const _ValidationTile({required this.failure});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: const Icon(Icons.edit_note, color: Colors.amber),
        title: Text(failure.messageAr,
            style: const TextStyle(fontSize: 13)),
        dense: true,
      ),
    );
  }
}
