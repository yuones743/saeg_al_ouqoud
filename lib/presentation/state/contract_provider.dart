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

  void updateType(ContractType type) { _manager.updateType(type); notifyListeners(); }
  void updateDate(String date) { _manager.updateDate(date); notifyListeners(); }
  void updateCity(String city) { _manager.updateCity(city); notifyListeners(); }
  void updateGovernorate(String gov) { _manager.updateGovernorate(gov); notifyListeners(); }

  void updateSellers(List<Person> sellers) { _manager.updateSellers(sellers); notifyListeners(); }
  void updateBuyers(List<Person> buyers) { _manager.updateBuyers(buyers); notifyListeners(); }
  void updateSeller(Person seller) { _manager.updateSellers([seller]); notifyListeners(); }
  void updateBuyer(Person buyer) { _manager.updateBuyers([buyer]); notifyListeners(); }

  void updateDeceased(Person deceased) { _manager.updateDeceased(deceased); notifyListeners(); }
  void updateIsInheritance(bool v) { _manager.updateIsInheritance(v); notifyListeners(); }

  void addWitness(Person w) { _manager.addWitness(w); notifyListeners(); }
  void removeWitness(int i) { _manager.removeWitness(i); notifyListeners(); }
  void clearWitnesses() { _manager.clearWitnesses(); notifyListeners(); }

  void updateProperty(Property p) { _manager.updateProperty(p); notifyListeners(); }
  void updatePayment(Payment p) { _manager.updatePayment(p); notifyListeners(); }

  void setHeirs(List<Heir> h) { _manager.setHeirs(h); notifyListeners(); }
  void addHeir(Heir h) { _manager.addHeir(h); notifyListeners(); }
  void removeHeir(int i) { _manager.removeHeir(i); notifyListeners(); }
  void updateHeir(int i, Heir h) { _manager.updateHeir(i, h); notifyListeners(); }
  void clearHeirs() { _manager.clearHeirs(); notifyListeners(); }

  void updateKalala(bool v) { _manager.updateKalala(v); notifyListeners(); }
  void updateWillExceedsThird(bool v) { _manager.updateWillExceedsThird(v); notifyListeners(); }
  void updateWillHasHeirConsent(bool v) { _manager.updateWillHasHeirConsent(v); notifyListeners(); }
  void updateJudgmentIsFinal(bool v) { _manager.updateJudgmentIsFinal(v); notifyListeners(); }
  void setJudgment(String number, String date, String court) { _manager.setJudgment(number, date, court); notifyListeners(); }
  void setReferenceNumber(String v) { _manager.setReferenceNumber(v); notifyListeners(); }

  void addClause(ContractClause c) { _manager.addClause(c); notifyListeners(); }
  void removeClause(int i) { _manager.removeClause(i); notifyListeners(); }
  void updateClause(int i, ContractClause c) { _manager.updateClause(i, c); notifyListeners(); }
  void clearClauses() { _manager.clearClauses(); notifyListeners(); }

  void addAnnex(ContractAnnex a) { _manager.addAnnex(a); notifyListeners(); }
  void removeAnnex(int i) { _manager.removeAnnex(i); notifyListeners(); }

  void setFontScale(double v) { _fontScale = v.clamp(0.7, 1.5); notifyListeners(); }

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

  Future<void> saveContract([Contract? externalContract]) async {
    final contractToSave = externalContract ?? _manager.contract;
    await _repo.save(contractToSave);
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
