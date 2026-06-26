import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';

class ContractTypeHelpers {
  static String getTitle(ContractType type) {
    switch (type) {
      case ContractType.directSale: return 'عقد بيع قطعي';
      case ContractType.usufructSale: return 'عقد بيع حق انتفاع';
      case ContractType.commonShareSale: return 'عقد بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'محضر اتفاق ورثة';
      case ContractType.partition: return 'عقد قسمة رضائية';
      case ContractType.settlement: return 'عقد صلح ووساطة';
      case ContractType.promise: return 'عقد وعد بالبيع';
      case ContractType.judicialSale: return 'عقد بيع بموجب حكم قضائي';
      case ContractType.judicialInheritance: return 'محضر حصر إرث قضائي';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'عقد تخارج قضائي';
      case ContractType.complexProperty: return 'محضر عقاري متعدد الوحدات';
    }
  }

  static String getShortName(ContractType type) {
    switch (type) {
      case ContractType.directSale: return 'بيع مباشر';
      case ContractType.usufructSale: return 'بيع انتفاع';
      case ContractType.commonShareSale: return 'بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'اتفاق ورثة';
      case ContractType.partition: return 'قسمة';
      case ContractType.settlement: return 'صلح';
      case ContractType.promise: return 'وعد';
      case ContractType.judicialSale: return 'بيع قضائي';
      case ContractType.judicialInheritance: return 'حصر إرث';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'تخارج';
      case ContractType.complexProperty: return 'محضر متعدد';
    }
  }

  static bool requiresPayment(ContractType type) {
    switch (type) {
      case ContractType.settlement:
      case ContractType.inheritanceAgreement:
      case ContractType.judicialInheritance:
      case ContractType.partition:
      case ContractType.judicialPartition:
      case ContractType.judicialExit:
      case ContractType.complexProperty:
        return false;
      default:
        return true;
    }
  }

  static bool requiresBuyer(ContractType type) {
    switch (type) {
      case ContractType.inheritanceAgreement:
      case ContractType.judicialInheritance:
      case ContractType.partition:
      case ContractType.judicialPartition:
        return false;
      default:
        return true;
    }
  }

  static bool requiresRegistryNumber(ContractType type) {
    return type != ContractType.settlement;
  }

  static String getMaritalStatusAr(MaritalStatus s) {
    switch (s) {
      case MaritalStatus.single: return 'أعزب';
      case MaritalStatus.married: return 'متزوج';
      case MaritalStatus.divorced: return 'مطلق';
      case MaritalStatus.widowed: return 'أرمل';
    }
  }

  static String getNationalityAr(NationalityType n) {
    switch (n) {
      case NationalityType.syrian: return 'سوري';
      case NationalityType.foreignLicensed: return 'أجنبي بترخيص';
      case NationalityType.dualNational: return 'مزدوج الجنسية';
      case NationalityType.legalEntity: return 'شخص اعتباري';
    }
  }

  static String getPaymentMethodAr(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash: return 'نقداً';
      case PaymentMethod.bankTransfer: return 'حوالة';
      case PaymentMethod.check: return 'شيك';
      case PaymentMethod.installments: return 'دفعات';
    }
  }

  static String getCurrencyAr(Currency c) {
    switch (c) {
      case Currency.syp: return 'ل.س';
      case Currency.usd: return 'دولار';
      case Currency.eur: return 'يورو';
      case Currency.sar: return 'ريال';
      case Currency.gbp: return 'جنيه';
      case Currency.aed: return 'درهم';
    }
  }

  static String getPropertyTypeAr(PropertyType t) {
    switch (t) {
      case PropertyType.apartment: return 'شقة';
      case PropertyType.shop: return 'محل';
      case PropertyType.ownedLand: return 'أرض ملك';
      case PropertyType.amiriaLand: return 'أرض أميرية';
      case PropertyType.privateVehicle: return 'سيارة خصوصي';
      case PropertyType.taxiVehicle: return 'سيارة أجرة';
      case PropertyType.truck: return 'شاحنة';
      case PropertyType.heavyMachinery: return 'آلية ثقيلة';
      case PropertyType.agriculturalTractor: return 'جرار';
      case PropertyType.rooftop: return 'سطح';
      case PropertyType.basement: return 'قبو';
      case PropertyType.annex: return 'ملحق';
      case PropertyType.villa: return 'فيلا';
      case PropertyType.arabicHouse: return 'بيت عربي';
      case PropertyType.farm: return 'مزرعة';
      case PropertyType.agriculturalLand: return 'أرض زراعية';
      case PropertyType.multiUnit: return 'متعدد الوحدات';
    }
  }
}