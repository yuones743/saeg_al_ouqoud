import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import '../../domain/models/legal_contract.dart' as legal;
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../../core/engine/contract_generator.dart';
import '../../application/services/pdf_service.dart';
import '../state/contract_provider.dart';
import 'pdf_preview_screen.dart';

class _WizardConstants {
  static const Color primaryColor = Color(0xFF1B4F72);
  static const int totalShares = 2400;
  static const int totalSteps = 6;
}

class SmartContractWizard extends StatefulWidget {
  const SmartContractWizard({super.key});

  @override
  State<SmartContractWizard> createState() => _SmartContractWizardState();
}

class _SmartContractWizardState extends State<SmartContractWizard> {
  int _step = 0;
  final PageController _pageController = PageController();

  legal.ContractType _type = legal.ContractType.sale;
  List<legal.LegalParty> _sellers = [];
  List<legal.LegalParty> _buyers = [];

  String _propertyNumber = '';
  String _propertyZone = '';
  String _propertyAddress = '';
  String _city = '';
  String _governorate = '';
  double _propertyArea = 0;
  String _boundaries = '';
  double _totalPrice = 0;
  String _paymentMethod = 'نقداً';
  double _penaltyAmount = 0;
  List<String> _customClauses = [];

  String? _cachedContractText;

  final _sellersFormKey = GlobalKey<FormState>();
  final _buyersFormKey = GlobalKey<FormState>();
  final _propertyFormKey = GlobalKey<FormState>();

  final TextEditingController _propertyNumberCtrl = TextEditingController();
  final TextEditingController _propertyZoneCtrl = TextEditingController();
  final TextEditingController _propertyAddressCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _governorateCtrl = TextEditingController();
  final TextEditingController _propertyAreaCtrl = TextEditingController();
  final TextEditingController _boundariesCtrl = TextEditingController();
  final TextEditingController _totalPriceCtrl = TextEditingController();
  final TextEditingController _penaltyAmountCtrl = TextEditingController();

  // ─── Controllers للبائعين ──────────────────────────────────────────────────
  final List<TextEditingController> _sellerNameControllers = [];
  final List<TextEditingController> _sellerIdControllers = [];
  final List<TextEditingController> _sellerFatherControllers = [];
  final List<TextEditingController> _sellerMotherControllers = [];
  final List<TextEditingController> _sellerPhoneControllers = [];
  final List<TextEditingController> _sellerAddressControllers = [];
  final List<TextEditingController> _sellerShareControllers = [];

  final List<legal.LegalCapacity> _sellerCapacities = [];
  final List<TextEditingController> _sellerPoaNumberControllers = [];
  final List<TextEditingController> _sellerPoaDateControllers = [];
  final List<bool> _sellerIsMinor = [];
  final List<bool> _sellerIsExpatriate = [];

  // ─── Controllers للمشترين ─────────────────────────────────────────────────
  final List<TextEditingController> _buyerNameControllers = [];
  final List<TextEditingController> _buyerIdControllers = [];
  final List<TextEditingController> _buyerFatherControllers = [];
  final List<TextEditingController> _buyerMotherControllers = [];
  final List<TextEditingController> _buyerPhoneControllers = [];
  final List<TextEditingController> _buyerAddressControllers = [];
  final List<TextEditingController> _buyerShareControllers = [];

  final List<legal.LegalCapacity> _buyerCapacities = [];
  final List<TextEditingController> _buyerPoaNumberControllers = [];
  final List<TextEditingController> _buyerPoaDateControllers = [];
  final List<bool> _buyerIsMinor = [];
  final List<bool> _buyerIsExpatriate = [];

  int _sellerIdCounter = 0;
  int _buyerIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeSellers(1);
    _initializeBuyers(1);
  }

  @override
  void dispose() {
    _disposeControllerList(_sellerNameControllers);
    _disposeControllerList(_sellerIdControllers);
    _disposeControllerList(_sellerFatherControllers);
    _disposeControllerList(_sellerMotherControllers);
    _disposeControllerList(_sellerPhoneControllers);
    _disposeControllerList(_sellerAddressControllers);
    _disposeControllerList(_sellerShareControllers);
    _disposeControllerList(_sellerPoaNumberControllers);
    _disposeControllerList(_sellerPoaDateControllers);

    _disposeControllerList(_buyerNameControllers);
    _disposeControllerList(_buyerIdControllers);
    _disposeControllerList(_buyerFatherControllers);
    _disposeControllerList(_buyerMotherControllers);
    _disposeControllerList(_buyerPhoneControllers);
    _disposeControllerList(_buyerAddressControllers);
    _disposeControllerList(_buyerShareControllers);
    _disposeControllerList(_buyerPoaNumberControllers);
    _disposeControllerList(_buyerPoaDateControllers);

    _propertyNumberCtrl.dispose();
    _propertyZoneCtrl.dispose();
    _propertyAddressCtrl.dispose();
    _cityCtrl.dispose();
    _governorateCtrl.dispose();
    _propertyAreaCtrl.dispose();
    _boundariesCtrl.dispose();
    _totalPriceCtrl.dispose();
    _penaltyAmountCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _disposeControllerList(List<TextEditingController> list) {
    for (final c in list) c.dispose();
    list.clear();
  }

  void _initializeSellers(int count) {
    _disposeControllerList(_sellerNameControllers);
    _disposeControllerList(_sellerIdControllers);
    _disposeControllerList(_sellerFatherControllers);
    _disposeControllerList(_sellerMotherControllers);
    _disposeControllerList(_sellerPhoneControllers);
    _disposeControllerList(_sellerAddressControllers);
    _disposeControllerList(_sellerShareControllers);
    _disposeControllerList(_sellerPoaNumberControllers);
    _disposeControllerList(_sellerPoaDateControllers);
    _sellerCapacities.clear();
    _sellerIsMinor.clear();
    _sellerIsExpatriate.clear();
    _sellers = [];
    _sellerIdCounter = 0;

    for (int i = 0; i < count; i++) {
      _appendSeller();
    }
    _recalcShares(_sellers, _sellerShareControllers);
  }

  void _initializeBuyers(int count) {
    _disposeControllerList(_buyerNameControllers);
    _disposeControllerList(_buyerIdControllers);
    _disposeControllerList(_buyerFatherControllers);
    _disposeControllerList(_buyerMotherControllers);
    _disposeControllerList(_buyerPhoneControllers);
    _disposeControllerList(_buyerAddressControllers);
    _disposeControllerList(_buyerShareControllers);
    _disposeControllerList(_buyerPoaNumberControllers);
    _disposeControllerList(_buyerPoaDateControllers);
    _buyerCapacities.clear();
    _buyerIsMinor.clear();
    _buyerIsExpatriate.clear();
    _buyers = [];
    _buyerIdCounter = 0;

    for (int i = 0; i < count; i++) {
      _appendBuyer();
    }
    _recalcShares(_buyers, _buyerShareControllers);
  }

  void _appendSeller() {
    _sellerIdCounter++;
    _sellers.add(legal.LegalParty(
      id: 'seller_$_sellerIdCounter',
      fullName: '',
      nationalId: '',
      role: legal.PartyRole.seller,
      capacity: legal.LegalCapacity.individual,
      poaNumber: '',
      poaDate: '',
      isMinor: false,
      isExpatriate: false,
    ));
    _sellerNameControllers.add(TextEditingController());
    _sellerIdControllers.add(TextEditingController());
    _sellerFatherControllers.add(TextEditingController());
    _sellerMotherControllers.add(TextEditingController());
    _sellerPhoneControllers.add(TextEditingController());
    _sellerAddressControllers.add(TextEditingController());
    _sellerShareControllers.add(TextEditingController());
    _sellerCapacities.add(legal.LegalCapacity.individual);
    _sellerPoaNumberControllers.add(TextEditingController());
    _sellerPoaDateControllers.add(TextEditingController());
    _sellerIsMinor.add(false);
    _sellerIsExpatriate.add(false);
  }

  void _appendBuyer() {
    _buyerIdCounter++;
    _buyers.add(legal.LegalParty(
      id: 'buyer_$_buyerIdCounter',
      fullName: '',
      nationalId: '',
      role: legal.PartyRole.buyer,
      capacity: legal.LegalCapacity.individual,
      poaNumber: '',
      poaDate: '',
      isMinor: false,
      isExpatriate: false,
    ));
    _buyerNameControllers.add(TextEditingController());
    _buyerIdControllers.add(TextEditingController());
    _buyerFatherControllers.add(TextEditingController());
    _buyerMotherControllers.add(TextEditingController());
    _buyerPhoneControllers.add(TextEditingController());
    _buyerAddressControllers.add(TextEditingController());
    _buyerShareControllers.add(TextEditingController());
    _buyerCapacities.add(legal.LegalCapacity.individual);
    _buyerPoaNumberControllers.add(TextEditingController());
    _buyerPoaDateControllers.add(TextEditingController());
    _buyerIsMinor.add(false);
    _buyerIsExpatriate.add(false);
  }

  void _addSeller() {
    setState(() {
      _appendSeller();
      _recalcShares(_sellers, _sellerShareControllers);
    });
  }

  void _addBuyer() {
    setState(() {
      _appendBuyer();
      _recalcShares(_buyers, _buyerShareControllers);
    });
  }

  void _removeSeller(int index) {
    if (_sellers.length <= 1) return;
    setState(() {
      _removeAtIndex(_sellerNameControllers, index);
      _removeAtIndex(_sellerIdControllers, index);
      _removeAtIndex(_sellerFatherControllers, index);
      _removeAtIndex(_sellerMotherControllers, index);
      _removeAtIndex(_sellerPhoneControllers, index);
      _removeAtIndex(_sellerAddressControllers, index);
      _removeAtIndex(_sellerShareControllers, index);
      _removeAtIndex(_sellerPoaNumberControllers, index);
      _removeAtIndex(_sellerPoaDateControllers, index);
      _sellers.removeAt(index);
      _sellerCapacities.removeAt(index);
      _sellerIsMinor.removeAt(index);
      _sellerIsExpatriate.removeAt(index);
      _recalcShares(_sellers, _sellerShareControllers);
    });
  }

  void _removeBuyer(int index) {
    if (_buyers.length <= 1) return;
    setState(() {
      _removeAtIndex(_buyerNameControllers, index);
      _removeAtIndex(_buyerIdControllers, index);
      _removeAtIndex(_buyerFatherControllers, index);
      _removeAtIndex(_buyerMotherControllers, index);
      _removeAtIndex(_buyerPhoneControllers, index);
      _removeAtIndex(_buyerAddressControllers, index);
      _removeAtIndex(_buyerShareControllers, index);
      _removeAtIndex(_buyerPoaNumberControllers, index);
      _removeAtIndex(_buyerPoaDateControllers, index);
      _buyers.removeAt(index);
      _buyerCapacities.removeAt(index);
      _buyerIsMinor.removeAt(index);
      _buyerIsExpatriate.removeAt(index);
      _recalcShares(_buyers, _buyerShareControllers);
    });
  }

  void _removeAtIndex(List<TextEditingController> list, int index) {
    list[index].dispose();
    list.removeAt(index);
  }

  void _recalcShares(
      List<legal.LegalParty> parties, List<TextEditingController> shareControllers) {
    if (parties.isEmpty) return;
    final n = parties.length;
    final base = _WizardConstants.totalShares ~/ n;
    final remainder = _WizardConstants.totalShares % n;
    for (int i = 0; i < n; i++) {
      final share = (i == n - 1) ? base + remainder : base;
      parties[i] = parties[i].copyWith(share: share.toDouble());
      shareControllers[i].text = share.toString();
    }
  }

  void _syncSellers() {
    for (int i = 0; i < _sellers.length; i++) {
      _sellers[i] = _sellers[i].copyWith(
        fullName: _sellerNameControllers[i].text.trim(),
        nationalId: _sellerIdControllers[i].text.trim(),
        fatherName: _sellerFatherControllers[i].text.trim(),
        motherName: _sellerMotherControllers[i].text.trim(),
        phone: _sellerPhoneControllers[i].text.trim(),
        address: _sellerAddressControllers[i].text.trim(),
        share: double.tryParse(_sellerShareControllers[i].text) ?? 0,
        capacity: _sellerCapacities[i],
        poaNumber: _sellerPoaNumberControllers[i].text.trim(),
        poaDate: _sellerPoaDateControllers[i].text.trim(),
        isMinor: _sellerIsMinor[i],
        isExpatriate: _sellerIsExpatriate[i],
      );
    }
  }

  void _syncBuyers() {
    for (int i = 0; i < _buyers.length; i++) {
      _buyers[i] = _buyers[i].copyWith(
        fullName: _buyerNameControllers[i].text.trim(),
        nationalId: _buyerIdControllers[i].text.trim(),
        fatherName: _buyerFatherControllers[i].text.trim(),
        motherName: _buyerMotherControllers[i].text.trim(),
        phone: _buyerPhoneControllers[i].text.trim(),
        address: _buyerAddressControllers[i].text.trim(),
        share: double.tryParse(_buyerShareControllers[i].text) ?? 0,
        capacity: _buyerCapacities[i],
        poaNumber: _buyerPoaNumberControllers[i].text.trim(),
        poaDate: _buyerPoaDateControllers[i].text.trim(),
        isMinor: _buyerIsMinor[i],
        isExpatriate: _buyerIsExpatriate[i],
      );
    }
  }

  void _syncProperty() {
    _propertyNumber = _propertyNumberCtrl.text.trim();
    _propertyZone = _propertyZoneCtrl.text.trim();
    _propertyAddress = _propertyAddressCtrl.text.trim();
    _city = _cityCtrl.text.trim();
    _governorate = _governorateCtrl.text.trim();
    _propertyArea = double.tryParse(_propertyAreaCtrl.text) ?? 0;
    _boundaries = _boundariesCtrl.text.trim();
    _totalPrice = double.tryParse(_totalPriceCtrl.text) ?? 0;
    _penaltyAmount = double.tryParse(_penaltyAmountCtrl.text) ?? 0;
  }

  void _refreshContractText() {
    _syncSellers();
    _syncBuyers();
    _syncProperty();
    _cachedContractText = ContractGenerator.generate(_buildContractData());
  }

  void _goToStep(int targetStep) {
    if (!_validateCurrentStep()) return;
    if (_step == 2) _syncSellers();
    if (_step == 3) _syncBuyers();
    if (_step == 4) _syncProperty();
    if (targetStep == 5) _refreshContractText();
    setState(() => _step = targetStep);
    _pageController.animateToPage(
        targetStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
  }

  bool _validateCurrentStep() {
    switch (_step) {
      case 2:
        return _sellersFormKey.currentState?.validate() ?? true;
      case 3:
        return _buyersFormKey.currentState?.validate() ?? true;
      case 4:
        return _propertyFormKey.currentState?.validate() ?? true;
      default:
        return true;
    }
  }

  void _goToNextStep() {
    if (_step < _WizardConstants.totalSteps - 1) _goToStep(_step + 1);
  }

  void _goToPreviousStep() {
    if (_step > 0) {
      if (_step == 2) _syncSellers();
      if (_step == 3) _syncBuyers();
      if (_step == 4) _syncProperty();
      setState(() => _step--);
      _pageController.animateToPage(
          _step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  legal.LegalContractData _buildContractData() {
    return legal.LegalContractData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _type,
      sellers: _sellers,
      buyers: _buyers,
      propertyNumber: _propertyNumber,
      propertyZone: _propertyZone,
      propertyAddress: _propertyAddress,
      propertyArea: _propertyArea,
      boundaries: _boundaries,
      totalPrice: _totalPrice,
      paymentMethod: _paymentMethod,
      penaltyAmount: _penaltyAmount,
      customClauses: _customClauses,
    );
  }

  Person _legalPartyToPerson(legal.LegalParty p, PersonRole role) {
    return Person(
      id: p.id,
      fullName: p.fullName,
      fatherName: p.fatherName,
      motherName: p.motherName,
      nationalId: p.nationalId,
      phone: p.phone,
      address: p.address,
      role: role,
      isMinor: p.isMinor,
      isExpatriate: p.isExpatriate,
      hasPowerOfAttorney: p.poaNumber != null && p.poaNumber!.isNotEmpty,
      poaNumber: p.poaNumber ?? '',
      poaDate: p.poaDate ?? '',
    );
  }

  Contract _convertToContract(legal.LegalContractData data) {
    return Contract(
      id: data.id,
      type: _mapContractType(data.type),
      contractDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      city: _city,
      governorate: _governorate,
      sellers: data.sellers.map((p) => _legalPartyToPerson(p, PersonRole.seller)).toList(),
      buyers: data.buyers.map((p) => _legalPartyToPerson(p, PersonRole.buyer)).toList(),
      property: Property(
        registryNumber: data.propertyNumber,
        zone: data.propertyZone,
        address: data.propertyAddress,
        area: data.propertyArea,
        boundaries: data.boundaries,
      ),
      payment: Payment(
        totalPrice: data.totalPrice,
        paidAmount: 0,
        balance: data.totalPrice,
        penaltyAmount: data.penaltyAmount,
      ),
    );
  }

  ContractType _mapContractType(legal.ContractType type) {
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
      default:
        return ContractType.directSale;
    }
  }

  Future<void> _saveContract() async {
    try {
      _refreshContractText();
      final contract = _convertToContract(_buildContractData());
      await context.read<ContractProvider>().saveContract(contract);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ العقد بنجاح'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الحفظ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    try {
      final contract = _convertToContract(_buildContractData());
      await PdfService().generate(contract);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PdfPreviewScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في التصدير: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _addCustomClause() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة بند إضافي'),
        content: TextField(
          controller: controller,
          textDirection: ui.TextDirection.rtl,
          textAlign: TextAlign.right,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'نص البند',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _customClauses.add(controller.text.trim());
                  _refreshContractText();
                });
                controller.dispose();
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _WizardConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareContractText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نسخ نص العقد إلى الحافظة')),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // واجهة المستخدم
  // ═══════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مولد العقود الذكي (${_step + 1}/${_WizardConstants.totalSteps})'),
        backgroundColor: _WizardConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_step == _WizardConstants.totalSteps - 1)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveContract,
              tooltip: 'حفظ العقد',
            ),
        ],
      ),
      body: Column(children: [
        LinearProgressIndicator(
          value: (_step + 1) / _WizardConstants.totalSteps,
          backgroundColor: Colors.grey[300],
          color: _WizardConstants.primaryColor,
          minHeight: 6,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
              _buildStep4(),
              _buildStep5(),
              _buildStep6(),
            ],
          ),
        ),
        _buildNavigationButtons(),
      ]),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '📋 اختر نوع العقد',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'اختر نوع العقد الذي تريد إنشاؤه',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildTypeTile(legal.ContractType.sale, '🏠', 'بيع عقاري قطعي'),
                  _buildTypeTile(legal.ContractType.rent, '🔑', 'إيجار عقاري'),
                  _buildTypeTile(legal.ContractType.gift, '🎁', 'هبة عقارية'),
                  _buildTypeTile(legal.ContractType.partnership, '🏗️', 'مشاركة بناء'),
                  _buildTypeTile(legal.ContractType.vehicleSale, '🚗', 'بيع مركبة'),
                  _buildTypeTile(legal.ContractType.vehicleRent, '🚙', 'إيجار مركبة'),
                  _buildTypeTile(legal.ContractType.agency, '📜', 'وكالة غير قابلة للعزل'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTile(legal.ContractType type, String icon, String label) {
    return RadioListTile<legal.ContractType>(
      title: Text(label, style: const TextStyle(fontSize: 16)),
      secondary: Text(icon, style: const TextStyle(fontSize: 24)),
      value: type,
      groupValue: _type,
      onChanged: (v) => setState(() => _type = v!),
      activeColor: _WizardConstants.primaryColor,
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '👥 إدارة الأطراف',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف أو احذف البائعين والمشترين حسب الحاجة',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _partyCountRow(
                    label: 'البائعون: ${_sellers.length}',
                    onAdd: _addSeller,
                    onRemove: () {
                      if (_sellers.length > 1) _removeSeller(_sellers.length - 1);
                    },
                  ),
                  const SizedBox(height: 8),
                  _partyCountRow(
                    label: 'المشترون: ${_buyers.length}',
                    onAdd: _addBuyer,
                    onRemove: () {
                      if (_buyers.length > 1) _removeBuyer(_buyers.length - 1);
                    },
                  ),
                  const Divider(height: 24),
                  Text(
                    'إجمالي الأطراف: ${_sellers.length + _buyers.length}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _partyCountRow(
      {required String label,
      required VoidCallback onAdd,
      required VoidCallback onRemove}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: onAdd),
        IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: onRemove),
      ],
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _sellersFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '📝 بيانات البائعين',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل بيانات كل بائع بالتفصيل',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...List.generate(_sellers.length, (i) => _buildPartyCard(
                  index: i,
                  title: 'بائع ${i + 1}',
                  isSeller: true,
                  nameCtrl: _sellerNameControllers[i],
                  fatherCtrl: _sellerFatherControllers[i],
                  motherCtrl: _sellerMotherControllers[i],
                  idCtrl: _sellerIdControllers[i],
                  phoneCtrl: _sellerPhoneControllers[i],
                  addressCtrl: _sellerAddressControllers[i],
                  shareCtrl: _sellerShareControllers[i],
                  capacity: _sellerCapacities[i],
                  poaNumberCtrl: _sellerPoaNumberControllers[i],
                  poaDateCtrl: _sellerPoaDateControllers[i],
                  isMinor: _sellerIsMinor[i],
                  isExpatriate: _sellerIsExpatriate[i],
                  onUpdateCapacity: (v) => setState(() => _sellerCapacities[i] = v),
                  onUpdateMinor: (v) => setState(() => _sellerIsMinor[i] = v),
                  onUpdateExpatriate: (v) => setState(() => _sellerIsExpatriate[i] = v),
                  onDelete: () => _removeSeller(i),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _buyersFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '📝 بيانات المشترين',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل بيانات كل مشترٍ بالتفصيل',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...List.generate(_buyers.length, (i) => _buildPartyCard(
                  index: i,
                  title: 'مشتري ${i + 1}',
                  isSeller: false,
                  nameCtrl: _buyerNameControllers[i],
                  fatherCtrl: _buyerFatherControllers[i],
                  motherCtrl: _buyerMotherControllers[i],
                  idCtrl: _buyerIdControllers[i],
                  phoneCtrl: _buyerPhoneControllers[i],
                  addressCtrl: _buyerAddressControllers[i],
                  shareCtrl: _buyerShareControllers[i],
                  capacity: _buyerCapacities[i],
                  poaNumberCtrl: _buyerPoaNumberControllers[i],
                  poaDateCtrl: _buyerPoaDateControllers[i],
                  isMinor: _buyerIsMinor[i],
                  isExpatriate: _buyerIsExpatriate[i],
                  onUpdateCapacity: (v) => setState(() => _buyerCapacities[i] = v),
                  onUpdateMinor: (v) => setState(() => _buyerIsMinor[i] = v),
                  onUpdateExpatriate: (v) => setState(() => _buyerIsExpatriate[i] = v),
                  onDelete: () => _removeBuyer(i),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyCard({
    required int index,
    required String title,
    required bool isSeller,
    required TextEditingController nameCtrl,
    required TextEditingController fatherCtrl,
    required TextEditingController motherCtrl,
    required TextEditingController idCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController shareCtrl,
    required legal.LegalCapacity capacity,
    required TextEditingController poaNumberCtrl,
    required TextEditingController poaDateCtrl,
    required bool isMinor,
    required bool isExpatriate,
    required ValueChanged<legal.LegalCapacity> onUpdateCapacity,
    required ValueChanged<bool> onUpdateMinor,
    required ValueChanged<bool> onUpdateExpatriate,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _WizardConstants.primaryColor,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const Divider(),
            _buildRTLField(
                controller: nameCtrl, label: 'الاسم الكامل', isRequired: true),
            _buildRTLField(controller: fatherCtrl, label: 'اسم الأب'),
            _buildRTLField(controller: motherCtrl, label: 'اسم الأم'),
            _buildRTLField(controller: idCtrl, label: 'الرقم الوطني'),
            _buildRTLField(
                controller: phoneCtrl,
                label: 'رقم الهاتف',
                type: TextInputType.phone),
            _buildRTLField(controller: addressCtrl, label: 'العنوان'),
            _buildRTLField(
                controller: shareCtrl,
                label: 'الحصة (من 2400 سهم)',
                type: TextInputType.number),

            const SizedBox(height: 8),

            // ─── الصفة القانونية ────────────────────────────────────────────
            DropdownButtonFormField<legal.LegalCapacity>(
              value: capacity,
              decoration: const InputDecoration(
                labelText: 'الصفة القانونية',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                    value: legal.LegalCapacity.individual,
                    child: Text('أصيل')),
                DropdownMenuItem(
                    value: legal.LegalCapacity.guardian,
                    child: Text('وصي شرعي')),
                DropdownMenuItem(
                    value: legal.LegalCapacity.agent, child: Text('وكيل')),
                DropdownMenuItem(
                    value: legal.LegalCapacity.legalEntity,
                    child: Text('شخص اعتباري')),
              ],
              onChanged: (v) {
                if (v != null) onUpdateCapacity(v);
              },
            ),

            // ─── حقول الوكالة (تظهر فقط للوكيل) ────────────────────────────
            if (capacity == legal.LegalCapacity.agent) ...[
              _buildRTLField(
                controller: poaNumberCtrl,
                label: 'رقم الوكالة',
                isRequired: true,
              ),
              _buildRTLField(
                controller: poaDateCtrl,
                label: 'تاريخ الوكالة',
                isRequired: true,
              ),
            ],

            // ─── قاصر ومغترب ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('قاصر'),
                    value: isMinor,
                    onChanged: (v) => onUpdateMinor(v),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('مغترب'),
                    value: isExpatriate,
                    onChanged: (v) => onUpdateExpatriate(v),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep5() {
    return Form(
      key: _propertyFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🏠 بيانات العقار والثمن',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل تفاصيل العقار وقيمة العقد',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRTLField(
                        controller: _cityCtrl,
                        label: 'المدينة',
                        isRequired: true),
                    _buildRTLField(
                        controller: _governorateCtrl,
                        label: 'المحافظة',
                        isRequired: true),
                    _buildRTLField(
                        controller: _propertyNumberCtrl,
                        label: 'رقم السجل العقاري',
                        isRequired: true),
                    _buildRTLField(
                        controller: _propertyZoneCtrl,
                        label: 'المنطقة العقارية',
                        isRequired: true),
                    _buildRTLField(
                        controller: _propertyAddressCtrl,
                        label: 'العنوان التفصيلي'),
                    _buildRTLField(
                        controller: _propertyAreaCtrl,
                        label: 'المساحة (م²)',
                        type: TextInputType.number),
                    _buildRTLField(
                        controller: _boundariesCtrl,
                        label: 'الحدود',
                        maxLines: 2),
                    const Divider(),
                    const Text(
                      'البيانات المالية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildRTLField(
                        controller: _totalPriceCtrl,
                        label: 'الثمن الإجمالي (ل.س)',
                        isRequired: true,
                        type: TextInputType.number),
                    _buildRTLField(
                        controller: _penaltyAmountCtrl,
                        label: 'الشرط الجزائي (ل.س)',
                        type: TextInputType.number),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'طريقة الدفع',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'نقداً', child: Text('نقداً')),
                          DropdownMenuItem(
                              value: 'بنكي', child: Text('تحويل بنكي')),
                          DropdownMenuItem(
                              value: 'تقسيط', child: Text('تقسيط')),
                        ],
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep6() {
    final contractText = _cachedContractText ?? '...';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '📄 معاينة العقد',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'راجع العقد النهائي قبل التصدير',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      contractText,
                      style: const TextStyle(fontSize: 14, height: 1.8),
                      textDirection: ui.TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('بند إضافي'),
                        onPressed: _addCustomClause,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('مشاركة نص'),
                        onPressed: () => _shareContractText(contractText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير PDF'),
            onPressed: _exportPdf,
            style: ElevatedButton.styleFrom(
              backgroundColor: _WizardConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          if (_step > 0)
            TextButton.icon(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              label: const Text('السابق'),
              onPressed: _goToPreviousStep,
            ),
          const Spacer(),
          if (_step < _WizardConstants.totalSteps - 1)
            TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text('التالي'),
              onPressed: _goToNextStep,
            ),
        ],
      ),
    );
  }

  Widget _buildRTLField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        textDirection: ui.TextDirection.rtl,
        textAlign: TextAlign.right,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: const OutlineInputBorder(),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: isRequired
            ? (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null
            : null,
      ),
    );
  }
}
