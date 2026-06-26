import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';

class ContractRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<void> save(Contract contract) async {
    final db = await _db.database;
    await db.insert(
      'contracts',
      {
        'id': contract.id, 'tenant_id': 'default',
        'contract_type': contract.type.name, 'status': contract.status,
        'data_json': jsonEncode(contract.toMap()),
        'created_at': contract.createdAt.millisecondsSinceEpoch,
        'updated_at': contract.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contract>> loadAll() async {
    final db = await _db.database;
    final rows = await db.query('contracts', orderBy: 'updated_at DESC');
    return rows.map((row) => _fromRow(row)).whereType<Contract>().toList();
  }

  Future<Contract?> loadById(String id) async {
    final db = await _db.database;
    final rows = await db.query('contracts', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.delete('contracts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countAll() async {
    final db = await _db.database;
    final r = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM contracts'));
    return r ?? 0;
  }

  Contract? _fromRow(Map<String, Object?> row) {
    try {
      final raw = row['data_json'] as String?;
      if (raw == null) return null;
      return _contractFromMap((jsonDecode(raw) as Map).cast<String, dynamic>());
    } catch (_) { return null; }
  }

  Contract _contractFromMap(Map<String, dynamic> m) {
    return Contract(
      id: m['id'] as String,
      type: ContractType.values[(m['type'] as int).clamp(0, ContractType.values.length - 1)],
      contractDate: (m['contract_date'] as String?) ?? '',
      city: (m['city'] as String?) ?? '',
      governorate: (m['governorate'] as String?) ?? '',
      sellers: _personsFromList(m['sellers']),
      buyers: _personsFromList(m['buyers']),
      witnesses: _personsFromList(m['witnesses']),
      property: _propertyFromMap((m['property'] as Map<String, dynamic>?) ?? const {}),
      payment: _paymentFromMap((m['payment'] as Map<String, dynamic>?) ?? const {}),
      heirs: _heirsFromList(m['heirs']),
      isKalala: ((m['is_kalala'] as int?) ?? 0) == 1,
      willExceedsThird: ((m['will_exceeds_third'] as int?) ?? 0) == 1,
      willHasHeirConsent: ((m['will_has_heir_consent'] as int?) ?? 0) == 1,
      judgmentIsFinal: ((m['judgment_is_final'] as int?) ?? 0) == 1,
      judgmentNumber: (m['judgment_number'] as String?) ?? '',
      judgmentDate: (m['judgment_date'] as String?) ?? '',
      judgmentCourt: (m['judgment_court'] as String?) ?? '',
      customClauses: _clausesFromList(m['custom_clauses']),
      annexes: _annexesFromList(m['annexes']),
      status: (m['status'] as String?) ?? 'draft',
      referenceNumber: (m['reference_number'] as String?) ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch((m['created_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch((m['updated_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  List<Person> _personsFromList(Object? list) {
    if (list is! List) return <Person>[];
    return list.map((p) {
      final pm = (p as Map).cast<String, dynamic>();
      return Person(
        id: (pm['id'] as String?) ?? '',
        fullName: (pm['full_name'] as String?) ?? '',
        fatherName: (pm['father_name'] as String?) ?? '',
        motherName: (pm['mother_name'] as String?) ?? '',
        birthYear: (pm['birth_year'] as String?) ?? '',
        residency: (pm['residency'] as String?) ?? '',
        familyId: (pm['family_id'] as String?) ?? '',
        nationalId: (pm['national_id'] as String?) ?? '',
        nationality: _safeEnum(NationalityType.values, (pm['nationality'] as int?) ?? 0, NationalityType.syrian),
        idNumber: (pm['id_number'] as String?) ?? '',
        idIssuedBy: (pm['id_issued_by'] as String?) ?? '',
        idIssuedDate: (pm['id_issued_date'] as String?) ?? '',
        maritalStatus: _safeEnum(MaritalStatus.values, (pm['marital_status'] as int?) ?? 0, MaritalStatus.single),
        profession: (pm['profession'] as String?) ?? '',
        address: (pm['address'] as String?) ?? '',
        phone: (pm['phone'] as String?) ?? '',
        role: _safeEnum(PersonRole.values, (pm['role'] as int?) ?? 0, PersonRole.seller),
        isMinor: ((pm['is_minor'] as int?) ?? 0) == 1,
        isExpatriate: ((pm['is_expatriate'] as int?) ?? 0) == 1,
        isMissing: ((pm['is_missing'] as int?) ?? 0) == 1,
        isDeceased: ((pm['is_deceased'] as int?) ?? 0) == 1,
        hasPowerOfAttorney: ((pm['has_poa'] as int?) ?? 0) == 1,
        poaNumber: (pm['poa_number'] as String?) ?? '',
        poaDate: (pm['poa_date'] as String?) ?? '',
        hasGuardianPermission: ((pm['has_guardian_permission'] as int?) ?? 0) == 1,
        hasJudicialRepresentative: ((pm['has_judicial_representative'] as int?) ?? 0) == 1,
        agentBuysForSelf: ((pm['agent_buys_for_self'] as int?) ?? 0) == 1,
        agentHasSelfBuyPermission: ((pm['agent_has_self_buy_permission'] as int?) ?? 0) == 1,
        marriageCount: (pm['marriage_count'] as int?) ?? 1,
        divorceType: _safeEnum(DivorceType.values, (pm['divorce_type'] as int?) ?? 0, DivorceType.none),
        divorceDuringIllness: ((pm['divorce_during_illness'] as int?) ?? 0) == 1,
      );
    }).toList();
  }

  Property _propertyFromMap(Map<String, dynamic> pm) {
    return Property(
      registryNumber: (pm['registry_number'] as String?) ?? '',
      zone: (pm['zone'] as String?) ?? '',
      planNumber: (pm['plan_number'] as String?) ?? '',
      plotNumber: (pm['plot_number'] as String?) ?? '',
      ownershipDocNumber: (pm['ownership_doc_number'] as String?) ?? '',
      ownershipDocDate: (pm['ownership_doc_date'] as String?) ?? '',
      ownershipDocSource: (pm['ownership_doc_source'] as String?) ?? '',
      address: (pm['address'] as String?) ?? '',
      area: ((pm['area'] as num?) ?? 0).toDouble(),
      type: _safeEnum(PropertyType.values, (pm['type'] as int?) ?? 0, PropertyType.apartment),
      hasSeizure: ((pm['has_seizure'] as int?) ?? 0) == 1,
      hasMortgage: ((pm['has_mortgage'] as int?) ?? 0) == 1,
      hasReleaseLetter: ((pm['has_release_letter'] as int?) ?? 0) == 1,
      isEndowment: ((pm['is_endowment'] as int?) ?? 0) == 1,
      isViolation: ((pm['is_violation'] as int?) ?? 0) == 1,
      isCommonShare: ((pm['is_common_share'] as int?) ?? 0) == 1,
      commonShareNumerator: ((pm['common_share_numerator'] as num?) ?? 1).toDouble(),
      commonShareDenominator: ((pm['common_share_denominator'] as num?) ?? 1).toDouble(),
      underExpropriation: ((pm['under_expropriation'] as int?) ?? 0) == 1,
      hasActiveLawsuit: ((pm['has_active_lawsuit'] as int?) ?? 0) == 1,
      isAmiriaLand: ((pm['is_amiria_land'] as int?) ?? 0) == 1,
      isMinorsDowry: ((pm['is_minors_dowry'] as int?) ?? 0) == 1,
      subjectToInvestmentLaw: ((pm['subject_to_investment_law'] as int?) ?? 0) == 1,
      hasShamIndicators: ((pm['has_sham_indicators'] as int?) ?? 0) == 1,
      description: (pm['description'] as String?) ?? '',
      boundaries: (pm['boundaries'] as String?) ?? '',
      northBoundary: (pm['north_boundary'] as String?) ?? '',
      southBoundary: (pm['south_boundary'] as String?) ?? '',
      eastBoundary: (pm['east_boundary'] as String?) ?? '',
      westBoundary: (pm['west_boundary'] as String?) ?? '',
    );
  }

  Payment _paymentFromMap(Map<String, dynamic> pm) {
    return Payment(
      totalPrice: ((pm['total_price'] as num?) ?? 0).toDouble(),
      paidAmount: ((pm['paid_amount'] as num?) ?? 0).toDouble(),
      balance: ((pm['balance'] as num?) ?? 0).toDouble(),
      balanceDueDate: (pm['balance_due_date'] as String?) ?? '',
      currency: _safeEnum(Currency.values, (pm['currency'] as int?) ?? 0, Currency.syp),
      method: _safeEnum(PaymentMethod.values, (pm['method'] as int?) ?? 0, PaymentMethod.cash),
      expenseAllocation: _safeEnum(ExpenseAllocation.values, (pm['expense_allocation'] as int?) ?? 0, ExpenseAllocation.buyer),
      penaltyAmount: ((pm['penalty_amount'] as num?) ?? 0).toDouble(),
      taxRate: ((pm['tax_rate'] as num?) ?? 0.03).toDouble(),
      taxExemptOnNkoul: ((pm['tax_exempt_on_nkoul'] as int?) ?? 1) == 1,
      customExpenseNote: (pm['custom_expense_note'] as String?) ?? '',
    );
  }

  List<Heir> _heirsFromList(Object? list) {
    if (list is! List) return <Heir>[];
    return list.map((h) {
      final hm = (h as Map).cast<String, dynamic>();
      final personMap = ((hm['person'] as Map?) ?? const {}).cast<String, dynamic>();
      final persons = _personsFromList([personMap]);
      return Heir(
        person: persons.isNotEmpty ? persons.first : const Person(id: ''),
        shares: (hm['shares'] as int?) ?? 0,
        isKiller: ((hm['is_killer'] as int?) ?? 0) == 1,
        isApostate: ((hm['is_apostate'] as int?) ?? 0) == 1,
        isPrisoner: ((hm['is_prisoner'] as int?) ?? 0) == 1,
        isIntersex: ((hm['is_intersex'] as int?) ?? 0) == 1,
        isPregnant: ((hm['is_pregnant'] as int?) ?? 0) == 1,
        relation: (hm['relation'] as String?) ?? '',
      );
    }).toList();
  }

  List<ContractClause> _clausesFromList(Object? list) {
    if (list is! List) return <ContractClause>[];
    return list.map((c) {
      final cm = (c as Map).cast<String, dynamic>();
      return ContractClause(
        id: (cm['id'] as String?) ?? '',
        titleAr: (cm['title_ar'] as String?) ?? '',
        bodyAr: (cm['body_ar'] as String?) ?? '',
        isVisible: ((cm['is_visible'] as int?) ?? 1) == 1,
        isEditable: ((cm['is_editable'] as int?) ?? 1) == 1,
      );
    }).toList();
  }

  List<ContractAnnex> _annexesFromList(Object? list) {
    if (list is! List) return <ContractAnnex>[];
    return list.map((a) {
      final am = (a as Map).cast<String, dynamic>();
      return ContractAnnex(
        number: (am['number'] as int?) ?? 1,
        titleAr: (am['title_ar'] as String?) ?? '',
        bodyAr: (am['body_ar'] as String?) ?? '',
      );
    }).toList();
  }

  T _safeEnum<T extends Enum>(List<T> values, int index, T fallback) {
    if (index < 0 || index >= values.length) return fallback;
    return values[index];
  }
}