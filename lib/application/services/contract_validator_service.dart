import '../../domain/models/contract.dart';

class ContractValidatorService {
  static const Map<ContractType, List<String>> requiredFields = {
    ContractType.directSale: ['seller_name', 'buyer_name', 'registry_number', 'total_price'],
    ContractType.usufructSale: ['seller_name', 'buyer_name', 'registry_number', 'total_price', 'usufruct_type'],
    ContractType.commonShareSale: ['seller_name', 'buyer_name', 'registry_number', 'total_price', 'share_ratio'],
    ContractType.inheritanceAgreement: ['deceased_name', 'heirs'],
    ContractType.partition: ['parties', 'registry_number', 'shares'],
    ContractType.settlement: ['party1', 'party2', 'terms'],
    ContractType.promise: ['seller_name', 'buyer_name', 'registry_number', 'total_price', 'deadline'],
    ContractType.judicialSale: ['judgment_number', 'seller_name', 'buyer_name', 'registry_number'],
    ContractType.judicialInheritance: ['judgment_number', 'deceased_name', 'heirs'],
    ContractType.judicialPartition: ['judgment_number', 'parties', 'shares'],
    ContractType.judicialExit: ['judgment_number', 'parties', 'amount'],
    ContractType.complexProperty: ['owner_name', 'registry_number', 'units'],
  };

  static List<String> validate(Contract contract) {
    final required = requiredFields[contract.type] ?? [];
    final missing = <String>[];

    for (final field in required) {
      switch (field) {
        case 'seller_name':
          if (contract.sellers.isEmpty || contract.sellers.first.fullName.isEmpty) missing.add(field);
          break;
        case 'buyer_name':
          if (contract.buyers.isEmpty || contract.buyers.first.fullName.isEmpty) missing.add(field);
          break;
        case 'registry_number':
          if (contract.property.registryNumber.isEmpty) missing.add(field);
          break;
        case 'total_price':
          if (contract.payment.totalPrice <= 0) missing.add(field);
          break;
        case 'usufruct_type':
          if (contract.property.type.name.isEmpty) missing.add(field);
          break;
        case 'share_ratio':
          if (contract.property.commonShareNumerator <= 0) missing.add(field);
          break;
        case 'deceased_name':
          if (contract.sellers.isEmpty || contract.sellers.first.fullName.isEmpty) missing.add(field);
          break;
        case 'heirs':
          if (contract.heirs.isEmpty) missing.add(field);
          break;
        case 'parties':
          if (contract.sellers.isEmpty && contract.buyers.isEmpty) missing.add(field);
          break;
        case 'shares':
          if (contract.heirs.isEmpty) missing.add(field);
          break;
        case 'party1':
          if (contract.sellers.isEmpty) missing.add(field);
          break;
        case 'party2':
          if (contract.buyers.isEmpty) missing.add(field);
          break;
        case 'terms':
          if (contract.customClauses.isEmpty) missing.add(field);
          break;
        case 'deadline':
          if (contract.payment.balanceDueDate.isEmpty) missing.add(field);
          break;
        case 'judgment_number':
          if (contract.judgmentNumber.isEmpty) missing.add(field);
          break;
        case 'amount':
          if (contract.payment.totalPrice <= 0) missing.add(field);
          break;
        case 'owner_name':
          if (contract.sellers.isEmpty) missing.add(field);
          break;
        case 'units':
          if (contract.customClauses.isEmpty) missing.add(field);
          break;
      }
    }

    return missing;
  }

  static bool isComplete(Contract contract) => validate(contract).isEmpty;
}