import 'compiled_rule.dart';
import 'rule_execution_context.dart';
import 'rule_engine.dart';

extension RuleEngineExtensions on RuleEngine {
  List<Decision> getMatchingDecisions(RuleExecutionContext ctx) {
    return evaluate(ctx).decisions;
  }

  bool hasBlockingDecision(RuleExecutionContext ctx) {
    return evaluate(ctx).blocking.isNotEmpty;
  }
}