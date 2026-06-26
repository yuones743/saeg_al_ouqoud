import 'package:flutter/material.dart';

class AppError {
  final String code;
  final String messageAr;
  final String? details;
  const AppError({required this.code, required this.messageAr, this.details});

  factory AppError.fromException(Object e, [StackTrace? st]) {
    return AppError(
      code: 'E001',
      messageAr: 'حدث خطأ غير متوقع',
      details: e.toString(),
    );
  }

  String toString() => '[$code] $messageAr';
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  const ErrorBoundary({super.key, required this.child, this.fallback});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (fallback != null) return fallback!;
      return Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.all(8),
        child: Text('خطأ: ${details.exception}', style: const TextStyle(fontSize: 12, color: Colors.red)),
      );
    };
    return child;
  }
}