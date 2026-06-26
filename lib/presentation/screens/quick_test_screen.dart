import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/inheritance/inheritance_calculator.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../state/contract_provider.dart';

class QuickTestScreen extends StatefulWidget {
  const QuickTestScreen({super.key});

  @override
  State<QuickTestScreen> createState() => _QuickTestScreenState();
}

class _QuickTestScreenState extends State<QuickTestScreen> {
  String _result = 'اضغط "تشغيل اختبار" لاختبار الحاسبة بقضية تجريبية';

  void _runTest() {
    final calc = InheritanceCalculator();
    final heirs = [
      Heir(person: Person(id: 'w', fullName: 'زوجة', role: PersonRole.heir), shares: 0, relation: 'زوجة'),
      Heir(person: Person(id: 's1', fullName: 'ابن ١', role: PersonRole.heir), shares: 0, relation: 'ابن'),
      Heir(person: Person(id: 's2', fullName: 'ابن ٢', role: PersonRole.heir), shares: 0, relation: 'ابن'),
      Heir(person: Person(id: 'd1', fullName: 'ابنة ١', role: PersonRole.heir), shares: 0, relation: 'ابنة'),
      Heir(person: Person(id: 'd2', fullName: 'ابنة ٢', role: PersonRole.heir), shares: 0, relation: 'ابنة'),
      Heir(person: Person(id: 'm', fullName: 'الأم', role: PersonRole.heir), shares: 0, relation: 'أم'),
    ];
    final result = calc.calculate(
      heirs: heirs, isKalala: false, isAmiriaLand: false,
      willExceedsThird: false, willHasHeirConsent: false,
    );
    final buf = StringBuffer();
    buf.writeln('=== نتيجة الاختبار ===');
    buf.writeln('المسار: ${result.path}');
    buf.writeln('إجمالي الأسهم: ${result.activeTotal}');
    buf.writeln('');
    for (final s in result.shares) {
      buf.writeln('${s.heirName}: ${s.shares} سهم (${s.fractionLabel})');
    }
    setState(() => _result = buf.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختبار سريع')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('تشغيل اختبار الحاسبة'),
            onPressed: _runTest,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4F72), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
          ),
          const SizedBox(height: 12),
          Expanded(child: SingleChildScrollView(child: SelectableText(_result, style: const TextStyle(fontSize: 13)))),
        ]),
      ),
    );
  }
}