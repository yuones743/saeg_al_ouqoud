import 'package:flutter/foundation.dart';

class PerformanceMetrics {
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> extras;

  PerformanceMetrics({required this.operation, required this.duration, required this.timestamp, this.extras = const {}});

  Map<String, dynamic> toMap() => {
    'operation': operation,
    'duration_ms': duration.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
    'extras': extras,
  };
}

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._();
  factory PerformanceService() => _instance;
  static PerformanceService get instance => _instance;
  PerformanceService._();

  final List<PerformanceMetrics> _metrics = [];

  void record(String operation, Duration duration, {Map<String, dynamic> extras = const {}}) {
    final metric = PerformanceMetrics(operation: operation, duration: duration, timestamp: DateTime.now(), extras: extras);
    _metrics.add(metric);
    if (kDebugMode) {
      debugPrint('Perf: ${operation} took ${duration.inMilliseconds}ms');
    }
  }

  Future<T> measure<T>(String operation, Future<T> Function() action, {Map<String, dynamic> extras = const {}}) async {
    final start = DateTime.now();
    try {
      return await action();
    } finally {
      final duration = DateTime.now().difference(start);
      record(operation, duration, extras: extras);
    }
  }

  List<PerformanceMetrics> get metrics => List.unmodifiable(_metrics);

  void clear() => _metrics.clear();
}