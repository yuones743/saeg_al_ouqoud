import '../ast/expr_node.dart';
import 'compiled_rule.dart';

class RuleSetCompiler {
  List<CompiledRule> compileAll(List<Map<String, dynamic>> rawRules) {
    return rawRules.map((r) => RuleCompiler().compile(r)).toList();
  }
}

class RuleCompiler {
  CompiledRule compile(Map<String, dynamic> raw) {
    final ast = _parseExpr(raw['condition'] as Map<String, dynamic>);
    final actionRaw = raw['action'] as Map<String, dynamic>;
    final action = RuleAction(
      type: actionRaw['type'] as String,
      severity: actionRaw['severity'] as String,
      messageAr: actionRaw['message_ar'] as String,
      metadata: (actionRaw['metadata'] as Map<String, dynamic>?) ?? const {},
    );
    return CompiledRule(
      id: raw['id'] as String,
      version: (raw['version'] as String?) ?? '1.0',
      priority: (raw['priority'] as int?) ?? 50,
      ast: ast,
      action: action,
    );
  }

  ExprNode _parseExpr(Map<String, dynamic> node) {
    final type = node['type'] as String;
    switch (type) {
      case 'value': return ValueExpr(node['value']);
      case 'variable': return VariableExpr(node['name'] as String);
      case 'unary': return UnaryExpr(node['op'] as String, _parseExpr(node['operand'] as Map<String, dynamic>));
      case 'binary': return BinaryExpr(node['op'] as String, _parseExpr(node['left'] as Map<String, dynamic>), _parseExpr(node['right'] as Map<String, dynamic>));
      case 'call':
        final args = (node['args'] as List<dynamic>).map((a) => _parseExpr(a as Map<String, dynamic>)).toList();
        return FunctionCallExpr(node['name'] as String, args);
    }
    throw ArgumentError('Unknown expr node type: $type');
  }
}