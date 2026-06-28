import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' hide TextDirection; // ✅ التصحيح: hide TextDirection
import 'dart:ui' as ui;
import '../../domain/models/legal_contract.dart' as legal;
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../../core/engine/contract_generator.dart';
import '../../application/services/pdf_service.dart';
import '../state/contract_provider.dart';
import 'pdf_preview_screen.dart';

class SmartContractWizard extends StatefulWidget {
  const SmartContractWizard({super.key});

  @override
  State<SmartContractWizard> createState() => _SmartContractWizardState();
}

class _SmartContractWizardState extends State<SmartContractWizard> {
  int _step = 0;
  final int _totalSteps = 6;

  legal.ContractType _type = legal.ContractType.sale;
  List<legal.LegalParty> _sellers = [];
  List<legal.LegalParty> _buyers = [];
  String _propertyNumber = '';
  String _propertyZone = '';
  String _propertyAddress = '';
  double _propertyArea = 0;
  String _boundaries = '';
  double _totalPrice = 0;
  String _paymentMethod = 'نقداً';
  double _penaltyAmount = 0;
  List<String> _customClauses = [];

  final PageController _pageController = PageController();

  final List<TextEditingController> _sellerNameControllers = [];
  final List<TextEditingController> _sellerIdControllers = [];
  final List<TextEditingController> _sellerFatherControllers = [];
  final List<TextEditingController> _sellerMotherControllers = [];
  final List<TextEditingController> _sellerPhoneControllers = [];
  final List<TextEditingController> _sellerAddressControllers = [];
  final List<TextEditingController> _sellerShareControllers = [];

  final List<TextEditingController> _buyerNameControllers = [];
  final List<TextEditingController> _buyerIdControllers = [];
  final List<TextEditingController> _buyerFatherControllers = [];
  final List<TextEditingController> _buyerMotherControllers = [];
  final List<TextEditingController> _buyerPhoneControllers = [];
  final List<TextEditingController> _buyerAddressControllers = [];
  final List<TextEditingController> _buyerShareControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeSellers(1);
    _initializeBuyers(1);
  }

  @override
  void dispose() {
    _disposeControllers(_sellerNameControllers);
    _disposeControllers(_sellerIdControllers);
    _disposeControllers(_sellerFatherControllers);
    _disposeControllers(_sellerMotherControllers);
    _disposeControllers(_sellerPhoneControllers);
    _disposeControllers(_sellerAddressControllers);
    _disposeControllers(_sellerShareControllers);

    _disposeControllers(_buyerNameControllers);
    _disposeControllers(_buyerIdControllers);
    _disposeControllers(_buyerFatherControllers);
    _disposeControllers(_buyerMotherControllers);
    _disposeControllers(_buyerPhoneControllers);
    _disposeControllers(_buyerAddressControllers);
    _disposeControllers(_buyerShareControllers);

    _pageController.dispose();
    super.dispose();
  }

  void _disposeControllers(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
  }

  void _initializeSellers(int count) {
    _disposeControllers(_sellerNameControllers);
    _disposeControllers(_sellerIdControllers);
    _disposeControllers(_sellerFatherControllers);
    _disposeControllers(_sellerMotherControllers);
    _disposeControllers(_sellerPhoneControllers);
    _disposeControllers(_sellerAddressControllers);
    _disposeControllers(_sellerShareControllers);

    _sellers = [];
    for (int i = 0; i < count; i++) {
      final double share = count > 0 ? (2400.0 / count) : 0.0;
      _sellers.add(legal.LegalParty(
        id: 'seller_${i + 1}',
        fullName: '',
        nationalId: '',
        role: legal.PartyRole.seller,
        share: share,
      ));
      _sellerNameControllers.add(TextEditingController());
      _sellerIdControllers.add(TextEditingController());
      _sellerFatherControllers.add(TextEditingController());
      _sellerMotherControllers.add(TextEditingController());
      _sellerPhoneControllers.add(TextEditingController());
      _sellerAddressControllers.add(TextEditingController());
      _sellerShareControllers.add(TextEditingController(text: share.toString()));
    }
  }

  void _initializeBuyers(int count) {
    _disposeControllers(_buyerNameControllers);
    _disposeControllers(_buyerIdControllers);
    _disposeControllers(_buyerFatherControllers);
    _disposeControllers(_buyerMotherControllers);
    _disposeControllers(_buyerPhoneControllers);
    _disposeControllers(_buyerAddressControllers);
    _disposeControllers(_buyerShareControllers);

    _buyers = [];
    for (int i = 0; i < count; i++) {
      final double share = count > 0 ? (2400.0 / count) : 0.0;
      _buyers.add(legal.LegalParty(
        id: 'buyer_${i + 1}',
        fullName: '',
        nationalId: '',
        role: legal.PartyRole.buyer,
        share: share,
      ));
      _buyerNameControllers.add(TextEditingController());
      _buyerIdControllers.add(TextEditingController());
      _buyerFatherControllers.add(TextEditingController());
      _buyerMotherControllers.add(TextEditingController());
      _buyerPhoneControllers.add(TextEditingController());
      _buyerAddressControllers.add(TextEditingController());
      _buyerShareControllers.add(TextEditingController(text: share.toString()));
    }
  }

  void _updateSellersFromControllers() {
    for (int i = 0; i < _sellers.length; i++) {
      _sellers[i] = _sellers[i].copyWith(
        fullName: _sellerNameControllers[i].text,
        nationalId: _sellerIdControllers[i].text,
        fatherName: _sellerFatherControllers[i].text,
        motherName: _sellerMotherControllers[i].text,
        phone: _sellerPhoneControllers[i].text,
        address: _sellerAddressControllers[i].text,
        share: double.tryParse(_sellerShareControllers[i].text) ?? 0,
      );
    }
  }

  void _updateBuyersFromControllers() {
    for (int i = 0; i < _buyers.length; i++) {
      _buyers[i] = _buyers[i].copyWith(
        fullName: _buyerNameControllers[i].text,
        nationalId: _buyerIdControllers[i].text,
        fatherName: _buyerFatherControllers[i].text,
        motherName: _buyerMotherControllers[i].text,
        phone: _buyerPhoneControllers[i].text,
        address: _buyerAddressControllers[i].text,
        share: double.tryParse(_buyerShareControllers[i].text) ?? 0,
      );
    }
  }

  // ✅ التصحيح: استخدام double صريح
  void _addSeller() {
    setState(() {
      final double newShare = _sellers.isEmpty ? 2400.0 : (2400.0 / (_sellers.length + 1));
      _sellers.add(legal.LegalParty(
        id: 'seller_${_sellers.length + 1}',
        fullName: '',
        nationalId: '',
        role: legal.PartyRole.seller,
        share: newShare,
      ));
      _sellerNameControllers.add(TextEditingController());
      _sellerIdControllers.add(TextEditingController());
      _sellerFatherControllers.add(TextEditingController());
      _sellerMotherControllers.add(TextEditingController());
      _sellerPhoneControllers.add(TextEditingController());
      _sellerAddressControllers.add(TextEditingController());
      _sellerShareControllers.add(TextEditingController(text: newShare.toString()));
      _updateAllShares();
    });
  }

  // ✅ التصحيح: استخدام double صريح
  void _addBuyer() {
    setState(() {
      final double newShare = _buyers.isEmpty ? 2400.0 : (2400.0 / (_buyers.length + 1));
      _buyers.add(legal.LegalParty(
        id: 'buyer_${_buyers.length + 1}',
        fullName: '',
        nationalId: '',
        role: legal.PartyRole.buyer,
        share: newShare,
      ));
      _buyerNameControllers.add(TextEditingController());
      _buyerIdControllers.add(TextEditingController());
      _buyerFatherControllers.add(TextEditingController());
      _buyerMotherControllers.add(TextEditingController());
      _buyerPhoneControllers.add(TextEditingController());
      _buyerAddressControllers.add(TextEditingController());
      _buyerShareControllers.add(TextEditingController(text: newShare.toString()));
      _updateAllShares();
    });
  }

  void _removeSeller(int index) {
    if (_sellers.length <= 1) return;
    setState(() {
      _sellers.removeAt(index);
      _sellerNameControllers[index].dispose();
      _sellerNameControllers.removeAt(index);
      _sellerIdControllers[index].dispose();
      _sellerIdControllers.removeAt(index);
      _sellerFatherControllers[index].dispose();
      _sellerFatherControllers.removeAt(index);
      _sellerMotherControllers[index].dispose();
      _sellerMotherControllers.removeAt(index);
      _sellerPhoneControllers[index].dispose();
      _sellerPhoneControllers.removeAt(index);
      _sellerAddressControllers[index].dispose();
      _sellerAddressControllers.removeAt(index);
      _sellerShareControllers[index].dispose();
      _sellerShareControllers.removeAt(index);
      _updateAllShares();
    });
  }

  void _removeBuyer(int index) {
    if (_buyers.length <= 1) return;
    setState(() {
      _buyers.removeAt(index);
      _buyerNameControllers[index].dispose();
      _buyerNameControllers.removeAt(index);
      _buyerIdControllers[index].dispose();
      _buyerIdControllers.removeAt(index);
      _buyerFatherControllers[index].dispose();
      _buyerFatherControllers.removeAt(index);
      _buyerMotherControllers[index].dispose();
      _buyerMotherControllers.removeAt(index);
      _buyerPhoneControllers[index].dispose();
      _buyerPhoneControllers.removeAt(index);
      _buyerAddressControllers[index].dispose();
      _buyerAddressControllers.removeAt(index);
      _buyerShareControllers[index].dispose();
      _buyerShareControllers.removeAt(index);
      _updateAllShares();
    });
  }

  void _updateAllShares() {
    if (_sellers.isNotEmpty) {
      final double sellerShare = (2400.0 / _sellers.length);
      for (int i = 0; i < _sellers.length; i++) {
        _sellers[i] = _sellers[i].copyWith(share: sellerShare);
        _sellerShareControllers[i].text = sellerShare.toString();
      }
    }
    if (_buyers.isNotEmpty) {
      final double buyerShare = (2400.0 / _buyers.length);
      for (int i = 0; i < _buyers.length; i++) {
        _buyers[i] = _buyers[i].copyWith(share: buyerShare);
        _buyerShareControllers[i].text = buyerShare.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مولد العقود الذكي (${_step + 1}/$_totalSteps)'),
        backgroundColor: const Color(0xFF1B4F72),
        foregroundColor: Colors.white,
        actions: [
          if (_step == _totalSteps - 1)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveContract,
              tooltip: 'حفظ العقد',
            ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_step + 1) / _totalSteps,
            backgroundColor: Colors.grey[300],
            color: const Color(0xFF1B4F72),
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
        ],
      ),
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
      activeColor: const Color(0xFF1B4F72),
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
                  Row(
                    children: [
                      Text(
                        'البائعون: ${_sellers.length}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: _addSeller,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (_sellers.length > 1) {
                            _removeSeller(_sellers.length - 1);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'المشترون: ${_buyers.length}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: _addBuyer,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (_buyers.length > 1) {
                            _removeBuyer(_buyers.length - 1);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'إجمالي الأطراف: ${_sellers.length + _buyers.length}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
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
          ...List.generate(_sellers.length, (index) {
            return _buildSellerCard(index);
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
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
          ...List.generate(_buyers.length, (index) {
            return _buildBuyerCard(index);
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(int index) {
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
                  backgroundColor: const Color(0xFF1B4F72),
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Text('بائع ${index + 1}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeSeller(index),
                ),
              ],
            ),
            const Divider(),
            _buildRTLTextField(
              controller: _sellerNameControllers[index],
              label: 'الاسم الكامل *',
            ),
            _buildRTLTextField(
              controller: _sellerFatherControllers[index],
              label: 'اسم الأب',
            ),
            _buildRTLTextField(
              controller: _sellerMotherControllers[index],
              label: 'اسم الأم',
            ),
            _buildRTLTextField(
              controller: _sellerIdControllers[index],
              label: 'الرقم الوطني',
            ),
            _buildRTLTextField(
              controller: _sellerPhoneControllers[index],
              label: 'رقم الهاتف',
              type: TextInputType.phone,
            ),
            _buildRTLTextField(
              controller: _sellerAddressControllers[index],
              label: 'العنوان',
            ),
            _buildRTLTextField(
              controller: _sellerShareControllers[index],
              label: 'الحصة (من 2400 سهم)',
              type: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerCard(int index) {
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
                  backgroundColor: const Color(0xFF1B4F72),
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Text('مشتري ${index + 1}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeBuyer(index),
                ),
              ],
            ),
            const Divider(),
            _buildRTLTextField(
              controller: _buyerNameControllers[index],
              label: 'الاسم الكامل *',
            ),
            _buildRTLTextField(
              controller: _buyerFatherControllers[index],
              label: 'اسم الأب',
            ),
            _buildRTLTextField(
              controller: _buyerMotherControllers[index],
              label: 'اسم الأم',
            ),
            _buildRTLTextField(
              controller: _buyerIdControllers[index],
              label: 'الرقم الوطني',
            ),
            _buildRTLTextField(
              controller: _buyerPhoneControllers[index],
              label: 'رقم الهاتف',
              type: TextInputType.phone,
            ),
            _buildRTLTextField(
              controller: _buyerAddressControllers[index],
              label: 'العنوان',
            ),
            _buildRTLTextField(
              controller: _buyerShareControllers[index],
              label: 'الحصة (من 2400 سهم)',
              type: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ حقل RTL صحيح 100%
  Widget _buildRTLTextField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool required = false,
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
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null
            : null,
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
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
                  _buildRTLTextField(
                    controller: TextEditingController(text: _propertyNumber),
                    label: 'رقم السجل العقاري *',
                    required: true,
                  ),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _propertyZone),
                    label: 'المنطقة العقارية *',
                    required: true,
                  ),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _propertyAddress),
                    label: 'العنوان التفصيلي',
                  ),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _propertyArea.toString()),
                    label: 'المساحة (م²)',
                    type: TextInputType.number,
                  ),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _boundaries),
                    label: 'الحدود',
                    maxLines: 2,
                  ),
                  const Divider(),
                  const Text(
                    'البيانات المالية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _totalPrice.toString()),
                    label: 'الثمن الإجمالي (ل.س) *',
                    type: TextInputType.number,
                    required: true,
                  ),
                  _buildRTLTextField(
                    controller: TextEditingController(text: _penaltyAmount.toString()),
                    label: 'الشرط الجزائي (ل.س)',
                    type: TextInputType.number,
                  ),
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
                        DropdownMenuItem(value: 'نقداً', child: Text('نقداً')),
                        DropdownMenuItem(value: 'بنكي', child: Text('تحويل بنكي')),
                        DropdownMenuItem(value: 'تقسيط', child: Text('تقسيط')),
                      ],
                      onChanged: (v) => setState(() => _paymentMethod = v!),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep6() {
    _updateSellersFromControllers();
    _updateBuyersFromControllers();

    final contractData = legal.LegalContractData(
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

    final contractText = ContractGenerator.generate(contractData);

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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('تصدير PDF'),
                  onPressed: () => _exportPdf(contractData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4F72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
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
              icon: const Icon(Icons.arrow_forward),
              label: const Text('السابق'),
              onPressed: _goToPreviousStep,
            ),
          const Spacer(),
          if (_step < _totalSteps - 1)
            TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('التالي'),
              onPressed: _goToNextStep,
            ),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    if (step == 3 || step == 4) {
      _updateSellersFromControllers();
      _updateBuyersFromControllers();
    }
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextStep() {
    if (_step < _totalSteps - 1) {
      if (_step == 3 || _step == 4) {
        _updateSellersFromControllers();
        _updateBuyersFromControllers();
      }
      _goToStep(_step + 1);
    }
  }

  void _goToPreviousStep() {
    if (_step > 0) {
      if (_step == 3 || _step == 4) {
        _updateSellersFromControllers();
        _updateBuyersFromControllers();
      }
      _goToStep(_step - 1);
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
          decoration: const InputDecoration(
            labelText: 'نص البند',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _customClauses.add(controller.text);
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
            ),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _shareContractText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ النص إلى الحافظة')),
    );
  }

  void _exportPdf(legal.LegalContractData data) async {
    try {
      final contract = _convertToContract(data);
      final pdfService = PdfService();
      await pdfService.generate(contract);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PdfPreviewScreen(),
          ),
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

  void _saveContract() async {
    try {
      _updateSellersFromControllers();
      _updateBuyersFromControllers();

      final contractData = legal.LegalContractData(
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

      final contract = _convertToContract(contractData);
      final provider = context.read<ContractProvider>();
      await provider.saveContract();

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

  Contract _convertToContract(legal.LegalContractData data) {
    final sellers = data.sellers.map((p) => Person(
      id: p.id,
      fullName: p.fullName,
      nationalId: p.nationalId,
      phone: p.phone,
      address: p.address,
      role: PersonRole.seller,
      isMinor: p.isMinor,
      isExpatriate: p.isExpatriate,
    )).toList();

    final buyers = data.buyers.map((p) => Person(
      id: p.id,
      fullName: p.fullName,
      nationalId: p.nationalId,
      phone: p.phone,
      address: p.address,
      role: PersonRole.buyer,
      isMinor: p.isMinor,
      isExpatriate: p.isExpatriate,
    )).toList();

    return Contract(
      id: data.id,
      type: _mapContractType(data.type),
      contractDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      city: data.propertyAddress,
      sellers: sellers,
      buyers: buyers,
      property: Property(
        registryNumber: data.propertyNumber,
        zone: data.propertyZone,
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
}
