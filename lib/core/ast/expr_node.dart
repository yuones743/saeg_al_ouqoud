abstract class ExprNode { const ExprNode(); }
class ValueExpr extends ExprNode { final Object? value; const ValueExpr(this.value); }
class VariableExpr extends ExprNode { final String name; const VariableExpr(this.name); }
class UnaryExpr extends ExprNode { final String op; final ExprNode operand; const UnaryExpr(this.op, this.operand); }
class BinaryExpr extends ExprNode { final String op; final ExprNode left; final ExprNode right; const BinaryExpr(this.op, this.left, this.right); }
class FunctionCallExpr extends ExprNode { final String name; final List<ExprNode> args; const FunctionCallExpr(this.name, this.args); }