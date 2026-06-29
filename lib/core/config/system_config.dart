import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/contract.dart';

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

  static double _margin = 1.5;
  static double _headerFontSize = 16;
  static double _taxRate = 0.03;

  // ✅ استخدام النوع الصحيح: ContractType من contract.dart
  static final Map<ContractType, List<Map<String, String>>> _lawsByType = {
    ContractType.directSale: [
      {'title': 'قانون الاستثمار', 'number': '18/2021', 'clause': 'يخضع هذا العقد لأحكام قانون الاستثمار رقم 18 لعام 2021.'},
      {'title': 'قانون حماية المستهلك', 'number': '14/2015', 'clause': 'يخضع هذا العقد لأحكام قانون حماية المستهلك رقم 14 لعام 2015.'},
    ],
    ContractType.settlement: [
      {'title': 'قانون الوساطة', 'number': '15/2010', 'clause': 'يخضع هذا العقد لأحكام قانون الوساطة رقم 15 لعام 2010.'},
    ],
    ContractType.partition: [
      {'title': 'قانون القسمة', 'number': '1010 مدني', 'clause': 'تخضع القسمة لأحكام المادة 1010 من القانون المدني السوري.'},
    ],
    ContractType.inheritanceAgreement: [
      {'title': 'الوصية الواجبة', 'number': '182 أحوال', 'clause': 'الوصية الواجبة لأولاد الابن المتوفى وفق المادة 182 من قانون الأحوال الشخصية.'},
    ],
    // ✅ لا تستخدم ContractType.rent لأنه غير موجود في هذا النوع
  };

  static ContractFontFamily get contractFont => _contractFont;
  static ContractPageFormat get pageFormat => _pageFormat;
  static double get margin => _margin;
  static double get headerFontSize => _headerFontSize;
  static double get taxRate => _taxRate;

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

  static void setMargin(double value) {
    _margin = value.clamp(0.7, 2.5);
    _savePrefs();
  }

  static void setHeaderFontSize(double value) {
    _headerFontSize = value.clamp(12.0, 22.0);
    _savePrefs();
  }

  static void setTaxRate(double value) {
    _taxRate = value.clamp(0.0, 0.10);
    _savePrefs();
  }

  // ─── دوال إدارة القوانين ──────────────────────────────────────────────────

  static List<Map<String, String>> getLawsForType(ContractType type) {
    return _lawsByType[type] ?? [];
  }

  static void addLawForType(ContractType type, String title, String number, String clause) {
    if (!_lawsByType.containsKey(type)) {
      _lawsByType[type] = [];
    }
    _lawsByType[type]!.add({
      'title': title,
      'number': number,
      'clause': clause,
    });
    _savePrefs();
  }

  static void removeLawForType(ContractType type, int index) {
    final laws = _lawsByType[type];
    if (laws != null && index >= 0 && index < laws.length) {
      laws.removeAt(index);
      _savePrefs();
    }
  }

  static void updateLawForType(ContractType type, int index, String title, String number, String clause) {
    final laws = _lawsByType[type];
    if (laws != null && index >= 0 && index < laws.length) {
      laws[index] = {
        'title': title,
        'number': number,
        'clause': clause,
      };
      _savePrefs();
    }
  }

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontIdx = prefs.getInt('contract_font') ?? 0;
      final fmtIdx = prefs.getInt('page_format') ?? 0;
      _contractFont = ContractFontFamily.values[fontIdx.clamp(0, ContractFontFamily.values.length - 1)];
      _pageFormat = ContractPageFormat.values[fmtIdx.clamp(0, ContractPageFormat.values.length - 1)];
      _margin = prefs.getDouble('margin') ?? 1.5;
      _headerFontSize = prefs.getDouble('header_font_size') ?? 16;
      _taxRate = prefs.getDouble('tax_rate') ?? 0.03;

      final lawsJson = prefs.getStringList('laws_by_type');
      if (lawsJson != null && lawsJson.isNotEmpty) {
        _lawsByType.clear();
        for (final entry in lawsJson) {
          final parts = entry.split('|||');
          if (parts.length >= 4) {
            final type = ContractType.values[int.tryParse(parts[0]) ?? 0];
            final title = parts[1];
            final number = parts[2];
            final clause = parts[3];
            if (!_lawsByType.containsKey(type)) {
              _lawsByType[type] = [];
            }
            _lawsByType[type]!.add({
              'title': title,
              'number': number,
              'clause': clause,
            });
          }
        }
      }
    } catch (_) {}
  }

  static Future<void> _savePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('contract_font', _contractFont.index);
      await prefs.setInt('page_format', _pageFormat.index);
      await prefs.setDouble('margin', _margin);
      await prefs.setDouble('header_font_size', _headerFontSize);
      await prefs.setDouble('tax_rate', _taxRate);

      final lawsJson = <String>[];
      for (final entry in _lawsByType.entries) {
        for (final law in entry.value) {
          lawsJson.add('${entry.key.index}|||${law['title']}|||${law['number']}|||${law['clause']}');
        }
      }
      await prefs.setStringList('laws_by_type', lawsJson);
    } catch (_) {}
  }
}
