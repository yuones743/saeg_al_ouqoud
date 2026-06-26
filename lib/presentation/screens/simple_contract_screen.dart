import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';
import 'clause_manager_screen.dart';
import 'witness_manager_screen.dart';
import 'annex_manager_screen.dart';

class SimpleContractScreen extends StatefulWidget {
  const SimpleContractScreen({super.key});

  @override
  State<SimpleContractScreen> createState() => _SimpleContractScreenState();
}

class _SimpleContractScreenState extends State<SimpleContractScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sellerNameCtrl = TextEditingController();
  final _sellerFatherCtrl = TextEditingController();
  final _sellerMotherCtrl = TextEditingController();
  final _sellerBirthYearCtrl = TextEditingController();
  final _sellerResidencyCtrl = TextEditingController();
  final _sellerFamilyIdCtrl = TextEditingController();
  final _sellerNationalIdCtrl = TextEditingController();
  final _sellerIdNumCtrl = TextEditingController();
  final _sellerIdIssuedByCtrl = TextEditingController();
  final _sellerIdIssuedDateCtrl = TextEditingController();
  final _sellerPhoneCtrl = TextEditingController();
  final _sellerAddressCtrl = TextEditingController();
  final _sellerProfessionCtrl = TextEditingController();
  final _sellerPoaNumCtrl = TextEditingController();
  final _sellerPoaDateCtrl = TextEditingController();

  final _buyerNameCtrl = TextEditingController();
  final _buyerFatherCtrl = TextEditingController();
  final _buyerMotherCtrl = TextEditingController();
  final _buyerNationalIdCtrl = TextEditingController();
  final _buyerIdNumCtrl = TextEditingController();
  final _buyerPhoneCtrl = TextEditingController();
  final _buyerAddressCtrl = TextEditingController();
  final _buyerProfessionCtrl = TextEditingController();

  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _govCtrl = TextEditingController();
  final _refNumCtrl = TextEditingController();

  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _planCtrl = TextEditingController();
  final _plotCtrl = TextEditingController();
  final _ownershipDocCtrl = TextEditingController();
  final _ownershipDateCtrl = TextEditingController();
  final _ownershipSourceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _boundariesCtrl = TextEditingController();
  final _northCtrl = TextEditingController();
  final _southCtrl = TextEditingController();
  final _eastCtrl = TextEditingController();
  final _westCtrl = TextEditingController();

  final _totalPriceCtrl = TextEditingController();
  final _paidCtrl = TextEditingController();
  final _balanceDateCtrl = TextEditingController();
  final _penaltyCtrl = TextEditingController();

  bool _sellerIsMinor = false;
  bool _sellerIsExpatriate = false;
  bool _sellerHasPoa = false;
  bool _sellerIsMissing = false;
  bool _sellerIsDeceased = false;
  bool _sellerHasGuardianPermission = false;
  bool _sellerHasJudicialRep = false;
  bool _sellerAgentBuysForSelf = false;
  bool _sellerAgentHasSelfBuyPermission = false;
  bool _buyerIsMinor = false;
  bool _propHasSeizure = false;
  bool _propHasMortgage = false;
  bool _propIsEndowment = false;
  bool _propIsViolation = false;
  bool _propIsCommonShare = false;
  bool _propHasActiveLawsuit = false;
  bool _propHasReleaseLetter = false;
  bool _propIsMinorsDowry = false;
  bool _propIsAmiriaLand = false;
  bool _propUnderExpropriation = false;
  bool _propSubjectToInvestmentLaw = false;
  bool _propHasShamIndicators = false;

  PropertyType _propType = PropertyType.apartment;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  ExpenseAllocation _expenseAlloc = ExpenseAllocation.buyer;
  Currency _currency = Currency.syp;
  MaritalStatus _sellerMarital = MaritalStatus.single;
  NationalityType _buyerNationality = NationalityType.syrian;

  @override
  void dispose() {
    for (final c in [_sellerNameCtrl, _sellerFatherCtrl, _sellerMotherCtrl, _sellerBirthYearCtrl, _sellerResidencyCtrl, _sellerFamilyIdCtrl, _sellerNationalIdCtrl, _sellerIdNumCtrl, _sellerIdIssuedByCtrl, _sellerIdIssuedDateCtrl, _sellerPhoneCtrl, _sellerAddressCtrl, _sellerProfessionCtrl, _sellerPoaNumCtrl, _sellerPoaDateCtrl, _buyerNameCtrl, _buyerFatherCtrl, _buyerMotherCtrl, _buyerNationalIdCtrl, _buyerIdNumCtrl, _buyerPhoneCtrl, _buyerAddressCtrl, _buyerProfessionCtrl, _dateCtrl, _cityCtrl, _govCtrl, _refNumCtrl, _registryCtrl, _zoneCtrl, _planCtrl, _plotCtrl, _ownershipDocCtrl, _ownershipDateCtrl, _ownershipSourceCtrl, _areaCtrl, _boundariesCtrl, _northCtrl, _southCtrl, _eastCtrl, _westCtrl, _totalPriceCtrl, _paidCtrl, _balanceDateCtrl, _penaltyCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateGovernorate(_govCtrl.text);
    provider.setReferenceNumber(_refNumCtrl.text);
    provider.updateSeller(Person(
      id: 'seller_1', fullName: _sellerNameCtrl.text, fatherName: _sellerFatherCtrl.text,
      motherName: _sellerMotherCtrl.text, birthYear: _sellerBirthYearCtrl.text,
      residency: _sellerResidencyCtrl.text, familyId: _sellerFamilyIdCtrl.text,
      nationalId: _sellerNationalIdCtrl.text, idNumber: _sellerIdNumCtrl.text,
      idIssuedBy: _sellerIdIssuedByCtrl.text, idIssuedDate: _sellerIdIssuedDateCtrl.text,
      phone: _sellerPhoneCtrl.text, address: _sellerAddressCtrl.text,
      profession: _sellerProfessionCtrl.text, role: PersonRole.seller,
      isMinor: _sellerIsMinor, isExpatriate: _sellerIsExpatriate,
      hasPowerOfAttorney: _sellerHasPoa, poaNumber: _sellerPoaNumCtrl.text,
      poaDate: _sellerPoaDateCtrl.text, isMissing: _sellerIsMissing,
      isDeceased: _sellerIsDeceased, hasGuardianPermission: _sellerHasGuardianPermission,
      hasJudicialRepresentative: _sellerHasJudicialRep, agentBuysForSelf: _sellerAgentBuysForSelf,
      agentHasSelfBuyPermission: _sellerAgentHasSelfBuyPermission, maritalStatus: _sellerMarital,
    ));
    provider.updateBuyer(Person(
      id: 'buyer_1', fullName: _buyerNameCtrl.text, fatherName: _buyerFatherCtrl.text,
      motherName: _buyerMotherCtrl.text, nationalId: _buyerNationalIdCtrl.text,
      idNumber: _buyerIdNumCtrl.text, phone: _buyerPhoneCtrl.text,
      address: _buyerAddressCtrl.text, profession: _buyerProfessionCtrl.text,
      role: PersonRole.buyer, isMinor: _buyerIsMinor, nationality: _buyerNationality,
    ));
    final total = double.tryParse(_totalPriceCtrl.text) ?? 0;
    final paid = double.tryParse(_paidCtrl.text) ?? 0;
    provider.updateProperty(Property(
      registryNumber: _registryCtrl.text, zone: _zoneCtrl.text,
      planNumber: _planCtrl.text, plotNumber: _plotCtrl.text,
      ownershipDocNumber: _ownershipDocCtrl.text, ownershipDocDate: _ownershipDateCtrl.text,
      ownershipDocSource: _ownershipSourceCtrl.text,
      area: double.tryParse(_areaCtrl.text) ?? 0, boundaries: _boundariesCtrl.text,
      northBoundary: _northCtrl.text, southBoundary: _southCtrl.text,
      eastBoundary: _eastCtrl.text, westBoundary: _westCtrl.text,
      type: _propType, hasSeizure: _propHasSeizure, hasMortgage: _propHasMortgage,
      hasReleaseLetter: _propHasReleaseLetter, isEndowment: _propIsEndowment,
      isViolation: _propIsViolation, isCommonShare: _propIsCommonShare,
      hasActiveLawsuit: _propHasActiveLawsuit, isAmiriaLand: _propIsAmiriaLand,
      isMinorsDowry: _propIsMinorsDowry, underExpropriation: _propUnderExpropriation,
      subjectToInvestmentLaw: _propSubjectToInvestmentLaw, hasShamIndicators: _propHasShamIndicators,
    ));
    provider.updatePayment(Payment(
      totalPrice: total, paidAmount: paid, balance: total - paid,
      balanceDueDate: _balanceDateCtrl.text, method: _paymentMethod,
      expenseAllocation: _expenseAlloc,
      penaltyAmount: double.tryParse(_penaltyCtrl.text) ?? 0, currency: _currency,
    ));
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد بيع مباشر')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(title: 'بيانات العقد', icon: Icons.assignment, children: [
              ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد (يوم/شهر/سنة)'),
              ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
              _dropdownGovernorate(),
              ArabicTextField(controller: _refNumCtrl, label: 'الرقم المرجعي (اختياري)'),
            ]),
            SectionCard(title: 'بيانات البائع', icon: Icons.person, children: [
              ArabicTextField(controller: _sellerNameCtrl, label: 'الاسم الكامل', required: true),
              ArabicTextField(controller: _sellerFatherCtrl, label: 'اسم الأب'),
              ArabicTextField(controller: _sellerMotherCtrl, label: 'اسم الأم'),
              ArabicTextField(controller: _sellerBirthYearCtrl, label: 'سنة الميلاد', type: TextInputType.number),
              ArabicTextField(controller: _sellerResidencyCtrl, label: 'المسكن'),
              ArabicTextField(controller: _sellerFamilyIdCtrl, label: 'خانة/الأسرة'),
              ArabicTextField(controller: _sellerNationalIdCtrl, label: 'الرقم الوطني'),
              ArabicTextField(controller: _sellerIdNumCtrl, label: 'رقم البطاقة الشخصية'),
              ArabicTextField(controller: _sellerIdIssuedByCtrl, label: 'جهة إصدار البطاقة'),
              ArabicTextField(controller: _sellerIdIssuedDateCtrl, label: 'تاريخ إصدار البطاقة'),
              ArabicTextField(controller: _sellerPhoneCtrl, label: 'رقم الهاتف', type: TextInputType.phone),
              ArabicTextField(controller: _sellerAddressCtrl, label: 'العنوان'),
              ArabicTextField(controller: _sellerProfessionCtrl, label: 'المهنة'),
              _dropdownMaritalStatus(),
              ArabicSwitch(label: 'قاصر', value: _sellerIsMinor, onChanged: (v) => setState(() => _sellerIsMinor = v)),
              if (_sellerIsMinor)
                ArabicSwitch(label: 'يوجد إذن من القاضي/الولي', value: _sellerHasGuardianPermission, onChanged: (v) => setState(() => _sellerHasGuardianPermission = v)),
              ArabicSwitch(label: 'مغترب', value: _sellerIsExpatriate, onChanged: (v) => setState(() => _sellerIsExpatriate = v)),
              ArabicSwitch(label: 'يحمل وكالة', value: _sellerHasPoa, onChanged: (v) => setState(() => _sellerHasPoa = v)),
              if (_sellerHasPoa) ...[
                ArabicTextField(controller: _sellerPoaNumCtrl, label: 'رقم الوكالة'),
                ArabicTextField(controller: _sellerPoaDateCtrl, label: 'تاريخ الوكالة'),
              ],
              ArabicSwitch(label: 'مفقود', value: _sellerIsMissing, onChanged: (v) => setState(() => _sellerIsMissing = v)),
              if (_sellerIsMissing)
                ArabicSwitch(label: 'يوجد وكيل قضائي', value: _sellerHasJudicialRep, onChanged: (v) => setState(() => _sellerHasJudicialRep = v)),
              ArabicSwitch(label: 'متوفى', value: _sellerIsDeceased, onChanged: (v) => setState(() => _sellerIsDeceased = v)),
              ArabicSwitch(label: 'الوكيل يشتري لنفسه', value: _sellerAgentBuysForSelf, onChanged: (v) => setState(() => _sellerAgentBuysForSelf = v)),
              if (_sellerAgentBuysForSelf)
                ArabicSwitch(label: 'يوجد إذن صريح للموكل', value: _sellerAgentHasSelfBuyPermission, onChanged: (v) => setState(() => _sellerAgentHasSelfBuyPermission = v)),
            ]),
            SectionCard(title: 'بيانات المشتري', icon: Icons.person_outline, children: [
              ArabicTextField(controller: _buyerNameCtrl, label: 'الاسم الكامل', required: true),
              ArabicTextField(controller: _buyerFatherCtrl, label: 'اسم الأب'),
              ArabicTextField(controller: _buyerMotherCtrl, label: 'اسم الأم'),
              ArabicTextField(controller: _buyerNationalIdCtrl, label: 'الرقم الوطني'),
              ArabicTextField(controller: _buyerIdNumCtrl, label: 'رقم البطاقة'),
              ArabicTextField(controller: _buyerPhoneCtrl, label: 'رقم الهاتف', type: TextInputType.phone),
              ArabicTextField(controller: _buyerAddressCtrl, label: 'العنوان'),
              ArabicTextField(controller: _buyerProfessionCtrl, label: 'المهنة'),
              _dropdownBuyerNationality(),
              ArabicSwitch(label: 'قاصر', value: _buyerIsMinor, onChanged: (v) => setState(() => _buyerIsMinor = v)),
            ]),
            SectionCard(title: 'بيانات العقار', icon: Icons.home, children: [
              ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري', required: true),
              ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
              ArabicTextField(controller: _planCtrl, label: 'رقم المخطط'),
              ArabicTextField(controller: _plotCtrl, label: 'رقم القسيمة'),
              ArabicTextField(controller: _ownershipDocCtrl, label: 'رقم سند الملكية'),
              ArabicTextField(controller: _ownershipDateCtrl, label: 'تاريخ سند الملكية'),
              ArabicTextField(controller: _ownershipSourceCtrl, label: 'مصدر سند الملكية'),
              ArabicTextField(controller: _areaCtrl, label: 'المساحة (م²)', type: TextInputType.number),
              ArabicTextField(controller: _boundariesCtrl, label: 'الحدود العامة', maxLines: 2),
              _fourBoundaries(),
              _dropdownPropertyType(),
              ArabicSwitch(label: 'عليه حجز', value: _propHasSeizure, onChanged: (v) => setState(() => _propHasSeizure = v)),
              ArabicSwitch(label: 'عليه رهن', value: _propHasMortgage, onChanged: (v) => setState(() => _propHasMortgage = v)),
              if (_propHasSeizure || _propHasMortgage)
                ArabicSwitch(label: 'يوجد كتاب فك الحجز/الرهن', value: _propHasReleaseLetter, onChanged: (v) => setState(() => _propHasReleaseLetter = v)),
              ArabicSwitch(label: 'موقوف', value: _propIsEndowment, onChanged: (v) => setState(() => _propIsEndowment = v)),
              ArabicSwitch(label: 'مخالف للتنظيم', value: _propIsViolation, onChanged: (v) => setState(() => _propIsViolation = v)),
              ArabicSwitch(label: 'حصة شائعة', value: _propIsCommonShare, onChanged: (v) => setState(() => _propIsCommonShare = v)),
              ArabicSwitch(label: 'عليه دعوى نشطة', value: _propHasActiveLawsuit, onChanged: (v) => setState(() => _propHasActiveLawsuit = v)),
              ArabicSwitch(label: 'أرض أميرية', value: _propIsAmiriaLand, onChanged: (v) => setState(() => _propIsAmiriaLand = v)),
              ArabicSwitch(label: 'مهر/صداق لقاصر', value: _propIsMinorsDowry, onChanged: (v) => setState(() => _propIsMinorsDowry = v)),
              ArabicSwitch(label: 'تحت الاستملاك', value: _propUnderExpropriation, onChanged: (v) => setState(() => _propUnderExpropriation = v)),
              ArabicSwitch(label: 'خاضع لقانون الاستثمار', value: _propSubjectToInvestmentLaw, onChanged: (v) => setState(() => _propSubjectToInvestmentLaw = v)),
              ArabicSwitch(label: 'مؤشرات صورية (تعميم 2026)', value: _propHasShamIndicators, onChanged: (v) => setState(() => _propHasShamIndicators = v)),
            ]),
            SectionCard(title: 'بيانات الثمن', icon: Icons.attach_money, children: [
              ArabicTextField(controller: _totalPriceCtrl, label: 'الثمن الإجمالي', required: true, type: TextInputType.number),
              ArabicTextField(controller: _paidCtrl, label: 'المبلغ المدفوع', type: TextInputType.number),
              ArabicTextField(controller: _balanceDateCtrl, label: 'تاريخ استحقاق الرصيد'),
              ArabicTextField(controller: _penaltyCtrl, label: 'الشرط الجزائي', type: TextInputType.number),
              _dropdownCurrency(),
              _dropdownPaymentMethod(),
              _dropdownExpenseAlloc(),
            ]),
            const SizedBox(height: 24),
            PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.edit_note), label: const Text('البنود'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClauseManagerScreen())))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.people), label: const Text('الشهود'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WitnessManagerScreen())))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.note_add), label: const Text('الملاحق'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnexManagerScreen())))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _fourBoundaries() => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('الحدود التفصيلية (4 جهات)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 4),
      Row(children: [
        Expanded(child: ArabicTextField(controller: _northCtrl, label: 'شمالاً')),
        const SizedBox(width: 6),
        Expanded(child: ArabicTextField(controller: _southCtrl, label: 'جنوباً')),
      ]),
      Row(children: [
        Expanded(child: ArabicTextField(controller: _eastCtrl, label: 'شرقاً')),
        const SizedBox(width: 6),
        Expanded(child: ArabicTextField(controller: _westCtrl, label: 'غرباً')),
      ]),
    ]),
  );

  Widget _dropdownGovernorate() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<String>(
      value: _govCtrl.text.isEmpty ? null : _govCtrl.text,
      decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder(), isDense: true),
      items: SyrianGovernorates.all.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
      onChanged: (v) { if (v != null) setState(() => _govCtrl.text = v); },
    ),
  );

  Widget _dropdownMaritalStatus() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<MaritalStatus>(
      value: _sellerMarital,
      decoration: const InputDecoration(labelText: 'الحالة العائلية', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: MaritalStatus.single, child: Text('أعزب')),
        DropdownMenuItem(value: MaritalStatus.married, child: Text('متزوج')),
        DropdownMenuItem(value: MaritalStatus.divorced, child: Text('مطلق')),
        DropdownMenuItem(value: MaritalStatus.widowed, child: Text('أرمل')),
      ],
      onChanged: (v) => setState(() => _sellerMarital = v!),
    ),
  );

  Widget _dropdownBuyerNationality() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<NationalityType>(
      value: _buyerNationality,
      decoration: const InputDecoration(labelText: 'جنسية المشتري', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: NationalityType.syrian, child: Text('سوري')),
        DropdownMenuItem(value: NationalityType.foreignLicensed, child: Text('أجنبي بترخيص')),
        DropdownMenuItem(value: NationalityType.dualNational, child: Text('مزدوج الجنسية')),
        DropdownMenuItem(value: NationalityType.legalEntity, child: Text('شخص اعتباري')),
      ],
      onChanged: (v) => setState(() => _buyerNationality = v!),
    ),
  );

  Widget _dropdownPropertyType() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<PropertyType>(
      value: _propType,
      decoration: const InputDecoration(labelText: 'نوع العقار', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: PropertyType.apartment, child: Text('شقة')),
        DropdownMenuItem(value: PropertyType.shop, child: Text('محل تجاري')),
        DropdownMenuItem(value: PropertyType.ownedLand, child: Text('أرض ملك')),
        DropdownMenuItem(value: PropertyType.amiriaLand, child: Text('أرض أميرية')),
        DropdownMenuItem(value: PropertyType.villa, child: Text('فيلا')),
        DropdownMenuItem(value: PropertyType.arabicHouse, child: Text('بيت عربي')),
        DropdownMenuItem(value: PropertyType.farm, child: Text('مزرعة')),
        DropdownMenuItem(value: PropertyType.agriculturalLand, child: Text('أرض زراعية')),
        DropdownMenuItem(value: PropertyType.rooftop, child: Text('سطح')),
        DropdownMenuItem(value: PropertyType.basement, child: Text('قبو')),
        DropdownMenuItem(value: PropertyType.annex, child: Text('ملحق')),
        DropdownMenuItem(value: PropertyType.privateVehicle, child: Text('سيارة خصوصي')),
        DropdownMenuItem(value: PropertyType.taxiVehicle, child: Text('سيارة أجرة')),
        DropdownMenuItem(value: PropertyType.truck, child: Text('شاحنة')),
        DropdownMenuItem(value: PropertyType.heavyMachinery, child: Text('آلية ثقيلة')),
        DropdownMenuItem(value: PropertyType.agriculturalTractor, child: Text('جرار زراعي')),
        DropdownMenuItem(value: PropertyType.multiUnit, child: Text('متعدد الوحدات')),
      ],
      onChanged: (v) => setState(() => _propType = v!),
    ),
  );

  Widget _dropdownCurrency() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<Currency>(
      value: _currency,
      decoration: const InputDecoration(labelText: 'العملة', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: Currency.syp, child: Text('ليرة سورية (ل.س)')),
        DropdownMenuItem(value: Currency.usd, child: Text('دولار أمريكي')),
        DropdownMenuItem(value: Currency.eur, child: Text('يورو')),
        DropdownMenuItem(value: Currency.sar, child: Text('ريال سعودي')),
        DropdownMenuItem(value: Currency.gbp, child: Text('جنيه إسترليني')),
        DropdownMenuItem(value: Currency.aed, child: Text('درهم إماراتي')),
      ],
      onChanged: (v) => setState(() => _currency = v!),
    ),
  );

  Widget _dropdownPaymentMethod() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<PaymentMethod>(
      value: _paymentMethod,
      decoration: const InputDecoration(labelText: 'طريقة الدفع', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: PaymentMethod.cash, child: Text('نقداً')),
        DropdownMenuItem(value: PaymentMethod.bankTransfer, child: Text('حوالة مصرفية')),
        DropdownMenuItem(value: PaymentMethod.check, child: Text('شيك')),
        DropdownMenuItem(value: PaymentMethod.installments, child: Text('دفعات')),
      ],
      onChanged: (v) => setState(() => _paymentMethod = v!),
    ),
  );

  Widget _dropdownExpenseAlloc() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<ExpenseAllocation>(
      value: _expenseAlloc,
      decoration: const InputDecoration(labelText: 'النفقات على', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: ExpenseAllocation.buyer, child: Text('المشتري')),
        DropdownMenuItem(value: ExpenseAllocation.seller, child: Text('البائع')),
        DropdownMenuItem(value: ExpenseAllocation.halved, child: Text('مناصفة')),
        DropdownMenuItem(value: ExpenseAllocation.custom, child: Text('حسب الاتفاق')),
      ],
      onChanged: (v) => setState(() => _expenseAlloc = v!),
    ),
  );
}