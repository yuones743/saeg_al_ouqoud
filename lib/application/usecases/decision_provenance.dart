import '../../core/engine/rule_engine.dart';

class ProvenanceRecord {
  final String ruleId;
  final String field;
  final Object? value;
  final DateTime timestamp;

  ProvenanceRecord({required this.ruleId, required this.field, required this.value, required this.timestamp});

  Map<String, dynamic> toMap() => {
    'rule_id': ruleId,
    'field': field,
    'value': value,
    'timestamp': timestamp.toIso8601String(),
  };
}

class DecisionTrace {
  final List<ProvenanceRecord> records = [];
  final List<Decision> decisions = [];

  void add(ProvenanceRecord r) => records.add(r);
  void addDecision(Decision d) => decisions.add(d);

  String explainDecision(Decision d) {
    final buf = StringBuffer();
    buf.writeln('القاعدة: ${d.ruleId}');
    buf.writeln('الخطورة: ${d.severity.name}');
    buf.writeln('الرسالة: ${d.messageAr}');
    final rel = records.where((r) => r.ruleId == d.ruleId).toList();
    if (rel.isNotEmpty) {
      buf.writeln('الحقول المؤثرة:');
      for (final r in rel) {
        buf.writeln('  - ${r.field} = ${r.value}');
      }
    }
    return buf.toString();
  }

  String get fullTrace {
    final buf = StringBuffer();
    buf.writeln('=== شجرة التتبع ===');
    buf.writeln('عدد القرارات: ${decisions.length}');
    buf.writeln('عدد سجلات الإثبات: ${records.length}');
    buf.writeln('');
    for (final d in decisions) {
      buf.writeln(explainDecision(d));
      buf.writeln('---');
    }
    return buf.toString();
  }
}