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
        border switch (_contractFont) {
      case ContractFontFamily.traditionalArabic: return 'Traditional Arabic';
      case ContractFontFamily.amiri: return 'Amiri';
      case ContractFontFamily.cairo: return 'Cairo';
      case ContractFontFamily.notoNaskh: return 'Noto Naskh Arabic';
      case ContractFontFamily.lateef: return 'Lateef';
    }
  }

  static String get contractFontAssetPath {
    switch (_contractFont) {
      case ContractFontFamily.traditionalArabic: return 'assets/fonts/TraditionalArabic.ttf';
      case ContractFontFamily.amiri: return 'assets/fonts/Amiri-Regular.ttf';
      case ContractFontFamily.cairo: return 'assets/fonts/Cairo-Regular.ttf';
      case ContractFontFamily.notoNaskh: return 'assets/fonts/NotoNaskhArabic-Regular.ttf';
      case ContractFontFamily.lateef: return 'assets/fonts/Lateef-Regular.ttf';
    }
  }

  static String get contractFontBoldAssetPath {
    switch (_contractFont) {
      case ContractFontFamily.traditionalArabic: return 'assets/fonts/TraditionalArabic.ttf';
      case ContractFontFamily.amiri: return 'assets/fonts/Amiri-Bold.ttf';
      case ContractFontFamily.cairo: return 'assets/fonts/Cairo-Bold.ttf';
      case ContractFontFamily.notoNaskh: return 'assets/fonts/NotoNaskhArabic-Bold.ttf';
      case ContractFontFamily.lateef: return 'assets/fonts/Lateef-Regular.ttf';
    }
  }

  static void setContractFont(ContractFontFamily font) {
    _contractFont = font;
    _savePrefs();
  }

  static void setPageFormat(ContractPageFormat fmt) {
    _pageFormat = fmt;
    _savePrefs();
  }

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontIdx = prefs.getInt('contract_font') ?? 0;
      final fmtIdx = prefs.getInt('page_format') ?? 0;
      _contractFont = ContractFontFamily.values[fontIdx.clamp(0, ContractFontFamily.values.length - 1)];
      _pageFormat = ContractPageFormat.values[fmtIdx.clamp(0, ContractPageFormat.values.length - 1)];
    } catch (_) {}
  }

  static Future<void> _savePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('contract_font', _contractFont.index);
      await prefs.setInt('page_format', _pageFormat.index);
    } catch (_) {}
  }
}