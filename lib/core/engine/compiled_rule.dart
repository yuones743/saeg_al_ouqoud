import '../ast/expr_node.dart';

class CompiledRule {
  final String id;
  final String version;
  final int priority;
  final ExprNode ast;
  final RuleAction action;

  const CompiledRule({
    required this.id,
    required this.version,
    required this.priority,
    required this.ast,
    required this.action,
  });
}

class RuleAction {
  final String type;
  final String severity;
  final String messageAr;
  final Map<String, dynamic> metadata;

  const RuleAction({
    required this.type,
    required this.severity,
    required this.messageAr,
    this.metadata = const {},
  });
}