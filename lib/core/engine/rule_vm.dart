import '../ast/expr_node.dart';
import 'rule_execution_context.dart';

class RuleVM {
  Object? eval(ExprNode node, RuleExecutionContext ctx) {
    if (node is ValueExpr) return node.value;
    if (node is VariableExpr) return ctx.get(node.name);
    if (node is UnaryExpr) {
      final operand = eval(node.operand, ctx);
      switch (node.op) {
        case '!': return !(operand == true);
        case '-': if (operand is num) return -operand;
      }
    }
    if (node is BinaryExpr) {
      final left = eval(node.left, ctx);
      switch (node.op) {
        case '&&': if (left == false) return false; return eval(node.right, ctx) == true;
        case '||': if (left == true) return true; return eval(node.right, ctx) == true;
      }
      final right = eval(node.right, ctx);
      switch (node.op) {
        case '==': return _eq(left, right);
        case '!=': return !_eq(left, right);
        case '>': if (left is num && right is num) return left > right; return false;
        case '>=': if (left is num && right is num) return left >= right; return false;
        case '<': if (left is num && right is num) return left < right; return false;
        case '<=': if (left is num && right is num) return left <= right; return false;
        case '+': if (left is num && right is num) return left + right; return null;
        case '-': if (left is num && right is num) return left - right; return null;
        case '*': if (left is num && right is num) return left * right; return null;
        case '/': if (left is num && right is num && right != 0) return left / right; return null;
      }
    }
    if (node is FunctionCallExpr) return _evalFunction(node.name, node.args, ctx);
    return null;
  }

  bool _eq(Object? a, Object? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a == b;
  }

  Object? _evalFunction(String name, List<ExprNode> args, RuleExecutionContext ctx) {
    switch (name) {
      case 'isNull': return eval(args[0], ctx) == null;
      case 'isNotNull': return eval(args[0], ctx) != null;
      case 'isEmpty':
        final v = eval(args[0], ctx);
        if (v == null) return true;
        if (v is String) return v.trim().isEmpty;
        if (v is List) return v.isEmpty;
        return false;
      case 'contains':
        final list = eval(args[0], ctx);
        final item = eval(args[1], ctx);
        if (list is List) return list.contains(item);
        return false;
      case 'in':
        final item = eval(args[0], ctx);
        final list = eval(args[1], ctx);
        if (list is List) return list.contains(item);
        return false;
    }
    return null;
  }
}