import 'person.dart';
import 'property.dart';
import 'payment.dart';

enum ContractType {
  directSale, usufructSale, commonShareSale, inheritanceAgreement,
  partition, settlement, promise, judicialSale, judicialInheritance,
  judicialPartition, judicialExit, complexProperty,
}

class Heir {
  final Person person;
  final int shares;
  final bool isKiller;
  final bool isApostate;
  final bool isPrisoner;
  final bool isIntersex;
  final bool isPregnant;
  final String relation;

  const Heir({
    required this.person,
    required this.shares,
    this.isKiller = false,
    this.isApostate = false,
    this.isPrisoner = false,
    this.isIntersex = false,
    this.isPregnant = false,
    this.relation = '',
  });

  Map<String, dynamic> toMap() => {
    'person': person.toMap(),
    'shares': shares,
    'is_killer': isKiller ? 1 : 0,
    'is_apostate': isApostate ? 1 : 0,
    'is_prisoner': isPrisoner ? 1 : 0,
    'is_intersex': isIntersex ? 1 : 0,
    'is_pregnant': isPregnant ? 1 : 0,
    'relation': relation,
  };
}

class ContractClause {
  final String id;
  final String titleAr;
  final String bodyAr;
  final bool isVisible;
  final bool isEditable;

  const ContractClause({
    required this.id,
    required this.titleAr,
    required this.bodyAr,
    this.isVisible = true,
    this.isEditable = true,
  });

  ContractClause copyWith({String? titleAr, String? bodyAr, bool? isVisible, bool? isEditable}) {
    return ContractClause(
      id: id,
      titleAr: titleAr ?? this.titleAr,
      bodyAr: bodyAr ?? this.bodyAr,
      isVisible: isVisible ?? this.isVisible,
      isEditable: isEditable ?? this.isEditable,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title_ar': titleAr,
    'body_ar': bodyAr,
    'is_visible': isVisible ? 1 : 0,
    'is_editable': isEditable ? 1 : 0,
  };
}

class ContractAnnex {
  final int number;
  final String titleAr;
  final String bodyAr;

  const ContractAnnex({required this.number, required this.titleAr, required this.bodyAr});

  Map<String, dynamic> toMap() => {'number': number, 'title_ar': titleAr, 'body_ar': bodyAr};
}

class Contract {
  final String id;
  final ContractType type;
  final String contractDate;
  final String city;
  final String governorate;
  final List<Person> sellers;
  final List<Person> buyers;
  final List<Person> witnesses;
  final Property property;
  final Payment payment;
  final List<Heir> heirs;
  final bool isKalala;
  final bool willExceedsThird;
  final bool willHasHeirConsent;
  final bool judgmentIsFinal;
  final String judgmentNumber;
  final String judgmentDate;
  final String judgmentCourt;
  final List<ContractClause> customClauses;
  final List<ContractAnnex> annexes;
  final String status;
  final String referenceNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ✅ إضافة دعم الإرث
  final Person? deceased;
  final bool isInheritance;

  Contract({
    required this.id,
    this.type = ContractType.directSale,
    this.contractDate = '',
    this.city = '',
    this.governorate = '',
    this.sellers = const [],
    this.buyers = const [],
    this.witnesses = const [],
    required this.property,
    required this.payment,
    this.heirs = const [],
    this.isKalala = false,
    this.willExceedsThird = false,
    this.willHasHeirConsent = false,
    this.judgmentIsFinal = false,
    this.judgmentNumber = '',
    this.judgmentDate = '',
    this.judgmentCourt = '',
    this.customClauses = const [],
    this.annexes = const [],
    this.status = 'draft',
    this.referenceNumber = '',
    this.deceased,
    this.isInheritance = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Contract copyWith({
    ContractType? type,
    String? contractDate,
    String? city,
    String? governorate,
    List<Person>? sellers,
    List<Person>? buyers,
    List<Person>? witnesses,
    Property? property,
    Payment? payment,
    List<Heir>? heirs,
    bool? isKalala,
    bool? willExceedsThird,
    bool? willHasHeirConsent,
    bool? judgmentIsFinal,
    String? judgmentNumber,
    String? judgmentDate,
    String? judgmentCourt,
    List<ContractClause>? customClauses,
    List<ContractAnnex>? annexes,
    String? status,
    String? referenceNumber,
    Person? deceased,
    bool? isInheritance,
  }) {
    return Contract(
      id: id,
      type: type ?? this.type,
      contractDate: contractDate ?? this.contractDate,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      sellers: sellers ?? this.sellers,
      buyers: buyers ?? this.buyers,
      witnesses: witnesses ?? this.witnesses,
      property: property ?? this.property,
      payment: payment ?? this.payment,
      heirs: heirs ?? this.heirs,
      isKalala: isKalala ?? this.isKalala,
      willExceedsThird: willExceedsThird ?? this.willExceedsThird,
      willHasHeirConsent: willHasHeirConsent ?? this.willHasHeirConsent,
      judgmentIsFinal: judgmentIsFinal ?? this.judgmentIsFinal,
      judgmentNumber: judgmentNumber ?? this.judgmentNumber,
      judgmentDate: judgmentDate ?? this.judgmentDate,
      judgmentCourt: judgmentCourt ?? this.judgmentCourt,
      customClauses: customClauses ?? this.customClauses,
      annexes: annexes ?? this.annexes,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      deceased: deceased ?? this.deceased,
      isInheritance: isInheritance ?? this.isInheritance,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.index,
    'contract_date': contractDate,
    'city': city,
    'governorate': governorate,
    'sellers': sellers.map((p) => p.toMap()).toList(),
    'buyers': buyers.map((p) => p.toMap()).toList(),
    'witnesses': witnesses.map((p) => p.toMap()).toList(),
    'property': property.toMap(),
    'payment': payment.toMap(),
    'heirs': heirs.map((h) => h.toMap()).toList(),
    'is_kalala': isKalala ? 1 : 0,
    'will_exceeds_third': willExceedsThird ? 1 : 0,
    'will_has_heir_consent': willHasHeirConsent ? 1 : 0,
    'judgment_is_final': judgmentIsFinal ? 1 : 0,
    'judgment_number': judgmentNumber,
    'judgment_date': judgmentDate,
    'judgment_court': judgmentCourt,
    'custom_clauses': customClauses.map((c) => c.toMap()).toList(),
    'annexes': annexes.map((a) => a.toMap()).toList(),
    'status': status,
    'reference_number': referenceNumber,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'deceased': deceased?.toMap(),
    'is_inheritance': isInheritance ? 1 : 0,
  };
}
