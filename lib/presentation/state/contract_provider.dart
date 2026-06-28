import 'package:flutter/foundation.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../../application/usecases/analyze_contract_usecase.dart';
import '../../data/repositories/contract_repository.dart';
import 'contract_state_manager.dart';

enum ContractProviderStatus { idle, analyzing, done, error }

class ContractProvider extends ChangeNotifier {
  final ContractStateManager _manager = ContractStateManager();
  final AnalyzeContractUseCase _useCase = AnalyzeContractUseCase();
  final ContractRepository _repo = ContractRepository();

  ContractProviderStatus _status = ContractProviderStatus.idle;
  AnalyzeContractResult? _lastResult;
  String? _error;
  List<Contract> _savedContracts = [];
  double _fontScale = 1.0;

  ContractProviderStatus get status => _status;
  AnalyzeContractResult? get lastResult => _lastResult;
  String? get error => _error;
  Contract get contract => _manager.contract;
  List<Contract> get savedContracts => List.unmodifiable(_savedContracts);
  double get fontScale => _fontScale;

  // دوال إدارة العقد الأساسية
  void updateType(ContractType type) { _manager.updateType(type); notifyListeners(); }
  void updateDate(String date) { _manager.updateDate(date); notifyListeners(); }
  void updateCity(String city) { _manager.updateCity(city); notifyListeners(); }
  void updateGovernorate(String gov) { _manager.updateGovernorate(gov); notifyListeners(); }
  void updateSeller(Person seller) { _manager.updateSeller(seller); notifyListeners(); }
  void updateBuyer(Person buyer) { _manager.updateBuyer(buyer); notifyListeners(); }

  // ✅ دوال الإرث الجديدة
  void updateDeceased(Person deceased) { _manager.updateDeceased(deceased); notifyListeners(); }
  void updateIsInheritance(bool isInheritance) { _manager.updateIsInheritance(isInheritance); notifyListeners(); }

  void addWitness(Person witness) { _manager.addWitness(witness); notifyListeners(); }
  void removeWitness(int index) { _manager.removeWitness(index); notifyListeners(); }
  void clearWitnesses() { _manager.clearWitnesses(); notifyListeners(); }
  void updateProperty(Property property) { _manager.updateProperty(property); notifyListeners(); }
  void updatePayment(Payment payment) { _manager.updatePayment(payment); notifyListeners(); }

  void setHeirs(List<Heir> heirs) { _manager.setHeirs(heirs); notifyListeners(); }
  void addHeir(Heir heir) { _manager.addHeir(heir); notifyListeners(); }
  void removeHeir(int index) { _manager.removeHeir(index); notifyListeners(); }
  void updateHeir(int index, Heir heir) { _manager.updateHeir(index, heir); notifyListeners(); }
  void clearHeirs() { _manager.clearHeirs(); notifyListeners(); }

  void updateKalala(bool v) { _manager.updateKalala(v); notifyListeners(); }
  void updateWillExceedsThird(bool v) { _manager.updateWillExceedsThird(v); notifyListeners(); }
  void updateWillHasHeirConsent(bool v) { _manager.updateWillHasHeirConsent(v); notifyListeners(); }
  void updateJudgmentIsFinal(bool v) { _manager.updateJudgmentIsFinal(v); notifyListeners(); }
  void setJudgment(String number, String date, String court) {
    _manager.setJudgment(number, date, court);
    notifyListeners();
  }
  void setReferenceNumber(String v) { _manager.setReferenceNumber(v); notifyListeners(); }

  void addClause(ContractClause clause) { _manager.addClause(clause); notifyListeners(); }
  void removeClause(int index) { _manager.removeClause(index); notifyListeners(); }
  void updateClause(int index, ContractClause clause) { _manager.updateClause(index, clause); notifyListeners(); }
  void clearClauses() { _manager.clearClauses(); notifyListeners(); }

  void addAnnex(ContractAnnex annex) { _manager.addAnnex(annex); notifyListeners(); }
  void removeAnnex(int index) { _manager.removeAnnex(index); notifyListeners(); }

  void setFontScale(double v) {
    _fontScale = v.clamp(0.7, 1.5);
    notifyListeners();
  }

  Future<void> analyze() async {
    _status = ContractProviderStatus.analyzing;
    _error = null;
    notifyListeners();
    try {
      _lastResult = await _useCase.execute(_manager.contract);
      _status = ContractProviderStatus.done;
    } catch (e) {
      _error = e.toString();
      _status = ContractProviderStatus.error;
    }
    notifyListeners();
  }

  Future<void> saveContract() async {
    await _repo.save(_manager.contract);
    await loadContracts();
  }

  Future<void> loadContracts() async {
    _savedContracts = await _repo.loadAll();
    notifyListeners();
  }

  Future<void> deleteContract(String id) async {
    await _repo.delete(id);
    await loadContracts();
  }

  void reset() {
    _manager.reset();
    _lastResult = null;
    _status = ContractProviderStatus.idle;
    _error = null;
    _fontScale = 1.0;
    notifyListeners();
  }
}
