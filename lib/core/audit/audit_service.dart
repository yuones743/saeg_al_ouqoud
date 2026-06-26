import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import '../engine/rule_engine.dart';
import '../../data/local/database_helper.dart';

class AuditRecord {
  final String contractId;
  final String decisionHash;
  final String decisionResult;
  final DateTime timestamp;
  final List<Decision> decisions;

  AuditRecord({
    required this.contractId,
    required this.decisionHash,
    required this.decisionResult,
    required this.timestamp,
    required this.decisions,
  });

  Map<String, Object?> toMap() => {
        'contract_id': contractId,
        'decision_hash': decisionHash,
        'decision_result': decisionResult,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'decisions_json': jsonEncode(decisions
            .map((d) => {
                  'rule_id': d.ruleId,
                  'severity': d.severity.name,
                  'message_ar': d.messageAr,
                  'metadata': d.metadata,
                })
            .toList()),
      };
}

class AuditService {
  static final AuditService _instance = AuditService._();
  factory AuditService() => _instance;
  static AuditService get instance => _instance;
  AuditService._();

  final List<AuditRecord> _memory = <AuditRecord>[];

  Future<void> record(String contractId, EvaluationResult result) async {
    final payload = result.decisions.map((d) => '${d.ruleId}:${d.severity.name}:${d.messageAr}').join('|');
    final hash = sha256.convert(utf8.encode(payload)).toString();
    final rec = AuditRecord(
      contractId: contractId,
      decisionHash: hash,
      decisionResult: result.hasBlockingDecisions ? 'blocked' : 'passed',
      timestamp: DateTime.now(),
      decisions: List<Decision>.from(result.decisions),
    );
    _memory.add(rec);
    try {
      final db = await DatabaseHelper().database;
      await db.insert('audit_log', rec.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {}
  }

  Future<List<AuditRecord>> loadForContract(String contractId) async {
    try {
      final db = await DatabaseHelper().database;
      final rows = await db.query('audit_log', where: 'contract_id = ?', whereArgs: [contractId], orderBy: 'timestamp DESC');
      return rows.map((r) {
        final list = (jsonDecode(r['decisions_json'] as String) as List<dynamic>).map((m) {
          final map = (m as Map).cast<String, dynamic>();
          return Decision(
            ruleId: map['rule_id'] as String,
            severity: DecisionSeverity.values.firstWhere((s) => s.name == map['severity'] as String, orElse: () => DecisionSeverity.info),
            messageAr: map['message_ar'] as String,
            metadata: (map['metadata'] as Map<String, dynamic>?) ?? const {},
          );
        }).toList();
        return AuditRecord(
          contractId: r['contract_id'] as String,
          decisionHash: r['decision_hash'] as String,
          decisionResult: r['decision_result'] as String,
          timestamp: DateTime.fromMillisecondsSinceEpoch(r['timestamp'] as int),
          decisions: list,
        );
      }).toList();
    } catch (_) { return <AuditRecord>[]; }
  }

  Future<void> clearAll() async {
    _memory.clear();
    try {
      final db = await DatabaseHelper().database;
      await db.delete('audit_log');
    } catch (_) {}
  }
}