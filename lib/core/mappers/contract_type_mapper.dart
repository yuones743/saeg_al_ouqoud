// ───────────────────────────────────────────────────────────────────────────────
// 📁 الملف: lib/core/mappers/contract_type_mapper.dart
// 📦 الوصف: محول أنواع العقود بين النظامين
// ───────────────────────────────────────────────────────────────────────────────

import '../../domain/models/legal_contract.dart' as legal;
import '../../domain/models/contract.dart';

class ContractTypeMapper {
  static ContractType map(legal.ContractType type) {
    switch (type) {
      case legal.ContractType.sale:
        return ContractType.directSale;
      case legal.ContractType.rent:
        return ContractType.settlement;
      case legal.ContractType.gift:
        return ContractType.settlement;
      case legal.ContractType.partnership:
        return ContractType.complexProperty;
      case legal.ContractType.vehicleSale:
        return ContractType.directSale;
      case legal.ContractType.vehicleRent:
        return ContractType.settlement;
      case legal.ContractType.agency:
        return ContractType.settlement;
    }
  }
}
