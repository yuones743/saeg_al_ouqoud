import 'dart:convert';
import 'package:flutter/services.dart';

class ContractTemplate {
  final String id;
  final String version;
  final String name;
  final List<Map<String, dynamic>> sections;

  const ContractTemplate({required this.id, required this.version, required this.name, required this.sections});

  factory ContractTemplate.fromJson(Map<String, dynamic> json) {
    return ContractTemplate(
      id: json['id'] as String,
      version: (json['version'] as String?) ?? '1.0',
      name: json['name'] as String,
      sections: ((json['sections'] as List<dynamic>?) ?? const []).map((s) => (s as Map).cast<String, dynamic>()).toList(),
    );
  }
}

class TemplateRepository {
  static final Map<String, ContractTemplate> _cache = {};

  Future<ContractTemplate> load(String templateId) async {
    final cached = _cache[templateId];
    if (cached != null) return cached;
    final jsonStr = await rootBundle.loadString('assets/templates/$templateId.json');
    final map = (jsonDecode(jsonStr) as Map).cast<String, dynamic>();
    final template = ContractTemplate.fromJson(map);
    _cache[templateId] = template;
    return template;
  }

  List<String> get cachedIds => List.unmodifiable(_cache.keys);
}