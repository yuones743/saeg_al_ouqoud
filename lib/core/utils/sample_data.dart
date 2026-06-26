import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';

class SampleData {
  static Contract getSampleDirectSale() {
    return Contract(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ContractType.directSale,
      contractDate: '15/06/2026',
      city: 'دمشق',
      governorate: 'دمشق',
      sellers: const [
        Person(
          id: 's1',
          fullName: 'أحمد محمد علي',
          fatherName: 'محمد',
          motherName: 'فاطمة',
          nationalId: '01012345678',
          phone: '0933111111',
          role: PersonRole.seller,
        ),
      ],
      buyers: const [
        Person(
          id: 'b1',
          fullName: 'خالد عبد الله',
          fatherName: 'عبد الله',
          nationalId: '02098765432',
          phone: '0933222222',
          role: PersonRole.buyer,
        ),
      ],
      property: const Property(
        registryNumber: '12345/دمشق',
        zone: 'المزة',
        planNumber: '123',
        plotNumber: '456',
        area: 150,
        type: PropertyType.apartment,
      ),
      payment: const Payment(
        totalPrice: 50000000,
        paidAmount: 30000000,
        balance: 20000000,
        currency: Currency.syp,
        method: PaymentMethod.installments,
      ),
    );
  }

  static Contract getSampleInheritance() {
    return Contract(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ContractType.inheritanceAgreement,
      contractDate: '20/06/2026',
      city: 'حلب',
      governorate: 'حلب',
      sellers: const [Person(id: 'deceased', fullName: 'المرحوم محمد علي', isDeceased: true, role: PersonRole.seller)],
      buyers: const [Person(id: 'heirs', fullName: 'الورثة', role: PersonRole.buyer)],
      property: const Property(registryNumber: '67890/حلب', zone: 'الجميلية', type: PropertyType.apartment, isAmiriaLand: false),
      payment: const Payment(totalPrice: 0),
      heirs: const [
        Heir(person: Person(id: 'w', fullName: 'الزوجة', role: PersonRole.heir), shares: 0, relation: 'زوجة'),
        Heir(person: Person(id: 's1', fullName: 'الابن ١', role: PersonRole.heir), shares: 0, relation: 'ابن'),
        Heir(person: Person(id: 's2', fullName: 'الابن ٢', role: PersonRole.heir), shares: 0, relation: 'ابن'),
        Heir(person: Person(id: 'd1', fullName: 'الابنة ١', role: PersonRole.heir), shares: 0, relation: 'ابنة'),
      ],
      isKalala: false,
    );
  }
}