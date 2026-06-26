class LegalConstants {
  static const String appVersion = '1.0.0';
  static const String appNameAr = 'صائغ العقود السوري';
  static const String appNameEn = 'Syrian Contract Drafter';
  static const int totalShares = 2400;
  static const double defaultTaxRate = 0.03;
  static const int defaultSecurityApprovalDays = 60;
  static const int maxContractTitleLength = 200;
  static const int maxPartyNameLength = 100;
  static const double maxPrice = 999999999999.0;

  static const List<String> requiredSignatures = ['البائع', 'المشتري', 'الشاهد ١', 'الشاهد ٢'];

  static const Map<String, String> articleReferences = {
    'sale_basic': 'المادة 558 مدني',
    'sale_usufruct': 'المادة 858 مدني',
    'sale_common_share': 'المادة 1026 مدني',
    'inheritance_basic': 'قانون الأحوال الشخصية',
    'kalala': 'المادة 23 أحوال',
    'killer_disinherit': 'المادة 28 أحوال',
    'apostate_disinherit': 'المادة 29 أحوال',
    'pregnancy_postpone': 'المادة 306 مدني',
    'obligatory_will': 'المادة 182 أحوال',
    'judicial_sale': 'قانون التنفيذ 30/2004',
    'partition_judicial': 'المادة 1010 مدني',
    'poa_agency': 'المادة 837 مدني',
    'foreign_investment': 'قانون الاستثمار 18/2021',
  };
}