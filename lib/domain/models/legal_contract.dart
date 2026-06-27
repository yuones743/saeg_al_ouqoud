enum ContractType { sale, rent, gift, partnership, vehicleSale, vehicleRent, agency }

enum PartyRole { seller, buyer, lessor, lessee, donor, donee, partner, agent }

enum LegalCapacity { individual, guardian, agent, legalEntity }

class LegalParty {
  final String id;
  final String fullName;
  final String nationalId;
  final String fatherName;
  final String motherName;
  final String address;
  final String phone;
  final PartyRole role;
  final LegalCapacity capacity;
  final double share;
  final String? poaNumber;
  final String? poaDate;
  final bool isMinor;
  final bool isExpatriate;

  LegalParty({
    required this.id,
    required this.fullName,
    required this.nationalId,
    this.fatherName = '',
    this.motherName = '',
    this.address = '',
    this.phone = '',
    required this.role,
    this.capacity = LegalCapacity.individual,
    this.share = 0,
    this.poaNumber,
    this.poaDate,
    this.isMinor = false,
    this.isExpatriate = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'nationalId': nationalId,
    'fatherName': fatherName,
    'motherName': motherName,
    'address': address,
    'phone': phone,
    'role': role.index,
    'capacity': capacity.index,
    'share': share,
    'poaNumber': poaNumber,
    'poaDate': poaDate,
    'isMinor': isMinor,
    'isExpatriate': isExpatriate,
  };
}

class LegalContractData {
  final String id;
  final ContractType type;
  final List<LegalParty> sellers;
  final List<LegalParty> buyers;
  final String propertyNumber;
  final String propertyZone;
  final String propertyAddress;
  final double propertyArea;
  final String boundaries;
  final double totalPrice;
  final String paymentMethod;
  final double penaltyAmount;
  final List<String> customClauses;
  final DateTime createdAt;

  LegalContractData({
    required this.id,
    required this.type,
    this.sellers = const [],
    this.buyers = const [],
    this.propertyNumber = '',
    this.propertyZone = '',
    this.propertyAddress = '',
    this.propertyArea = 0,
    this.boundaries = '',
    this.totalPrice = 0,
    this.paymentMethod = 'نقداً',
    this.penaltyAmount = 0,
    this.customClauses = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalSellers => sellers.length;
  int get totalBuyers => buyers.length;
  double get totalShares => sellers.fold(0, (sum, p) => sum + p.share);
}
