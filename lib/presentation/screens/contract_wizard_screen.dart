import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/legal_contract.dart';
import '../../core/engine/contract_generator.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'pdf_preview_screen.dart';

class ContractWizardScreen extends StatefulWidget {
  const ContractWizardScreen({super.key});

  @override
  State<ContractWizardScreen> createState() => _ContractWizardScreenState();
}

class _ContractWizardScreenState extends State<ContractWizardScreen> {
  int _step = 0;
  final int _totalSteps = 6;

  // بيانات العقد
  ContractType _type = ContractType.sale;
  List<LegalParty> _sellers = [];
  List<LegalParty> _buyers = [];
  String _propertyNumber = '';
  String _propertyZone = '';
  String _propertyAddress = '';
  double _propertyArea = 0;
  String _boundaries = '';
  double _totalPrice = 0;
  String _paymentMethod = 'نقداً';
  double _penaltyAmount = 0;
  List<String> _customClauses = [];

  // متغيرات مؤقتة للإدخال
  int _sellerCount = 1;
  int _buyerCount = 1;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مولد العقود الذكي (${_step + 1}/$_totalSteps)'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / _totalSteps),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(), // نوع العقد
                _buildStep2(), // عدد الأطراف
                _buildStep3(), // بيانات البائعين
                _buildStep4(), // بيانات المشترين
                _buildStep5(), // بيانات العقار والثمن
                _buildStep6(), // معاينة وتصدير
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('اختر نوع العقد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: ContractType.values.map((type) => RadioListTile<ContractType>(
              title: Text(_getTypeLabel(type)),
              value: type,
              groupValue: _type,
              onChanged: (v) => setState(() => _type = v!),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('عدد الأطراف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('عدد البائعين:')),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() { if (_sellerCount > 1) _sellerCount--; }),
                    ),
                    Text('$_sellerCount'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() { if (_sellerCount < 5) _sellerCount++; }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Text('عدد المشترين:')),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() { if (_buyerCount > 1) _buyerCount--; }),
                    ),
                    Text('$_buyerCount'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() { if (_buyerCount < 5) _buyerCount++; }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // تهيئة قوائم البائعين والمشترين
            _sellers = List.generate(_sellerCount, (i) => LegalParty(
              id: 'seller_$i',
              fullName: '',
              nationalId: '',
              role: PartyRole.seller,
              share: 2400 ~/ _sellerCount,
            ));
            _buyers = List.generate(_buyerCount, (i) => LegalParty(
              id: 'buyer_$i',
              fullName: '',
              nationalId: '',
              role: PartyRole.buyer,
              share: 2400 ~/ _buyerCount,
            ));
            _goToStep(2);
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('بيانات البائعين', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._sellers.asMap().entries.map((entry) => _buildPartyCard(
          index: entry.key,
          party: entry.value,
          title: 'البائع ${entry.key + 1}',
        )),
        ElevatedButton(
          onPressed: _goToNextStep,
          child: const Text('التالي'),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('بيانات المشترين', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._buyers.asMap().entries.map((entry) => _buildPartyCard(
          index: entry.key,
          party: entry.value,
          title: 'المشتري ${entry.key + 1}',
        )),
        ElevatedButton(
          onPressed: _goToNextStep,
          child: const Text('التالي'),
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('بيانات العقار والثمن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ArabicTextField(
                  controller: TextEditingController(text: _propertyNumber),
                  label: 'رقم السجل العقاري',
                  onChanged: (v) => _propertyNumber = v,
                ),
                ArabicTextField(
                  controller: TextEditingController(text: _propertyZone),
                  label: 'المنطقة العقارية',
                  onChanged: (v) => _propertyZone = v,
                ),
                ArabicTextField(
                  controller: TextEditingController(text: _propertyAddress),
                  label: 'العنوان',
                  onChanged: (v) => _propertyAddress = v,
                ),
                ArabicTextField(
                  controller: TextEditingController(text: _propertyArea.toString()),
                  label: 'المساحة (م²)',
                  type: TextInputType.number,
                  onChanged: (v) => _propertyArea = double.tryParse(v) ?? 0,
                ),
                ArabicTextField(
                  controller: TextEditingController(text: _boundaries),
                  label: 'الحدود',
                  maxLines: 2,
                  onChanged: (v) => _boundaries = v,
                ),
                const Divider(),
                ArabicTextField(
                  controller: TextEditingController(text: _totalPrice.toString()),
                  label: 'الثمن الإجمالي (ل.س)',
                  type: TextInputType.number,
                  onChanged: (v) => _totalPrice = double.tryParse(v) ?? 0,
                ),
                ArabicTextField(
                  controller: TextEditingController(text: _penaltyAmount.toString()),
                  label: 'الشرط الجزائي (ل.س)',
                  type: TextInputType.number,
                  onChanged: (v) => _penaltyAmount = double.tryParse(v) ?? 0,
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _goToNextStep,
          child: const Text('التالي'),
        ),
      ],
    );
  }

  Widget _buildStep6() {
    final contractData = LegalContractData(
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
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('معاينة العقد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    contractText,
                    style: const TextStyle(fontSize: 14, height: 1.8),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('تصدير PDF'),
                  onPressed: () {
                    // حفظ العقد وتصديره
                    _saveAndExport(contractData);
                  },
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

  Widget _buildPartyCard({
    required int index,
    required LegalParty party,
    required String title,
  }) {
    final nameCtrl = TextEditingController(text: party.fullName);
    final idCtrl = TextEditingController(text: party.nationalId);
    final phoneCtrl = TextEditingController(text: party.phone);
    final addressCtrl = TextEditingController(text: party.address);
    final shareCtrl = TextEditingController(text: party.share.toString());

    LegalCapacity capacity = party.capacity;
    bool isMinor = party.isMinor;
    bool isExpatriate = party.isExpatriate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ArabicTextField(
              controller: nameCtrl,
              label: 'الاسم الكامل',
              required: true,
              onChanged: (v) => party.fullName = v,
            ),
            ArabicTextField(
              controller: idCtrl,
              label: 'الرقم الوطني',
              onChanged: (v) => party.nationalId = v,
            ),
            ArabicTextField(
              controller: phoneCtrl,
              label: 'رقم الهاتف',
              onChanged: (v) => party.phone = v,
            ),
            ArabicTextField(
              controller: addressCtrl,
              label: 'العنوان',
              onChanged: (v) => party.address = v,
            ),
            ArabicTextField(
              controller: shareCtrl,
              label: 'الحصة (من 2400 سهم)',
              type: TextInputType.number,
              onChanged: (v) => party.share = double.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<LegalCapacity>(
              value: capacity,
              decoration: const InputDecoration(labelText: 'الصفة'),
              items: const [
                DropdownMenuItem(value: LegalCapacity.individual, child: Text('أصيل')),
                DropdownMenuItem(value: LegalCapacity.guardian, child: Text('وصي شرعي')),
                DropdownMenuItem(value: LegalCapacity.agent, child: Text('وكيل')),
                DropdownMenuItem(value: LegalCapacity.legalEntity, child: Text('شخص اعتباري')),
              ],
              onChanged: (v) { if (v != null) { capacity = v; party.capacity = v; } },
            ),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('قاصر'),
                    value: isMinor,
                    onChanged: (v) { isMinor = v; party.isMinor = v; },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('مغترب'),
                    value: isExpatriate,
                    onChanged: (v) { isExpatriate = v; party.isExpatriate = v; },
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

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_step > 0)
            OutlinedButton(
              onPressed: _goToPreviousStep,
              child: const Text('السابق'),
            ),
          const Spacer(),
          if (_step < _totalSteps - 1)
            ElevatedButton(
              onPressed: _goToNextStep,
              child: const Text('التالي'),
            ),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    setState(() { _step = step; });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextStep() {
    if (_step < _totalSteps - 1) _goToStep(_step + 1);
  }

  void _goToPreviousStep() {
    if (_step > 0) _goToStep(_step - 1);
  }

  String _getTypeLabel(ContractType type) {
    switch (type) {
      case ContractType.sale: return 'بيع عقاري قطعي';
      case ContractType.rent: return 'إيجار عقاري';
      case ContractType.gift: return 'هبة عقارية';
      case ContractType.partnership: return 'مشاركة بناء';
      case ContractType.vehicleSale: return 'بيع مركبة';
      case ContractType.vehicleRent: return 'إيجار مركبة';
      case ContractType.agency: return 'وكالة غير قابلة للعزل';
      default: return 'عقد';
    }
  }

  void _saveAndExport(LegalContractData data) {
    // تحويل البيانات إلى عقد Flutter وتصديره
    // (سيربط مع نظام PDF الموجود)
  }
}
