import 'compiled_rule.dart';
import 'rule_execution_context.dart';
import 'rule_vm.dart';

enum DecisionSeverity { blocking, warning, info }

class Decision {
  final String ruleId;
  final DecisionSeverity severity;
  final String messageAr;
  final Map<String, dynamic> metadata;

  const Decision({required this.ruleId, required this.severity, required this.messageAr, this.metadata = const {}});
}

class EvaluationResult {
  final List<Decision> decisions;
  EvaluationResult(this.decisions);

  bool get hasBlockingDecisions => decisions.any((d) => d.severity == DecisionSeverity.blocking);
  List<Decision> get warnings => decisions.where((d) => d.severity == DecisionSeverity.warning).toList();
  List<Decision> get blocking => decisions.where((d) => d.severity == DecisionSeverity.blocking).toList();
  List<Decision> get info => decisions.where((d) => d.severity == DecisionSeverity.info).toList();
}

class RuleEngine {
  final List<CompiledRule> _rules;
  final RuleVM _vm = RuleVM();

  RuleEngine(this._rules);

  EvaluationResult evaluate(RuleExecutionContext ctx) {
    final sorted = List<CompiledRule>.from(_rules)..sort((a, b) => b.priority.compareTo(a.priority));
    final decisions = <Decision>[];
    for (final rule in sorted) {
      try {
        final result = _vm.eval(rule.ast, ctx);
        if (result == true) decisions.add(_buildDecision(rule));
      } catch (_) { continue; }
    }
    return EvaluationResult(decisions);
  }

  Decision _buildDecision(CompiledRule rule) {
    final severityStr = rule.action.severity;
    final severity = severityStr == 'blocking'
        ? DecisionSeverity.blocking
        : severityStr == 'warning'
            ? DecisionSeverity.warning
            : DecisionSeverity.info;
    return Decision(
      ruleId: rule.id,
      severity: severity,
      messageAr: rule.action.messageAr,
      metadata: rule.action.metadata,
    );
  }
}