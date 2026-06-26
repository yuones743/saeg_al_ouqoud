enum PropertyType {
  apartment, shop, ownedLand, amiriaLand, privateVehicle, taxiVehicle,
  truck, heavyMachinery, agriculturalTractor, rooftop, basement, annex,
  villa, arabicHouse, farm, agriculturalLand, multiUnit,
}

class Property {
  final String registryNumber;
  final String zone;
  final String planNumber;
  final String plotNumber;
  final String ownershipDocNumber;
  final String ownershipDocDate;
  final String ownershipDocSource;
  final String address;
  final double area;
  final PropertyType type;
  final bool hasSeizure;
  final bool hasMortgage;
  final bool hasReleaseLetter;
  final bool isEndowment;
  final bool isViolation;
  final bool isCommonShare;
  final double commonShareNumerator;
  final double commonShareDenominator;
  final bool underExpropriation;
  final bool hasActiveLawsuit;
  final bool isAmiriaLand;
  final bool isMinorsDowry;
  final bool subjectToInvestmentLaw;
  final bool hasShamIndicators;
  final String description;
  final String boundaries;
  final String northBoundary;
  final String southBoundary;
  final String eastBoundary;
  final String westBoundary;

  const Property({
    this.registryNumber = '', this.zone = '', this.planNumber = '', this.plotNumber = '',
    this.ownershipDocNumber = '', this.ownershipDocDate = '', this.ownershipDocSource = '',
    this.address = '', this.area = 0, this.type = PropertyType.apartment,
    this.hasSeizure = false, this.hasMortgage = false, this.hasReleaseLetter = false,
    this.isEndowment = false, this.isViolation = false, this.isCommonShare = false,
    this.commonShareNumerator = 1, this.commonShareDenominator = 1,
    this.underExpropriation = false, this.hasActiveLawsuit = false,
    this.isAmiriaLand = false, this.isMinorsDowry = false,
    this.subjectToInvestmentLaw = false, this.hasShamIndicators = false,
    this.description = '', this.boundaries = '',
    this.northBoundary = '', this.southBoundary = '',
    this.eastBoundary = '', this.westBoundary = '',
  });

  Map<String, dynamic> toMap() => {
    'registry_number': registryNumber, 'zone': zone, 'plan_number': planNumber,
    'plot_number': plotNumber, 'ownership_doc_number': ownershipDocNumber,
    'ownership_doc_date': ownershipDocDate, 'ownership_doc_source': ownershipDocSource,
    'address': address, 'area': area, 'type': type.index,
    'has_seizure': hasSeizure ? 1 : 0, 'has_mortgage': hasMortgage ? 1 : 0,
    'has_release_letter': hasReleaseLetter ? 1 : 0, 'is_endowment': isEndowment ? 1 : 0,
    'is_violation': isViolation ? 1 : 0, 'is_common_share': isCommonShare ? 1 : 0,
    'common_share_numerator': commonShareNumerator,
    'common_share_denominator': commonShareDenominator,
    'under_expropriation': underExpropriation ? 1 : 0,
    'has_active_lawsuit': hasActiveLawsuit ? 1 : 0,
    'is_amiria_land': isAmiriaLand ? 1 : 0,
    'is_minors_dowry': isMinorsDowry ? 1 : 0,
    'subject_to_investment_law': subjectToInvestmentLaw ? 1 : 0,
    'has_sham_indicators': hasShamIndicators ? 1 : 0,
    'description': description, 'boundaries': boundaries,
    'north_boundary': northBoundary, 'south_boundary': southBoundary,
    'east_boundary': eastBoundary, 'west_boundary': westBoundary,
  };
}