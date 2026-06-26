import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/inheritance/inheritance_calculator.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';
import 'heirs_summary_screen.dart';

class InheritanceCalculatorScreen extends StatefulWidget {
  const InheritanceCalculatorScreen({super.key});

  @override
  State<InheritanceCalculatorScreen> createState() => _InheritanceCalculatorScreenState();
}

class _InheritanceCalculatorScreenState extends State<InheritanceCalculatorScreen> {
  InheritanceResult? _result;
  final InheritanceCalculator _calculator = InheritanceCalculator();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculate());
  }

  void _calculate() {
    final contract = context.read<ContractProvider>().contract;
    if (contract.heirs.isEmpty) return;
    final result = _calculator.calculate(
      heirs: contract.heirs,
      isKalala: contract.isKalala,
      isAmiriaLand: contract.property.isAmiriaLand,
      willExceedsThird: contract.willExceedsThird,
      willHasHeirConsent: contract.willHasHeirConsent,
    );
    setState(() => _result = result);
  }

  Color _shareColor(int shares) {
    if (shares == 0) return Colors.red.shade100;
    if (shares < 200) return Colors.orange.shade50;
    return Colors.green.shade50;
  }

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة المواريث – ٢٤٠٠ سهم'),
        actions: [
          if (result != null)
            IconButton(icon: const Icon(Icons.summarize), tooltip: 'ملخص الورثة',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HeirsSummaryScreen(result: result)))),
        ],
      ),
      body: contract.heirs.isEmpty
        ? const Center(child: Padding(padding: EdgeInsets.all(24),
            child: Text('لا يوجد ورثة. أضف ورثة من شاشة عقد الإرث أولاً.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey))))
        : Column(children: [
            if (result != null) ...[
              Container(padding: const EdgeInsets.all(12), color: const Color(0xFF1B4F72),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _statChip('مسار التوزيع', result.path),
                  _statChip('الإجمالي', ArabicTextHelpers.toArabicDigits(result.activeTotal)),
                  _statChip('الورثة', ArabicTextHelpers.toArabicDigits(result.shares.where((s) => !s.isExcluded).length)),
                ]),
              ),
              if (result.warnings.isNotEmpty)
                Container(color: Colors.orange.shade50, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.warnings.map((w) => Row(children: [
                      const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                      const SizedBox(width: 6),
                      Expanded(child: Text(w, style: const TextStyle(fontSize: 12, color: Colors.orange))),
                    ])).toList())),
            ],
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: result?.shares.length ?? contract.heirs.length,
              itemBuilder: (_, index) {
                if (result == null) {
                  final heir = contract.heirs[index];
                  return Card(child: ListTile(title: Text(heir.person.fullName.isEmpty ? 'وارث ${index + 1}' : heir.person.fullName), subtitle: Text(heir.relation)));
                }
                final share = result.shares[index];
                return Card(color: share.isExcluded ? Colors.red.shade50 : _shareColor(share.shares),
                  child: Padding(padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(share.heirName.isEmpty ? 'وارث ${index + 1}' : share.heirName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(share.relation, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        if (share.isExcluded) Text('محروم: ${share.exclusionReason}', style: const TextStyle(fontSize: 11, color: Colors.red)),
                      ])),
                      if (!share.isExcluded) ...[
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('${ArabicTextHelpers.toArabicDigits(share.shares)} / ${ArabicTextHelpers.toArabicDigits(InheritanceCalculator.totalShares)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(share.fractionLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('${(share.fraction * 100).toStringAsFixed(2)}%', style: const TextStyle(fontSize: 12)),
                        ]),
                      ] else const Icon(Icons.block, color: Colors.red),
                    ]),
                  ),
                );
              },
            )),
            Padding(padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(icon: const Icon(Icons.calculate), label: const Text('إعادة الحساب'),
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4F72), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 46)))),
          ]),
    );
  }

  Widget _statChip(String label, String value) => Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
  ]);
}