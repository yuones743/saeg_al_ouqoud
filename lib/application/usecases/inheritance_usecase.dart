import '../../core/inheritance/inheritance_calculator.dart';
import '../../domain/models/contract.dart';

class InheritanceUseCase {
  final InheritanceCalculator _calculator = InheritanceCalculator();

  InheritanceResult execute({
    required List<Heir> heirs,
    required bool isKalala,
    required bool isAmiriaLand,
    required bool willExceedsThird,
    required bool willHasHeirConsent,
  }) {
    return _calculator.calculate(
      heirs: heirs,
      isKalala: isKalala,
      isAmiriaLand: isAmiriaLand,
      willExceedsThird: willExceedsThird,
      willHasHeirConsent: willHasHeirConsent,
    );
  }
}