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

  // ─── ✅ تعدد البائعين ──────────────────────────────────────────────────────
  final List<Person> _sellers = [];
  final List<TextEditingController> _sellerNameControllers = [];
  final List<TextEditingController> _sellerFatherControllers = [];
  final List<TextEditingController> _sellerMotherControllers = [];
  final List<TextEditingController> _sellerBirthYearControllers = [];
  final List<TextEditingController> _sellerResidencyControllers = [];
  final List<TextEditingController> _sellerFamilyIdControllers = [];
  final List<TextEditingController> _sellerNationalIdControllers = [];
  final List<TextEditingController> _sellerIdNumControllers = [];
  final List<TextEditingController> _sellerIdIssuedByControllers = [];
  final List<TextEditingController> _sellerIdIssuedDateControllers = [];
  final List<TextEditingController> _sellerPhoneControllers = [];
  final List<TextEditingController> _sellerAddressControllers = [];
  final List<TextEditingController> _sellerProfessionControllers = [];
  final List<TextEditingController> _sellerPoaNumControllers = [];
  final List<TextEditingController> _sellerPoaDateControllers = [];
  final List<bool> _sellerIsMinor = [];
  final List<bool> _sellerIsExpatriate = [];
  final List<bool> _sellerHasPoa = [];
  final List<bool> _sellerIsMissing = [];
  final List<bool> _sellerIsDeceased = [];
  final List<bool> _sellerHasGuardianPermission = [];
  final List<bool> _sellerHasJudicialRep = [];
  final List<bool> _sellerAgentBuysForSelf = [];
  final List<bool> _sellerAgentHasSelfBuyPermission = [];
  final List<MaritalStatus> _sellerMarital = [];

  // ─── ✅ تعدد المشترين ──────────────────────────────────────────────────────
  final List<Person> _buyers = [];
  final List<TextEditingController> _buyerNameControllers = [];
  final List<TextEditingController> _buyerFatherControllers = [];
  final List<TextEditingController> _buyerMotherControllers = [];
  final List<TextEditingController> _buyerNationalIdControllers = [];
  final List<TextEditingController> _buyerIdNumControllers = [];
  final List<TextEditingController> _buyerPhoneControllers = [];
  final List<TextEditingController> _buyerAddressControllers = [];
  final List<TextEditingController> _buyerProfessionControllers = [];
  final List<bool> _buyerIsMinor = [];
  final List<NationalityType> _buyerNationality = [];

  // ─── بيانات العقد ──────────────────────────────────────────────────────────
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _govCtrl = TextEditingController();
  final _refNumCtrl = TextEditingController();

  // ─── بيانات العقار ────────────────────────────────────────────────────────
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

  // ─── بيانات الثمن ──────────────────────────────────────────────────────────
  final _totalPriceCtrl = TextEditingController();
  final _paidCtrl = TextEditingController();
  final _balanceDateCtrl = TextEditingController();
  final _penaltyCtrl = TextEditingController();

  // ─── حالات العقار ──────────────────────────────────────────────────────────
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

  // ─── تهيئة ──────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _addSeller(); // بائع افتراضي
    _addBuyer(); // مشتري افتراضي
  }

  @override
  void dispose() {
    for (final c in [
      ..._sellerNameControllers,
      ..._sellerFatherControllers,
      ..._sellerMotherControllers,
      ..._sellerBirthYearControllers,
      ..._sellerResidencyControllers,
      ..._sellerFamilyIdControllers,
      ..._sellerNationalIdControllers,
      ..._sellerIdNumControllers,
      ..._sellerIdIssuedByControllers,
      ..._sellerIdIssuedDateControllers,
      ..._sellerPhoneControllers,
      ..._sellerAddressControllers,
      ..._sellerProfessionControllers,
      ..._sellerPoaNumControllers,
      ..._sellerPoaDateControllers,
      ..._buyerNameControllers,
      ..._buyerFatherControllers,
      ..._buyerMotherControllers,
      ..._buyerNationalIdControllers,
      ..._buyerIdNumControllers,
      ..._buyerPhoneControllers,
      ..._buyerAddressControllers,
      ..._buyerProfessionControllers,
      _dateCtrl, _cityCtrl, _govCtrl, _refNumCtrl,
      _registryCtrl, _zoneCtrl, _planCtrl, _plotCtrl,
      _ownershipDocCtrl, _ownershipDateCtrl, _ownershipSourceCtrl,
      _areaCtrl, _boundariesCtrl, _northCtrl, _southCtrl, _eastCtrl, _westCtrl,
      _totalPriceCtrl, _paidCtrl, _balanceDateCtrl, _penaltyCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── إدارة البائعين ──────────────────────────────────────────────────────
  void _addSeller() {
    setState(() {
      _sellers.add(const Person(id: 'seller_${_sellers.length + 1}'));
      _sellerNameControllers.add(TextEditingController());
      _sellerFatherControllers.add(TextEditingController());
      _sellerMotherControllers.add(TextEditingController());
      _sellerBirthYearControllers.add(TextEditingController());
      _sellerResidencyControllers.add(TextEditingController());
      _sellerFamilyIdControllers.add(TextEditingController());
      _sellerNationalIdControllers.add(TextEditingController());
      _sellerIdNumControllers.add(TextEditingController());
      _sellerIdIssuedByControllers.add(TextEditingController());
      _sellerIdIssuedDateControllers.add(TextEditingController());
      _sellerPhoneControllers.add(TextEditingController());
      _sellerAddressControllers.add(TextEditingController());
      _sellerProfessionControllers.add(TextEditingController());
      _sellerPoaNumControllers.add(TextEditingController());
      _sellerPoaDateControllers.add(TextEditingController());
      _sellerIsMinor.add(false);
      _sellerIsExpatriate.add(false);
      _sellerHasPoa.add(false);
      _sellerIsMissing.add(false);
      _sellerIsDeceased.add(false);
      _sellerHasGuardianPermission.add(false);
      _sellerHasJudicialRep.add(false);
      _sellerAgentBuysForSelf.add(false);
      _sellerAgentHasSelfBuyPermission.add(false);
      _sellerMarital.add(MaritalStatus.single);
    });
  }

  void _removeSeller(int index) {
    if (_sellers.length <= 1) return;
    setState(() {
      _sellers.removeAt(index);
      _sellerNameControllers[index].dispose();
      _sellerNameControllers.removeAt(index);
      _sellerFatherControllers[index].dispose();
      _sellerFatherControllers.removeAt(index);
      _sellerMotherControllers[index].dispose();
      _sellerMotherControllers.removeAt(index);
      _sellerBirthYearControllers[index].dispose();
      _sellerBirthYearControllers.removeAt(index);
      _sellerResidencyControllers[index].dispose();
      _sellerResidencyControllers.removeAt(index);
      _sellerFamilyIdControllers[index].dispose();
      _sellerFamilyIdControllers.removeAt(index);
      _sellerNationalIdControllers[index].dispose();
      _sellerNationalIdControllers.removeAt(index);
      _sellerIdNumControllers[index].dispose();
      _sellerIdNumControllers.removeAt(index);
      _sellerIdIssuedByControllers[index].dispose();
      _sellerIdIssuedByControllers.removeAt(index);
      _sellerIdIssuedDateControllers[index].dispose();
      _sellerIdIssuedDateControllers.removeAt(index);
      _sellerPhoneControllers[index].dispose();
      _sellerPhoneControllers.removeAt(index);
      _sellerAddressControllers[index].dispose();
      _sellerAddressControllers.removeAt(index);
      _sellerProfessionControllers[index].dispose();
      _sellerProfessionControllers.removeAt(index);
      _sellerPoaNumControllers[index].dispose();
      _sellerPoaNumControllers.removeAt(index);
      _sellerPoaDateControllers[index].dispose();
      _sellerPoaDateControllers.removeAt(index);
      _sellerIsMinor.removeAt(index);
      _sellerIsExpatriate.removeAt(index);
      _sellerHasPoa.removeAt(index);
      _sellerIsMissing.removeAt(index);
      _sellerIsDeceased.removeAt(index);
      _sellerHasGuardianPermission.removeAt(index);
      _sellerHasJudicialRep.removeAt(index);
      _sellerAgentBuysForSelf.removeAt(index);
      _sellerAgentHasSelfBuyPermission.removeAt(index);
      _sellerMarital.removeAt(index);
    });
  }

  // ─── إدارة المشترين ──────────────────────────────────────────────────────
  void _addBuyer() {
    setState(() {
      _buyers.add(const Person(id: 'buyer_${_buyers.length + 1}'));
      _buyerNameControllers.add(TextEditingController());
      _buyerFatherControllers.add(TextEditingController());
      _buyerMotherControllers.add(TextEditingController());
      _buyerNationalIdControllers.add(TextEditingController());
      _buyerIdNumControllers.add(TextEditingController());
      _buyerPhoneControllers.add(TextEditingController());
      _buyerAddressControllers.add(TextEditingController());
      _buyerProfessionControllers.add(TextEditingController());
      _buyerIsMinor.add(false);
      _buyerNationality.add(NationalityType.syrian);
    });
  }

  void _removeBuyer(int index) {
    if (_buyers.length <= 1) return;
    setState(() {
      _buyers.removeAt(index);
      _buyerNameControllers[index].dispose();
      _buyerNameControllers.removeAt(index);
      _buyerFatherControllers[index].dispose();
      _buyerFatherControllers.removeAt(index);
      _buyerMotherControllers[index].dispose();
      _buyerMotherControllers.removeAt(index);
      _buyerNationalIdControllers[index].dispose();
      _buyerNationalIdControllers.removeAt(index);
      _buyerIdNumControllers[index].dispose();
      _buyerIdNumControllers.removeAt(index);
      _buyerPhoneControllers[index].dispose();
      _buyerPhoneControllers.removeAt(index);
      _buyerAddressControllers[index].dispose();
      _buyerAddressControllers.removeAt(index);
      _buyerProfessionControllers[index].dispose();
      _buyerProfessionControllers.removeAt(index);
      _buyerIsMinor.removeAt(index);
      _buyerNationality.removeAt(index);
    });
  }

  // ─── جمع البيانات وإرسالها ──────────────────────────────────────────────
  void _collectAndSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<ContractProvider>();

    // بيانات العقد
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateGovernorate(_govCtrl.text);
    provider.setReferenceNumber(_refNumCtrl.text);

    // ✅ جميع البائعين
    final sellers = <Person>[];
    for (int i = 0; i < _sellers.length; i++) {
      sellers.add(Person(
        id: 'seller_$i',
        fullName: _sellerNameControllers[i].text,
        fatherName: _sellerFatherControllers[i].text,
        motherName: _sellerMotherControllers[i].text,
        birthYear: _sellerBirthYearControllers[i].text,
        residency: _sellerResidencyControllers[i].text,
        familyId: _sellerFamilyIdControllers[i].text,
        nationalId: _sellerNationalIdControllers[i].text,
        idNumber: _sellerIdNumControllers[i].text,
        idIssuedBy: _sellerIdIssuedByControllers[i].text,
        idIssuedDate: _sellerIdIssuedDateControllers[i].text,
        phone: _sellerPhoneControllers[i].text,
        address: _sellerAddressControllers[i].text,
        profession: _sellerProfessionControllers[i].text,
        role: PersonRole.seller,
        isMinor: _sellerIsMinor[i],
        isExpatriate: _sellerIsExpatriate[i],
        hasPowerOfAttorney: _sellerHasPoa[i],
        poaNumber: _sellerPoaNumControllers[i].text,
        poaDate: _sellerPoaDateControllers[i].text,
        isMissing: _sellerIsMissing[i],
        isDeceased: _sellerIsDeceased[i],
        hasGuardianPermission: _sellerHasGuardianPermission[i],
        hasJudicialRepresentative: _sellerHasJudicialRep[i],
        agentBuysForSelf: _sellerAgentBuysForSelf[i],
        agentHasSelfBuyPermission: _sellerAgentHasSelfBuyPermission[i],
        maritalStatus: _sellerMarital[i],
      ));
    }
    provider.updateSellers(sellers);

    // ✅ جميع المشترين
    final buyers = <Person>[];
    for (int i = 0; i < _buyers.length; i++) {
      buyers.add(Person(
        id: 'buyer_$i',
        fullName: _buyerNameControllers[i].text,
        fatherName: _buyerFatherControllers[i].text,
        motherName: _buyerMotherControllers[i].text,
        nationalId: _buyerNationalIdControllers[i].text,
        idNumber: _buyerIdNumControllers[i].text,
        phone: _buyerPhoneControllers[i].text,
        address: _buyerAddressControllers[i].text,
        profession: _buyerProfessionControllers[i].text,
        role: PersonRole.buyer,
        isMinor: _buyerIsMinor[i],
        nationality: _buyerNationality[i],
      ));
    }
    provider.updateBuyers(buyers);

    // العقار والثمن
    final total = double.tryParse(_totalPriceCtrl.text) ?? 0;
    final paid = double.tryParse(_paidCtrl.text) ?? 0;

    provider.updateProperty(Property(
      registryNumber: _registryCtrl.text,
      zone: _zoneCtrl.text,
      planNumber: _planCtrl.text,
      plotNumber: _plotCtrl.text,
      ownershipDocNumber: _ownershipDocCtrl.text,
      ownershipDocDate: _ownershipDateCtrl.text,
      ownershipDocSource: _ownershipSourceCtrl.text,
      area: double.tryParse(_areaCtrl.text) ?? 0,
      boundaries: _boundariesCtrl.text,
      northBoundary: _northCtrl.text,
      southBoundary: _southCtrl.text,
      eastBoundary: _eastCtrl.text,
      westBoundary: _westCtrl.text,
      type: _propType,
      hasSeizure: _propHasSeizure,
      hasMortgage: _propHasMortgage,
      hasReleaseLetter: _propHasReleaseLetter,
      isEndowment: _propIsEndowment,
      isViolation: _propIsViolation,
      isCommonShare: _propIsCommonShare,
      hasActiveLawsuit: _propHasActiveLawsuit,
      isAmiriaLand: _propIsAmiriaLand,
      isMinorsDowry: _propIsMinorsDowry,
      underExpropriation: _propUnderExpropriation,
      subjectToInvestmentLaw: _propSubjectToInvestmentLaw,
      hasShamIndicators: _propHasShamIndicators,
    ));

    provider.updatePayment(Payment(
      totalPrice: total,
      paidAmount: paid,
      balance: total - paid,
      balanceDueDate: _balanceDateCtrl.text,
      method: _paymentMethod,
      expenseAllocation: _expenseAlloc,
      penaltyAmount: double.tryParse(_penaltyCtrl.text) ?? 0,
      currency: _currency,
    ));

    // تحليل وحفظ
    provider.analyze().then((_) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WarningSystemScreen()),
        );
      }
    });
  }

  // ─── بناء الواجهة ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد بيع مباشر')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── بيانات العقد ──────────────────────────────────────────────
            SectionCard(
              title: 'بيانات العقد',
              icon: Icons.assignment,
              children: [
                ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد (يوم/شهر/سنة)'),
                ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
                _dropdownGovernorate(),
                ArabicTextField(controller: _refNumCtrl, label: 'الرقم المرجعي (اختياري)'),
              ],
            ),

            // ─── ✅ البائعون (متعددون) ──────────────────────────────────────
            SectionCard(
              title: 'بيانات البائعين (${_sellers.length})',
              icon: Icons.people,
              children: [
                ...List.generate(_sellers.length, (i) => _buildSellerCard(i)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة بائع'),
                        onPressed: _addSeller,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.remove),
                        label: const Text('حذف آخر'),
                        onPressed: () => _removeSeller(_sellers.length - 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ─── ✅ المشترون (متعددون) ──────────────────────────────────────
            SectionCard(
              title: 'بيانات المشترين (${_buyers.length})',
              icon: Icons.person_outline,
              children: [
                ...List.generate(_buyers.length, (i) => _buildBuyerCard(i)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة مشتري'),
                        onPressed: _addBuyer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.remove),
                        label: const Text('حذف آخر'),
                        onPressed: () => _removeBuyer(_buyers.length - 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ─── العقار ──────────────────────────────────────────────────────
            _buildPropertySection(),

            // ─── الثمن ───────────────────────────────────────────────────────
            _buildPriceSection(),

            const SizedBox(height: 24),
            PrimaryActionButton(
              icon: Icons.search,
              label: 'فحص العقد',
              onPressed: _collectAndSubmit,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_note),
                    label: const Text('البنود'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClauseManagerScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.people),
                    label: const Text('الشهود'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WitnessManagerScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.note_add),
                    label: const Text('الملاحق'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnnexManagerScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── بطاقة بائع ──────────────────────────────────────────────────────────
  Widget _buildSellerCard(int index) {
    return Card(
      color: Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('بائع ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeSeller(index),
                ),
              ],
            ),
            const Divider(),
            ArabicTextField(controller: _sellerNameControllers[index], label: 'الاسم الكامل', required: true),
            ArabicTextField(controller: _sellerFatherControllers[index], label: 'اسم الأب'),
            ArabicTextField(controller: _sellerMotherControllers[index], label: 'اسم الأم'),
            ArabicTextField(controller: _sellerBirthYearControllers[index], label: 'سنة الميلاد', type: TextInputType.number),
            ArabicTextField(controller: _sellerResidencyControllers[index], label: 'المسكن'),
            ArabicTextField(controller: _sellerFamilyIdControllers[index], label: 'خانة/الأسرة'),
            ArabicTextField(controller: _sellerNationalIdControllers[index], label: 'الرقم الوطني'),
            ArabicTextField(controller: _sellerIdNumControllers[index], label: 'رقم البطاقة الشخصية'),
            ArabicTextField(controller: _sellerIdIssuedByControllers[index], label: 'جهة إصدار البطاقة'),
            ArabicTextField(controller: _sellerIdIssuedDateControllers[index], label: 'تاريخ إصدار البطاقة'),
            ArabicTextField(controller: _sellerPhoneControllers[index], label: 'رقم الهاتف', type: TextInputType.phone),
            ArabicTextField(controller: _sellerAddressControllers[index], label: 'العنوان'),
            ArabicTextField(controller: _sellerProfessionControllers[index], label: 'المهنة'),
            _dropdownMaritalStatus(index),
            ArabicSwitch(label: 'قاصر', value: _sellerIsMinor[index], onChanged: (v) => setState(() => _sellerIsMinor[index] = v)),
            if (_sellerIsMinor[index])
              ArabicSwitch(label: 'يوجد إذن من القاضي/الولي', value: _sellerHasGuardianPermission[index], onChanged: (v) => setState(() => _sellerHasGuardianPermission[index] = v)),
            ArabicSwitch(label: 'مغترب', value: _sellerIsExpatriate[index], onChanged: (v) => setState(() => _sellerIsExpatriate[index] = v)),
            ArabicSwitch(label: 'يحمل وكالة', value: _sellerHasPoa[index], onChanged: (v) => setState(() => _sellerHasPoa[index] = v)),
            if (_sellerHasPoa[index]) ...[
              ArabicTextField(controller: _sellerPoaNumControllers[index], label: 'رقم الوكالة'),
              ArabicTextField(controller: _sellerPoaDateControllers[index], label: 'تاريخ الوكالة'),
            ],
            ArabicSwitch(label: 'مفقود', value: _sellerIsMissing[index], onChanged: (v) => setState(() => _sellerIsMissing[index] = v)),
            if (_sellerIsMissing[index])
              ArabicSwitch(label: 'يوجد وكيل قضائي', value: _sellerHasJudicialRep[index], onChanged: (v) => setState(() => _sellerHasJudicialRep[index] = v)),
            ArabicSwitch(label: 'متوفى', value: _sellerIsDeceased[index], onChanged: (v) => setState(() => _sellerIsDeceased[index] = v)),
            ArabicSwitch(label: 'الوكيل يشتري لنفسه', value: _sellerAgentBuysForSelf[index], onChanged: (v) => setState(() => _sellerAgentBuysForSelf[index] = v)),
            if (_sellerAgentBuysForSelf[index])
              ArabicSwitch(label: 'يوجد إذن صريح للموكل', value: _sellerAgentHasSelfBuyPermission[index], onChanged: (v) => setState(() => _sellerAgentHasSelfBuyPermission[index] = v)),
          ],
        ),
      ),
    );
  }

  // ─── بطاقة مشتري ──────────────────────────────────────────────────────────
  Widget _buildBuyerCard(int index) {
    return Card(
      color: Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('مشتري ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeBuyer(index),
                ),
              ],
            ),
            const Divider(),
            ArabicTextField(controller: _buyerNameControllers[index], label: 'الاسم الكامل', required: true),
            ArabicTextField(controller: _buyerFatherControllers[index], label: 'اسم الأب'),
            ArabicTextField(controller: _buyerMotherControllers[index], label: 'اسم الأم'),
            ArabicTextField(controller: _buyerNationalIdControllers[index], label: 'الرقم الوطني'),
            ArabicTextField(controller: _buyerIdNumControllers[index], label: 'رقم البطاقة'),
            ArabicTextField(controller: _buyerPhoneControllers[index], label: 'رقم الهاتف', type: TextInputType.phone),
            ArabicTextField(controller: _buyerAddressControllers[index], label: 'العنوان'),
            ArabicTextField(controller: _buyerProfessionControllers[index], label: 'المهنة'),
            _dropdownBuyerNationality(index),
            ArabicSwitch(label: 'قاصر', value: _buyerIsMinor[index], onChanged: (v) => setState(() => _buyerIsMinor[index] = v)),
          ],
        ),
      ),
    );
  }

  // ─── دوال مساعدة ──────────────────────────────────────────────────────────

  Widget _dropdownGovernorate() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<String>(
      value: _govCtrl.text.isEmpty ? null : _govCtrl.text,
      decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder(), isDense: true),
      items: SyrianGovernorates.all.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
      onChanged: (v) { if (v != null) setState(() => _govCtrl.text = v); },
    ),
  );

  Widget _dropdownMaritalStatus(int index) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<MaritalStatus>(
      value: _sellerMarital[index],
      decoration: const InputDecoration(labelText: 'الحالة العائلية', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: MaritalStatus.single, child: Text('أعزب')),
        DropdownMenuItem(value: MaritalStatus.married, child: Text('متزوج')),
        DropdownMenuItem(value: MaritalStatus.divorced, child: Text('مطلق')),
        DropdownMenuItem(value: MaritalStatus.widowed, child: Text('أرمل')),
      ],
      onChanged: (v) => setState(() => _sellerMarital[index] = v!),
    ),
  );

  Widget _dropdownBuyerNationality(int index) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: DropdownButtonFormField<NationalityType>(
      value: _buyerNationality[index],
      decoration: const InputDecoration(labelText: 'جنسية المشتري', border: OutlineInputBorder(), isDense: true),
      items: const [
        DropdownMenuItem(value: NationalityType.syrian, child: Text('سوري')),
        DropdownMenuItem(value: NationalityType.foreignLicensed, child: Text('أجنبي بترخيص')),
        DropdownMenuItem(value: NationalityType.dualNational, child: Text('مزدوج الجنسية')),
        DropdownMenuItem(value: NationalityType.legalEntity, child: Text('شخص اعتباري')),
      ],
      onChanged: (v) => setState(() => _buyerNationality[index] = v!),
    ),
  );

  Widget _buildPropertySection() => SectionCard(
    title: 'بيانات العقار',
    icon: Icons.home,
    children: [
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
    ],
  );

  Widget _fourBoundaries() => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
      ],
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

  Widget _buildPriceSection() => SectionCard(
    title: 'بيانات الثمن',
    icon: Icons.attach_money,
    children: [
      ArabicTextField(controller: _totalPriceCtrl, label: 'الثمن الإجمالي', required: true, type: TextInputType.number),
      ArabicTextField(controller: _paidCtrl, label: 'المبلغ المدفوع', type: TextInputType.number),
      ArabicTextField(controller: _balanceDateCtrl, label: 'تاريخ استحقاق الرصيد'),
      ArabicTextField(controller: _penaltyCtrl, label: 'الشرط الجزائي', type: TextInputType.number),
      _dropdownCurrency(),
      _dropdownPaymentMethod(),
      _dropdownExpenseAlloc(),
    ],
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
