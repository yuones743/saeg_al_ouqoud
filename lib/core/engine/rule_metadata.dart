import 'package:flutter/material.dart';

class RuleMetadata {
  static const Map<String, RuleInfo> all = {
    'W001': RuleInfo(id: 'W001', category: 'الأهلية', severity: RuleSeverity.warning, ref: 'قانون حماية القاصرين'),
    'W002': RuleInfo(id: 'W002', category: 'الوكالة', severity: RuleSeverity.warning, ref: 'المادة 837 مدني'),
    'W003': RuleInfo(id: 'W003', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 154 أحوال'),
    'W004': RuleInfo(id: 'W004', category: 'حالة العقار', severity: RuleSeverity.warning, ref: 'قانون التنفيذ'),
    'W005': RuleInfo(id: 'W005', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 28 أحوال'),
    'W006': RuleInfo(id: 'W006', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 29 أحوال'),
    'W007': RuleInfo(id: 'W007', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 182 أحوال'),
    'W008': RuleInfo(id: 'W008', category: 'المشتري', severity: RuleSeverity.warning, ref: 'قانون الاستثمار'),
    'W009': RuleInfo(id: 'W009', category: 'العقار', severity: RuleSeverity.warning, ref: 'قانون التنفيذ'),
    'W010': RuleInfo(id: 'W010', category: 'الوكالة', severity: RuleSeverity.warning, ref: 'المادة 837 مدني'),
    'W011': RuleInfo(id: 'W011', category: 'البائع', severity: RuleSeverity.warning, ref: 'قانون الإرث'),
    'W012': RuleInfo(id: 'W012', category: 'العقار', severity: RuleSeverity.warning, ref: 'قانون حماية القاصرين'),
    'W013': RuleInfo(id: 'W013', category: 'العقار', severity: RuleSeverity.warning, ref: 'المادة 80 أحوال'),
    'W014': RuleInfo(id: 'W014', category: 'العقار', severity: RuleSeverity.warning, ref: 'قانون الأوقاف'),
    'W015': RuleInfo(id: 'W015', category: 'العقار', severity: RuleSeverity.warning, ref: 'قانون البناء'),
    'W016': RuleInfo(id: 'W016', category: 'البيانات', severity: RuleSeverity.info, ref: 'توصية'),
    'W017': RuleInfo(id: 'W017', category: 'البيانات', severity: RuleSeverity.warning, ref: 'توصية'),
    'W018': RuleInfo(id: 'W018', category: 'العقار', severity: RuleSeverity.warning, ref: 'تعميم 2026'),
    'W019': RuleInfo(id: 'W019', category: 'العقار', severity: RuleSeverity.warning, ref: 'قانون الاستثمار'),
    'W020': RuleInfo(id: 'W020', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 306 مدني'),
    'W021': RuleInfo(id: 'W021', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 154 أحوال'),
    'W022': RuleInfo(id: 'W022', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 132 أحوال'),
    'W023': RuleInfo(id: 'W023', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 50 أحوال'),
    'W024': RuleInfo(id: 'W024', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 86 أحوال'),
    'W025': RuleInfo(id: 'W025', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 23 أحوال'),
    'W026': RuleInfo(id: 'W026', category: 'الإرث', severity: RuleSeverity.warning, ref: 'المادة 107 أحوال'),
  };

  static RuleInfo? get(String id) => all[id];
}

enum RuleSeverity { warning, info, blocking }

class RuleInfo {
  final String id;
  final String category;
  final RuleSeverity severity;
  final String ref;
  const RuleInfo({required this.id, required this.category, required this.severity, required this.ref});

  Color get color {
    switch (severity) {
      case RuleSeverity.warning: return Colors.orange;
      case RuleSeverity.info: return Colors.blue;
      case RuleSeverity.blocking: return Colors.red;
    }
  }
}