import '../../domain/models/contract.dart';

class ContractSearch {
  static List<Contract> search(List<Contract> contracts, String query) {
    if (query.isEmpty) return contracts;
    final q = query.toLowerCase();
    return contracts.where((c) {
      final seller = c.sellers.isNotEmpty ? c.sellers.first.fullName.toLowerCase() : '';
      final buyer = c.buyers.isNotEmpty ? c.buyers.first.fullName.toLowerCase() : '';
      final registry = c.property.registryNumber.toLowerCase();
      final zone = c.property.zone.toLowerCase();
      return seller.contains(q) || buyer.contains(q) || registry.contains(q) || zone.contains(q);
    }).toList();
  }

  static List<Contract> filterByType(List<Contract> contracts, ContractType type) {
    return contracts.where((c) => c.type == type).toList();
  }

  static List<Contract> filterByPriceRange(List<Contract> contracts, double min, double max) {
    return contracts.where((c) => c.payment.totalPrice >= min && c.payment.totalPrice <= max).toList();
  }

  static List<Contract> sortByDate(List<Contract> contracts, {bool ascending = false}) {
    final list = List<Contract>.from(contracts);
    list.sort((a, b) => ascending ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static List<Contract> sortByPrice(List<Contract> contracts, {bool ascending = false}) {
    final list = List<Contract>.from(contracts);
    list.sort((a, b) => ascending ? a.payment.totalPrice.compareTo(b.payment.totalPrice) : b.payment.totalPrice.compareTo(a.payment.totalPrice));
    return list;
  }
}