import 'package:flutter/services.dart';

class FontSafety {
  static final Map<String, bool> _checkedFonts = {};

  static Future<bool> isFontAvailable(String assetPath) async {
    if (_checkedFonts.containsKey(assetPath)) {
      return _checkedFonts[assetPath]!;
    }
    try {
      await rootBundle.load(assetPath);
      _checkedFonts[assetPath] = true;
      return true;
    } catch (_) {
      _checkedFonts[assetPath] = false;
      return false;
    }
  }

  static void clearCache() {
    _checkedFonts.clear();
  }
}
