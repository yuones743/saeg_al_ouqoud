import 'package:flutter/material.dart';
import '../../core/inheritance/inheritance_calculator.dart';
import '../../core/utils/arabic_text_helpers.dart';

class HeirsSummaryScreen extends StatelessWidget {
  final InheritanceResult result;
  const HeirsSummaryScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final activeShares = result.shares.where((s) => !s.isExcluded).toList();
    final excludedShares = result.shares.where((s) => s.isExcluded).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص توزيع الإرث'),
        backgroundColor: const Color(0xFF1B4F72),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── بطاقة المعلومات العامة ──────────────────────────────────────
          Card(
            color: const Color(0xFF1B4F72),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ملخص التوزيع',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مسار: ${result.path}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'إجمالي الأسهم: ${ArabicTextHelpers.toArabicDigits(result.activeTotal)} / ${ArabicTextHelpers.toArabicDigits(result.totalShares)}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  if (result.hasAwl)
                    const Text(
                      '⚠️ تم تطبيق العول',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                    ),
                  if (result.hasRadd)
                    const Text(
                      '🔄 تم تطبيق الرد',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                    ),
                  if (result.isKalala)
                    const Text(
                      'حالة كلالة',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                    ),
                  if (result.hasPendingPregnancy)
                    const Text(
                      'يوجد حمل منتظر – القسمة موقوفة',
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),

          // ─── التحذيرات ────────────────────────────────────────────────────
          if (result.warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التحذيرات',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 6),
                    ...result.warnings.map((w) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Expanded(child: Text(w, style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],

          // ─── خطوات الحساب ──────────────────────────────────────────────────
          if (result.calculationSteps.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 خطوات الحساب',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    ...result.calculationSteps.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text('• $s', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    )),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // ─── الورثة المستحقون ────────────────────────────────────────────
          const Text(
            'الورثة المستحقون',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          ...activeShares.map((s) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1B4F72),
                radius: 20,
                child: Text(
                  ArabicTextHelpers.simplifyFraction(s.shares, result.totalShares),
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
              title: Text(
                s.heirName.isEmpty ? s.heirId : s.heirName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.relation),
                  if (s.shareCategory.isNotEmpty)
                    Text(
                      'الفئة: ${s.shareCategory}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ArabicTextHelpers.toArabicDigits(s.shares),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${(s.fraction * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )),

          // ─── الورثة المحرومون ─────────────────────────────────────────────
          if (excludedShares.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'الورثة المحرومون',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
            ),
            const SizedBox(height: 6),
            ...excludedShares.map((s) => Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: Text(s.heirName.isEmpty ? s.heirId : s.heirName),
                subtitle: Text('${s.relation} – ${s.exclusionReason}'),
              ),
            )),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
