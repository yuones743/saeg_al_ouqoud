import '../../core/engine/compiled_rule.dart';
import '../../core/engine/rule_engine.dart';
import '../../core/engine/rule_execution_context.dart';

class RuleEngineService {
  static final RuleEngineService _instance = RuleEngineService._();
  factory RuleEngineService() => _instance;
  static RuleEngineService get instance => _instance;
  RuleEngineService._();

  RuleEngine? _engine;
  bool _initialized = false;

  Future<void> initialize(List<CompiledRule> rules) async {
    if (_initialized) return;
    _engine = RuleEngine(rules);
    _initialized = true;
  }

  EvaluationResult evaluate(RuleExecutionContext ctx) {
    final engine = _engine;
    if (!_initialized || engine == null) return EvaluationResult(<Decision>[]);
    return engine.evaluate(ctx);
  }

  bool get isInitialized => _initialized;
}