import 'dart:convert';
import 'package:flutter/services.dart';
import 'rule_compiler.dart';
import 'compiled_rule.dart';

class RuleLoader {
  static Future<List<CompiledRule>> load() async {
    final String jsonStr = await rootBundle.loadString('assets/rules/rules.json');
    final List<dynamic> rawList = jsonDecode(jsonStr) as List<dynamic>;
    if (rawList.isEmpty) return <CompiledRule>[];
    final compiler = RuleSetCompiler();
    return compiler.compileAll(rawList.map((e) => (e as Map).cast<String, dynamic>()).toList());
  }
}