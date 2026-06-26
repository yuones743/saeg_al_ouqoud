import '../../core/engine/compiled_rule.dart';
import '../../core/engine/rule_engine.dart';
import 'rule_loader.dart';

class RuleEngineFactory {
  static RuleEngine? _engine;

  static Future<RuleEngine> getInstance() async {
    if (_engine != null) return _engine!;
    final rules = await RuleLoader.load();
    _engine = RuleEngine(rules);
    return _engine!;
  }

  static void reset() {
    _engine = null;
  }
}