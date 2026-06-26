import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ContractFontFamily {
  traditionalArabic,
  amiri,
  cairo,
  notoNaskh,
  lateef,
}

enum ContractPageFormat {
  a4,
  a5,
  letter,
}

class SystemConfig {
  static const String appVersion = '1.0.0';
  static const String appName = 'صائغ العقود السوري';
  static const String publisher = 'مكتب المحاماة';
  static const String appFontFamily = 'TraditionalArabic';

  static ContractFontFamily _contractFont = ContractFontFamily.traditionalArabic;
  static ContractPageFormat _pageFormat = ContractPageFormat.a4;

  static ContractFontFamily get contractFont => _contractFont;
  static ContractPageFormat get pageFormat => _pageFormat;

  static String get contractFontDisplayName {
    switch (_contractFont) {
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
