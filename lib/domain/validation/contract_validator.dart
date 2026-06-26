import '../models/contract.dart';

class ValidationFailure {
  final String field;
  final String messageAr;
  final String severity;
  const ValidationFailure({required this.field, required this.messageAr, this.severity = 'info'});
}

class ValidationResult {
  final List<ValidationFailure> failures;
  const ValidationResult(this.failures);
  bool get isValid => failures.isEmpty;
  List<ValidationFailure> get warnings => failures.where((f) => f.severity == 'warning').toList();
}

class ContractValidator {
  ValidationResult validate(Contract contract) {
    final failures = <ValidationFailure>[];
    if (contract.contractDate.trim().isEmpty) failures.add(const ValidationFailure(field: 'contract_date', messageAr: 'تاريخ العقد مطلوب', severity: 'warning'));
    if (contract.city.trim().isEmpty) failures.add(const ValidationFailure(field: 'city', messageAr: 'مدينة العقد مطلوبة', severity: 'warning'));
    if (contract.sellers.isEmpty) failures.add(const ValidationFailure(field: 'sellers', messageAr: 'يجب إدخال بيانات البائع', severity: 'warning'));
    final isInh = contract.type == ContractType.inheritanceAgreement || contract.type == ContractType.judicialInheritance;
    if (contract.buyers.isEmpty && !isInh) failures.add(const ValidationFailure(field: 'buyers', messageAr: 'يجب إدخال بيانات المشتري', severity: 'warning'));
    if (contract.sellers.any((s) => s.fullName.trim().isEmpty)) failures.add(const ValidationFailure(field: 'seller_name', messageAr: 'اسم البائع مطلوب', severity: 'warning'));
    if (!isInh && contract.buyers.any((b) => b.fullName.trim().isEmpty)) failures.add(const ValidationFailure(field: 'buyer_name', messageAr: 'اسم المشتري مطلوب', severity: 'warning'));
    if (contract.property.registryNumber.trim().isEmpty && contract.type != ContractType.settlement) {
      failures.add(const ValidationFailure(field: 'registry_number', messageAr: 'رقم السجل العقاري مطلوب', severity: 'warning'));
    }
    final isMoney = contract.type != ContractType.settlement && contract.type != ContractType.inheritanceAgreement &&
        contract.type != ContractType.judicialInheritance && contract.type != ContractType.partition &&
        contract.type != ContractType.judicialPartition && contract.type != ContractType.judicialExit;
    if (isMoney && contract.payment.totalPrice <= 0) failures.add(const ValidationFailure(field: 'total_price', messageAr: 'الثمن الإجمالي يجب أن يكون أكبر من صفر', severity: 'warning'));
    return ValidationResult(failures);
  }
}