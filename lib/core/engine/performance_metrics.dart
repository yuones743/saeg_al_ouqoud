class EngineMetrics {
  final int rulesEvaluated;
  final int decisionsMatched;
  final Duration totalDuration;
  final DateTime timestamp;

  EngineMetrics({
    required this.rulesEvaluated,
    required this.decisionsMatched,
    required this.totalDuration,
    required this.timestamp,
  });

  @override
  String toString() => 'EngineMetrics(rules=$rulesEvaluated, decisions=$decisionsMatched, duration=${totalDuration.inMilliseconds}ms)';
}