import 'package:flutter/material.dart';
import 'core/config/system_config.dart';
import 'presentation/screens/home_screen.dart';

class SaegApp extends StatelessWidget {
  const SaegApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صائغ العقود السوري',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1B4F72),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: SystemConfig.appFontFamily,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: SystemConfig.appFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: SystemConfig.appFontFamily),
        bodyMedium: TextStyle(fontFamily: SystemConfig.appFontFamily),
        titleLarge: TextStyle(fontFamily: SystemConfig.appFontFamily),
        titleMedium: TextStyle(fontFamily: SystemConfig.appFontFamily),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
