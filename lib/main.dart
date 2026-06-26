import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'application/services/rule_engine_service.dart';
import 'core/engine/rule_loader.dart';
import 'core/engine/compiled_rule.dart';
import 'core/config/system_config.dart';
import 'presentation/state/contract_provider.dart';
import 'application/services/font_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  await SystemConfig.load();
  await FontService.initialize();

  List<CompiledRule> rules = <CompiledRule>[];
  try {
    rules = await RuleLoader.load();
  } catch (_) {
    rules = <CompiledRule>[];
  }
  await RuleEngineService.instance.initialize(rules);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContractProvider()),
      ],
      child: const SaegApp(),
    ),
  );
}