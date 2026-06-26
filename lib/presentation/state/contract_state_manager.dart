import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';

class ContractStateManager {
  Contract _contract;
  ContractStateManager() : _contract = Contract(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    property: const Property(),
    payment: const Payment(),
  );

  Contract get contract => _contract;
  void updateType(ContractType type) => _contract = _contract.copyWith(type: type);
  void updateDate(String date) => _contract = _contract.copyWith(contractDate: date);
  void updateCity(String city) => _contract = _contract.copyWith(city: city);
  void updateGovernorate(String gov) => _contract = _contract.copyWith(governorate: gov);
  void updateSeller(Person seller) => _contract = _contract.copyWith(sellers: [seller]);
  void updateBuyer(Person buyer) => _contract = _contract.copyWith(buyers: [buyer]);

  void addWitness(Person witness) => _contract = _contract.copyWith(witnesses: [..._contract.witnesses, witness]);
  void removeWitness(int index) {
    if (index < 0 || index >= _contract.witnesses.length) return;
    final list = List<Person>.from(_contract.witnesses)..removeAt(index);
    _contract = _contract.copyWith(witnesses: list);
  }
  void clearWitnesses() => _contract = _contract.copyWith(witnesses: const []);
  void updateProperty(Property property) => _contract = _contract.copyWith(property: property);
  void updatePayment(Payment payment) => _contract = _contract.copyWith(payment: payment);

  void setHeirs(List<Heir> heirs) => _contract = _contract.copyWith(heirs: heirs);
  void addHeir(Heir heir) => _contract = _contract.copyWith(heirs: [..._contract.heirs, heir]);
  void removeHeir(int index) {
    if (index < 0 || index >= _contract.heirs.length) return;
    final list = List<Heir>.from(_contract.heirs)..removeAt(index);
    _contract = _contract.copyWith(heirs: list);
  }
  void updateHeir(int index, Heir heir) {
    if (index < 0 || index >= _contract.heirs.length) return;
    final list = List<Heir>.from(_contract.heirs)..[index] = heir;
    _contract = _contract.copyWith(heirs: list);
  }
  void clearHeirs() => _contract = _contract.copyWith(heirs: const []);

  void updateKalala(bool v) => _contract = _contract.copyWith(isKalala: v);
  void updateWillExceedsThird(bool v) => _contract = _contract.copyWith(willExceedsThird: v);
  void updateWillHasHeirConsent(bool v) => _contract = _contract.copyWith(willHasHeirConsent: v);
  void updateJudgmentIsFinal(bool v) => _contract = _contract.copyWith(judgmentIsFinal: v);
  void setJudgment(String number, String date, String court) =>
      _contract = _contract.copyWith(judgmentNumber: number, judgmentDate: date, judgmentCourt: court);
  void setReferenceNumber(String v) => _contract = _contract.copyWith(referenceNumber: v);

  void addClause(ContractClause clause) => _contract = _contract.copyWith(customClauses: [..._contract.customClauses, clause]);
  void removeClause(int index) {
    if (index < 0 || index >= _contract.customClauses.length) return;
    final list = List<ContractClause>.from(_contract.customClauses)..removeAt(index);
    _contract = _contract.copyWith(customClauses: list);
  }
  void updateClause(int index, ContractClause clause) {
    if (index < 0 || index >= _contract.customClauses.length) return;
    final list = List<ContractClause>.from(_contract.customClauses)..[index] = clause;
    _contract = _contract.copyWith(customClauses: list);
  }
  void clearClauses() => _contract = _contract.copyWith(customClauses: const []);

  void addAnnex(ContractAnnex annex) => _contract = _contract.copyWith(annexes: [..._contract.annexes, annex]);
  void removeAnnex(int index) {
    if (index < 0 || index >= _contract.annexes.length) return;
    final list = List<ContractAnnex>.from(_contract.annexes)..removeAt(index);
    _contract = _contract.copyWith(annexes: list);
  }

  void reset() {
    _contract = Contract(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      property: const Property(),
      payment: const Payment(),
    );
  }
}