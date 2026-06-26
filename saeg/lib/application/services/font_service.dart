import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/config/system_config.dart';
import '../../core/engine/font_safety.dart';

class FontService {
  static bool _initialized = false;
  static String? _lastWarning;

  static String? get lastWarning => _lastWarning;

  static Future<void> initialize() async {
    if (_initialized) return;
    final asset = SystemConfig.contractFontAssetPath;
    final available = await FontSafety.isFontAvailable(asset);
    if (!available) {
      _lastWarning =
          'تعذر تحميل الخط ${SystemConfig.contractFontDisplayName}. تم استخدام الخط الافتراضي.';
      debugPrint('FontService: $_lastWarning');
    } else {
      _lastWarning = null;
    }
    _initialized = true;
  }

  static void reset() {
    _initialized = false;
    _lastWarning = null;
  }

  static Future<FontLoader> loadSelectedFont() async {
    final loader = FontLoader(SystemConfig.contractFontName);
    try {
      loader.addFont(rootBundle.load(SystemConfig.contractFontAssetPath));
      final boldPath = SystemConfig.contractFontBoldAssetPath;
      if (boldPath != SystemConfig.contractFontAssetPath) {
        loader.addFont(rootBundle.load(boldPath));
      }
    } catch (_) {}
    await loader.load();
    return loader;
  }
}
