import '../models/contract.dart';
import '../models/person.dart';

class ContractSnapshot {
  final String contractType;
  final bool sellerIsMinor;
  final bool sellerHasGuardianPermission;
  final bool sellerIsExpatriate;
  final bool sellerHasPowerOfAttorney;
  final bool sellerIsMissing;
  final bool sellerHasJudicialRepresentative;
  final bool sellerIsDeceased;
  final bool buyerIsMinor;
  final bool buyerIsForeign;
  final bool buyerHasForeignLicense;
  final bool buyerIsDualNational;
  final bool buyerIsLegalEntity;
  final bool propertyHasSeizure;
  final bool propertyHasMortgage;
  final bool propertyHasReleaseLetter;
  final bool propertyIsEndowment;
  final bool propertyIsViolation;
  final bool propertyIsCommonShare;
  final bool propertyUnderExpropriation;
  final bool propertyHasActiveLawsuit;
  final String propertyType;
  final bool propertyIsAmiriaLand;
  final bool propertyIsMinorsDowry;
  final bool judgmentIsFinal;
  final bool agentBuysForSelf;
  final bool agentHasSelfBuyPermission;
  final bool inheritanceHasKillerHeir;
  final bool inheritanceHasApostateHeir;
  final bool willExceedsThird;
  final bool willHasHeirConsent;
  final bool hasPregnantHeir;
  final bool hasMissingHeir;
  final bool hasPrisonerHeir;
  final bool hasIntersexHeir;
  final bool divorceDuringIllness;
  final String divorceType;
  final int marriageCount;
  final bool isKalala;
  final double totalPrice;
  final double paidAmount;
  final String currency;
  final String paymentMethod;
  final List<String> missingMandatoryFields;
  final List<String> missingOptionalFields;
  final bool propertySubjectToInvestmentLaw;
  final bool hasShamIndicators;

  const ContractSnapshot({
    required this.contractType, required this.sellerIsMinor,
    required this.sellerHasGuardianPermission, required this.sellerIsExpatriate,
    required this.sellerHasPowerOfAttorney, required this.sellerIsMissing,
    required this.sellerHasJudicialRepresentative, required this.sellerIsDeceased,
    required this.buyerIsMinor, required this.buyerIsForeign,
    required this.buyerHasForeignLicense, required this.buyerIsDualNational,
    required this.buyerIsLegalEntity, required this.propertyHasSeizure,
    required this.propertyHasMortgage, required this.propertyHasReleaseLetter,
    required this.propertyIsEndowment, required this.propertyIsViolation,
    required this.propertyIsCommonShare, required this.propertyUnderExpropriation,
    required this.propertyHasActiveLawsuit, required this.propertyType,
    required this.propertyIsAmiriaLand, required this.propertyIsMinorsDowry,
    required this.judgmentIsFinal, required this.agentBuysForSelf,
    required this.agentHasSelfBuyPermission, required this.inheritanceHasKillerHeir,
    required this.inheritanceHasApostateHeir, required this.willExceedsThird,
    required this.willHasHeirConsent, required this.hasPregnantHeir,
    required this.hasMissingHeir, required this.hasPrisonerHeir,
    required this.hasIntersexHeir, required this.divorceDuringIllness,
    required this.divorceType, required this.marriageCount, required this.isKalala,
    required this.totalPrice, required this.paidAmount, required this.currency,
    required this.paymentMethod, required this.missingMandatoryFields,
    required this.missingOptionalFields, required this.propertySubjectToInvestmentLaw,
    required this.hasShamIndicators,
  });

  factory ContractSnapshot.fromContract(Contract c) {
    final seller = c.sellers.isNotEmpty ? c.sellers.first : null;
    final buyer = c.buyers.isNotEmpty ? c.buyers.first : null;
    final missingMandatory = <String>[];
    final missingOptional = <String>[];

    if (c.contractDate.isEmpty) missingMandatory.add('contract_date');
    if (c.city.isEmpty) missingMandatory.add('city');
    if (c.sellers.isEmpty) missingMandatory.add('seller');
    if (c.buyers.isEmpty && c.type != ContractType.inheritanceAgreement && c.type != ContractType.judicialInheritance) {
      missingMandatory.add('buyer');
    }
    if (c.property.registryNumber.isEmpty && c.type != ContractType.settlement) {
      missingMandatory.add('registry_number');
    }
    final isMoney = c.type != ContractType.settlement && c.type != ContractType.inheritanceAgreement &&
        c.type != ContractType.judicialInheritance && c.type != ContractType.partition &&
        c.type != ContractType.judicialPartition && c.type != ContractType.judicialExit;
    if (isMoney && c.payment.totalPrice <= 0) missingMandatory.add('total_price');
    if (c.witnesses.isEmpty) missingOptional.add('witnesses');
    if (c.property.area <= 0) missingOptional.add('property_area');
    if (c.property.boundaries.isEmpty && c.property.northBoundary.isEmpty) missingOptional.add('property_boundaries');

    return ContractSnapshot(
      contractType: c.type.name,
      sellerIsMinor: seller?.isMinor ?? false,
      sellerHasGuardianPermission: seller?.hasGuardianPermission ?? false,
      sellerIsExpatriate: seller?.isExpatriate ?? false,
      sellerHasPowerOfAttorney: seller?.hasPowerOfAttorney ?? false,
      sellerIsMissing: seller?.isMissing ?? false,
      sellerHasJudicialRepresentative: seller?.hasJudicialRepresentative ?? false,
      sellerIsDeceased: seller?.isDeceased ?? false,
      buyerIsMinor: buyer?.isMinor ?? false,
      buyerIsForeign: buyer?.nationality == NationalityType.foreignLicensed,
      buyerHasForeignLicense: buyer?.nationality == NationalityType.foreignLicensed && (buyer?.hasPowerOfAttorney ?? false),
      buyerIsDualNational: buyer?.nationality == NationalityType.dualNational,
      buyerIsLegalEntity: buyer?.nationality == NationalityType.legalEntity,
      propertyHasSeizure: c.property.hasSeizure,
      propertyHasMortgage: c.property.hasMortgage,
      propertyHasReleaseLetter: c.property.hasReleaseLetter,
      propertyIsEndowment: c.property.isEndowment,
      propertyIsViolation: c.property.isViolation,
      propertyIsCommonShare: c.property.isCommonShare,
      propertyUnderExpropriation: c.property.underExpropriation,
      propertyHasActiveLawsuit: c.property.hasActiveLawsuit,
      propertyType: c.property.type.name,
      propertyIsAmiriaLand: c.property.isAmiriaLand,
      propertyIsMinorsDowry: c.property.isMinorsDowry,
      judgmentIsFinal: c.judgmentIsFinal,
      agentBuysForSelf: seller?.agentBuysForSelf ?? false,
      agentHasSelfBuyPermission: seller?.agentHasSelfBuyPermission ?? false,
      inheritanceHasKillerHeir: c.heirs.any((h) => h.isKiller),
      inheritanceHasApostateHeir: c.heirs.any((h) => h.isApostate),
      willExceedsThird: c.willExceedsThird,
      willHasHeirConsent: c.willHasHeirConsent,
      hasPregnantHeir: c.heirs.any((h) => h.isPregnant),
      hasMissingHeir: c.heirs.any((h) => h.person.isMissing),
      hasPrisonerHeir: c.heirs.any((h) => h.isPrisoner),
      hasIntersexHeir: c.heirs.any((h) => h.isIntersex),
      divorceDuringIllness: seller?.divorceDuringIllness ?? false,
      divorceType: seller?.divorceType.name ?? 'none',
      marriageCount: seller?.marriageCount ?? 1,
      isKalala: c.isKalala,
      totalPrice: c.payment.totalPrice,
      paidAmount: c.payment.paidAmount,
      currency: c.payment.currency.name,
      paymentMethod: c.payment.method.name,
      missingMandatoryFields: missingMandatory,
      missingOptionalFields: missingOptional,
      propertySubjectToInvestmentLaw: c.property.subjectToInvestmentLaw,
      hasShamIndicators: c.property.hasShamIndicators,
    );
  }
}