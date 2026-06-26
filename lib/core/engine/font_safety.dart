import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FontSafety {
  static final Map<String, bool> _checkedFonts = {};

  static Future<bool> isFontAvailable(String assetPath) async {
    if (_checkedFonts.containsKey(assetPath)) return _checkedFonts[assetPath]!;
    try {
      await rootBundle.load(assetPath);
      _checkedFonts[assetPath] = true;
      return true;
    } catch (_) {
      _checkedFonts[assetPath] = false;
      return false;
    }
  }

  static Future<String> safeFontMessage(String fontName) async {
    final available = await isFontAvailable('assets/fonts/$fontName.ttf');
    if (!available) return 'تنبيه: لم يتم العثور على الخط $fontName، تم استخدام الخط الافتراضي';
    return '';
  }
}