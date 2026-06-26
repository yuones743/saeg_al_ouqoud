import '../../domain/models/contract.dart';
import '../../domain/snapshot/contract_snapshot.dart';
import '../../domain/validation/contract_validator.dart';
import '../../core/engine/rule_execution_context.dart';
import '../../core/engine/rule_engine.dart';
import '../../core/audit/audit_service.dart';
import '../services/rule_engine_service.dart';

class AnalyzeContractResult {
  final bool validationPassed;
  final List<ValidationFailure> validationFailures;
  final EvaluationResult? engineResult;
  const AnalyzeContractResult({required this.validationPassed, required this.validationFailures, this.engineResult});
  bool get hasBlocking => validationFailures.any((f) => f.severity == 'blocking');
  bool get canGenerate => true;
}

class AnalyzeContractUseCase {
  final ContractValidator _validator = ContractValidator();
  final AuditService _audit = AuditService();

  Future<AnalyzeContractResult> execute(Contract contract) async {
    final validationResult = _validator.validate(contract);
    final snapshot = ContractSnapshot.fromContract(contract);
    final ctx = RuleExecutionContext.fromSnapshot(snapshot);
    final engineResult = RuleEngineService.instance.evaluate(ctx);
    await _audit.record(contract.id, engineResult);
    return AnalyzeContractResult(
      validationPassed: validationResult.isValid,
      validationFailures: validationResult.failures,
      engineResult: engineResult,
    );
  }
}