import '../../domain/snapshot/contract_snapshot.dart';

class RuleExecutionContext {
  final Map<String, dynamic> _variables;

  RuleExecutionContext._(this._variables);

  factory RuleExecutionContext.fromSnapshot(ContractSnapshot snapshot) {
    return RuleExecutionContext._({
      'contract_type': snapshot.contractType,
      'seller_is_minor': snapshot.sellerIsMinor,
      'seller_has_guardian_permission': snapshot.sellerHasGuardianPermission,
      'seller_is_expatriate': snapshot.sellerIsExpatriate,
      'seller_has_power_of_attorney': snapshot.sellerHasPowerOfAttorney,
      'seller_is_missing': snapshot.sellerIsMissing,
      'seller_has_judicial_representative': snapshot.sellerHasJudicialRepresentative,
      'seller_is_deceased': snapshot.sellerIsDeceased,
      'buyer_is_minor': snapshot.buyerIsMinor,
      'buyer_is_foreign': snapshot.buyerIsForeign,
      'buyer_has_foreign_license': snapshot.buyerHasForeignLicense,
      'buyer_is_dual_national': snapshot.buyerIsDualNational,
      'buyer_is_legal_entity': snapshot.buyerIsLegalEntity,
      'property_has_seizure': snapshot.propertyHasSeizure,
      'property_has_mortgage': snapshot.propertyHasMortgage,
      'property_has_release_letter': snapshot.propertyHasReleaseLetter,
      'property_is_endowment': snapshot.propertyIsEndowment,
      'property_is_violation': snapshot.propertyIsViolation,
      'property_is_common_share': snapshot.propertyIsCommonShare,
      'property_under_expropriation': snapshot.propertyUnderExpropriation,
      'property_has_active_lawsuit': snapshot.propertyHasActiveLawsuit,
      'property_type': snapshot.propertyType,
      'property_is_amiria_land': snapshot.propertyIsAmiriaLand,
      'property_is_minors_dowry': snapshot.propertyIsMinorsDowry,
      'judgment_is_final': snapshot.judgmentIsFinal,
      'agent_buys_for_self': snapshot.agentBuysForSelf,
      'agent_has_self_buy_permission': snapshot.agentHasSelfBuyPermission,
      'inheritance_has_killer_heir': snapshot.inheritanceHasKillerHeir,
      'inheritance_has_apostate_heir': snapshot.inheritanceHasApostateHeir,
      'will_exceeds_third': snapshot.willExceedsThird,
      'will_has_heir_consent': snapshot.willHasHeirConsent,
      'has_pregnant_heir': snapshot.hasPregnantHeir,
      'has_missing_heir': snapshot.hasMissingHeir,
      'has_prisoner_heir': snapshot.hasPrisonerHeir,
      'has_intersex_heir': snapshot.hasIntersexHeir,
      'divorce_during_illness': snapshot.divorceDuringIllness,
      'divorce_type': snapshot.divorceType,
      'marriage_count': snapshot.marriageCount,
      'is_kalala': snapshot.isKalala,
      'total_price': snapshot.totalPrice,
      'paid_amount': snapshot.paidAmount,
      'currency': snapshot.currency,
      'payment_method': snapshot.paymentMethod,
      'missing_mandatory_fields': snapshot.missingMandatoryFields,
      'missing_optional_fields': snapshot.missingOptionalFields,
      'property_subject_to_investment_law': snapshot.propertySubjectToInvestmentLaw,
      'has_sham_indicators': snapshot.hasShamIndicators,
    });
  }

  Object? get(String name) => _variables[name];
  bool has(String name) => _variables.containsKey(name);
}