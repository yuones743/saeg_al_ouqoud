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
      _lastWarning = 'تعذر تحميل الخط ${SystemConfig.contractFontDisplayName}. تم استخدام الخط الافتراضي.';
      debugPrint('FontSafety: $_lastWarning');
    }
    _initialized = true;
  }

  static Future<FontLoader> loadSelectedFont() async {
    // ✅ تم التصحيح: استخدام contractFontDisplayName بدلاً من contractFontName
    final loader = FontLoader(SystemConfig.contractFontDisplayName);
    try {
      loader.addFont(rootBundle.load(SystemConfig.contractFontAssetPath));
      if (SystemConfig.contractFontBoldAssetPath != SystemConfig.contractFontAssetPath) {
        loader.addFont(rootBundle.load(SystemConfig.contractFontBoldAssetPath));
      }
    } catch (_) {}
    await loader.load();
    return loader;
  }
}
