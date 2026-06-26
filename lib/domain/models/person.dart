enum PersonRole { seller, buyer, heir, agent, witness }
enum NationalityType { syrian, foreignLicensed, dualNational, legalEntity }
enum MaritalStatus { single, married, divorced, widowed }
enum DivorceType { none, revocable, irrevocable, beforeConsummation }

class Person {
  final String id;
  final String fullName;
  final String fatherName;
  final String motherName;
  final String birthYear;
  final String residency;
  final String familyId;
  final String nationalId;
  final NationalityType nationality;
  final String idNumber;
  final String idIssuedBy;
  final String idIssuedDate;
  final MaritalStatus maritalStatus;
  final String profession;
  final String address;
  final String phone;
  final PersonRole role;
  final bool isMinor;
  final bool isExpatriate;
  final bool isMissing;
  final bool isDeceased;
  final bool hasPowerOfAttorney;
  final String poaNumber;
  final String poaDate;
  final bool hasGuardianPermission;
  final bool hasJudicialRepresentative;
  final bool agentBuysForSelf;
  final bool agentHasSelfBuyPermission;
  final int marriageCount;
  final DivorceType divorceType;
  final bool divorceDuringIllness;

  const Person({
    required this.id,
    this.fullName = '', this.fatherName = '', this.motherName = '',
    this.birthYear = '', this.residency = '', this.familyId = '',
    this.nationalId = '', this.nationality = NationalityType.syrian,
    this.idNumber = '', this.idIssuedBy = '', this.idIssuedDate = '',
    this.maritalStatus = MaritalStatus.single, this.profession = '',
    this.address = '', this.phone = '', this.role = PersonRole.seller,
    this.isMinor = false, this.isExpatriate = false,
    this.isMissing = false, this.isDeceased = false,
    this.hasPowerOfAttorney = false, this.poaNumber = '', this.poaDate = '',
    this.hasGuardianPermission = false, this.hasJudicialRepresentative = false,
    this.agentBuysForSelf = false, this.agentHasSelfBuyPermission = false,
    this.marriageCount = 1, this.divorceType = DivorceType.none,
    this.divorceDuringIllness = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'full_name': fullName, 'father_name': fatherName,
    'mother_name': motherName, 'birth_year': birthYear, 'residency': residency,
    'family_id': familyId, 'national_id': nationalId, 'nationality': nationality.index,
    'id_number': idNumber, 'id_issued_by': idIssuedBy, 'id_issued_date': idIssuedDate,
    'marital_status': maritalStatus.index, 'profession': profession, 'address': address,
    'phone': phone, 'role': role.index, 'is_minor': isMinor ? 1 : 0,
    'is_expatriate': isExpatriate ? 1 : 0, 'is_missing': isMissing ? 1 : 0,
    'is_deceased': isDeceased ? 1 : 0, 'has_poa': hasPowerOfAttorney ? 1 : 0,
    'poa_number': poaNumber, 'poa_date': poaDate,
    'has_guardian_permission': hasGuardianPermission ? 1 : 0,
    'has_judicial_representative': hasJudicialRepresentative ? 1 : 0,
    'agent_buys_for_self': agentBuysForSelf ? 1 : 0,
    'agent_has_self_buy_permission': agentHasSelfBuyPermission ? 1 : 0,
    'marriage_count': marriageCount, 'divorce_type': divorceType.index,
    'divorce_during_illness': divorceDuringIllness ? 1 : 0,
  };
}