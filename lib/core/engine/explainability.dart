import 'compiled_rule.dart';
import 'rule_execution_context.dart';
import 'rule_engine.dart';

class DecisionExplanation {
  final Decision decision;
  final String ruleName;
  final List<String> evidenceFields;
  final List<String> evidenceValues;
  final String recommendation;

  const DecisionExplanation({
    required this.decision,
    required this.ruleName,
    required this.evidenceFields,
    required this.evidenceValues,
    required this.recommendation,
  });

  String get fullText {
    final buf = StringBuffer();
    buf.writeln('القاعدة: ${decision.ruleId}');
    buf.writeln('الاسم: $ruleName');
    buf.writeln('الرسالة: ${decision.messageAr}');
    if (evidenceFields.isNotEmpty) {
      buf.writeln('الأدلة:');
      for (var i = 0; i < evidenceFields.length; i++) {
        buf.writeln('  • ${evidenceFields[i]} = ${evidenceValues[i]}');
      }
    }
    buf.writeln('التوصية: $recommendation');
    return buf.toString();
  }
}

class ExplainabilityService {
  static DecisionExplanation explain(Decision d, RuleExecutionContext ctx) {
    final fields = <String>[];
    final values = <String>[];
    if (d.ruleId == 'W001') {
      fields.add('seller_is_minor'); values.add('${ctx.get('seller_is_minor')}');
    } else if (d.ruleId == 'W008') {
      fields.add('buyer_is_foreign'); values.add('${ctx.get('buyer_is_foreign')}');
    } else if (d.ruleId == 'W020') {
      fields.add('has_pregnant_heir'); values.add('${ctx.get('has_pregnant_heir')}');
    }

    return DecisionExplanation(
      decision: d,
      ruleName: 'القاعدة ${d.ruleId}',
      evidenceFields: fields,
      evidenceValues: values,
      recommendation: 'يُنصح بمراجعة المختص القانوني قبل الاستمرار.',
    );
  }
}