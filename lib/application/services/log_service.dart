import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class LogService {
  static final LogService _instance = LogService._();
  factory LogService() => _instance;
  static LogService get instance => _instance;
  LogService._();

  final List<String> _logs = [];
  static const int _maxLogs = 500;

  void log(String message, {LogLevel level = LogLevel.info, String? tag}) {
    final entry = '[${DateTime.now().toIso8601String()}] [${level.name}] ${tag ?? 'app'}: $message';
    _logs.add(entry);
    if (_logs.length > _maxLogs) _logs.removeAt(0);
    if (kDebugMode) debugPrint(entry);
  }

  void info(String message, {String? tag}) => log(message, level: LogLevel.info, tag: tag);
  void warn(String message, {String? tag}) => log(message, level: LogLevel.warning, tag: tag);
  void error(String message, {String? tag}) => log(message, level: LogLevel.error, tag: tag);

  List<String> get logs => List.unmodifiable(_logs);
  void clear() => _logs.clear();
}