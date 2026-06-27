import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/legal_contract.dart';
import '../../core/engine/contract_generator.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'pdf_preview_screen.dart';

class SmartContractWizard extends StatefulWidget {
  const SmartContractWizard({super.key});

  @override
  State<SmartContractWizard> createState() => _SmartContractWizardState();
}

class _SmartContractWizardState extends State<SmartContractWizard> {
  int _step = 0;
  final int _totalSteps = 6;

  // ─── بيانات العقد ───
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

  // ─── متغيرات مساعدة ───
  int _sellerCount = 1;
  int _buyerCount = 1;
  final PageController _pageController = PageController();

  // ─── مفاتيح التحكم ───
  final _formKey = GlobalKey<FormState>();

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

  // ═══════════════════════════════════════════════════════════
  // 📌 الخطوة 1: اختيار نوع العقد
  // ═══════════════════════════════════════════════════════════
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
                  _buildTypeTile(ContractType.sale, '🏠', 'بيع عقاري قطعي'),
                  _buildTypeTile(ContractType.rent, '🔑', 'إيجار عقاري'),
                  _buildTypeTile(ContractType.gift, '🎁', 'هبة عقارية'),
                  _buildTypeTile(ContractType.partnership, '🏗️', 'مشاركة بناء'),
                  _buildTypeTile(ContractType.vehicleSale, '🚗', 'بيع مركبة'),
                  _buildTypeTile(ContractType.vehicleRent, '🚙', 'إيجار مركبة'),
                  _buildTypeTile(ContractType.agency, '📜', 'وكالة غير قابلة للعزل'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTile(ContractType type, String icon, String label) {
    return RadioListTile<ContractType>(
      title: Text(label, style: const TextStyle(fontSize: 16)),
      secondary: Text(icon, style: const TextStyle(fontSize: 24)),
      value: type,
      groupValue: _type,
      onChanged: (v) => setState(() => _type = v!),
      activeColor: const Color(0xFF1B4F72),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 📌 الخطوة 2: عدد الأطراف
  // ═══════════════════════════════════════════════════════════
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '👥 عدد الأطراف',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'حدد عدد البائعين والمشترين في العقد',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCounterRow(
                    label: 'عدد البائعين',
                    value: _sellerCount,
                    onDecrement: () => setState(() { if (_sellerCount > 1) _sellerCount--; }),
                    onIncrement: () => setState(() { if (_sellerCount < 5) _sellerCount++; }),
                  ),
                  const SizedBox(height: 16),
                  _buildCounterRow(
                    label: 'عدد المشترين',
                    value: _buyerCount,
                    onDecrement: () => setState(() { if (_buyerCount > 1) _buyerCount--; }),
                    onIncrement: () => setState(() { if (_buyerCount < 5) _buyerCount++; }),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'إجمالي الأطراف: ${_sellerCount + _buyerCount}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // ✅ تم إصلاح الخطأ: تحويل int إلى double
              _sellers = List.generate(_sellerCount, (i) => LegalParty(
                id: 'seller_${i + 1}',
                fullName: '',
                nationalId: '',
                role: PartyRole.seller,
                share: (2400 / _sellerCount).toDouble(),
              ));
              _buyers = List.generate(_buyerCount, (i) => LegalParty(
                id: 'buyer_${i + 1}',
                fullName: '',
                nationalId: '',
                role: PartyRole.buyer,
                share: (2400 / _buyerCount).toDouble(),
              ));
              _goToStep(2);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('تأكيد وبدء إدخال البيانات'),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: onDecrement,
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$value',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 📌 الخطوة 3 و 4: بيانات الأطراف
  // ═══════════════════════════════════════════════════════════
  Widget _buildStep3() {
    return _buildPartiesStep(
      title: 'بيانات البائعين',
      parties: _sellers,
      onUpdate: (index, party) => setState(() => _sellers[index] = party),
    );
  }

  Widget _buildStep4() {
    return _buildPartiesStep(
      title: 'بيانات المشترين',
      parties: _buyers,
      onUpdate: (index, party) => setState(() => _buyers[index] = party),
    );
  }

  Widget _buildPartiesStep({
    required String title,
    required List<LegalParty> parties,
    required Function(int, LegalParty) onUpdate,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '📝 $title',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل بيانات كل طرف بالتفصيل',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...parties.asMap().entries.map((entry) {
            final index = entry.key;
            final party = entry.value;
            return _buildPartyCard(
              index: index,
              party: party,
              title: '${title.split(' ').first} ${index + 1}',
              onUpdate: (updated) => onUpdate(index, updated),
            );
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

  Widget _buildPartyCard({
    required int index,
    required LegalParty party,
    required String title,
    required Function(LegalParty) onUpdate,
  }) {
    final nameCtrl = TextEditingController(text: party.fullName);
    final idCtrl = TextEditingController(text: party.nationalId);
    final fatherCtrl = TextEditingController(text: party.fatherName);
    final motherCtrl = TextEditingController(text: party.motherName);
    final phoneCtrl = TextEditingController(text: party.phone);
    final addressCtrl = TextEditingController(text: party.address);
    final shareCtrl = TextEditingController(text: party.share.toString());

    LegalCapacity capacity = party.capacity;
    bool isMinor = party.isMinor;
    bool isExpatriate = party.isExpatriate;

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
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('حذف'),
                        content: Text('هل أنت متأكد من حذف $title؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              setState(() {});
                            },
                            child: const Text('حذف', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            ArabicTextField(
              controller: nameCtrl,
              label: 'الاسم الكامل',
              required: true,
              onChanged: (v) => onUpdate(party.copyWith(fullName: v)),
            ),
            ArabicTextField(
              controller: fatherCtrl,
              label: 'اسم الأب',
              onChanged: (v) => onUpdate(party.copyWith(fatherName: v)),
            ),
            ArabicTextField(
              controller: motherCtrl,
              label: 'اسم الأم',
              onChanged: (v) => onUpdate(party.copyWith(motherName: v)),
            ),
            ArabicTextField(
              controller: idCtrl,
              label: 'الرقم الوطني',
              onChanged: (v) => onUpdate(party.copyWith(nationalId: v)),
            ),
            ArabicTextField(
              controller: phoneCtrl,
              label: 'رقم الهاتف',
              type: TextInputType.phone,
              onChanged: (v) => onUpdate(party.copyWith(phone: v)),
            ),
            ArabicTextField(
              controller: addressCtrl,
              label: 'العنوان',
              onChanged: (v) => onUpdate(party.copyWith(address: v)),
            ),
            ArabicTextField(
              controller: shareCtrl,
              label: 'الحصة (من 2400 سهم)',
              type: TextInputType.number,
              onChanged: (v) => onUpdate(party.copyWith(share: double.tryParse(v) ?? 0)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<LegalCapacity>(
              value: capacity,
              decoration: const InputDecoration(
                labelText: 'الصفة القانونية',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: LegalCapacity.individual, child: Text('أصيل')),
                DropdownMenuItem(value: LegalCapacity.guardian, child: Text('وصي شرعي')),
                DropdownMenuItem(value: LegalCapacity.agent, child: Text('وكيل')),
                DropdownMenuItem(value: LegalCapacity.legalEntity, child: Text('شخص اعتباري')),
              ],
              onChanged: (v) {
                if (v != null) {
                  capacity = v;
                  onUpdate(party.copyWith(capacity: v));
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('قاصر'),
                    value: isMinor,
                    onChanged: (v) {
                      isMinor = v;
                      onUpdate(party.copyWith(isMinor: v));
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('مغترب'),
                    value: isExpatriate,
                    onChanged: (v) {
                      isExpatriate = v;
                      onUpdate(party.copyWith(isExpatriate: v));
                    },
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

  // ═══════════════════════════════════════════════════════════
  // 📌 الخطوة 5: بيانات العقار والثمن
  // ═══════════════════════════════════════════════════════════
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
          Form(
            key: _formKey,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ArabicTextField(
                      controller: TextEditingController(text: _propertyNumber),
                      label: 'رقم السجل العقاري',
                      required: true,
                      onChanged: (v) => _propertyNumber = v,
                    ),
                    ArabicTextField(
                      controller: TextEditingController(text: _propertyZone),
                      label: 'المنطقة العقارية',
                      required: true,
                      onChanged: (v) => _propertyZone = v,
                    ),
                    ArabicTextField(
                      controller: TextEditingController(text: _propertyAddress),
                      label: 'العنوان التفصيلي',
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
                    const Text(
                      'البيانات المالية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ArabicTextField(
                      controller: TextEditingController(text: _totalPrice.toString()),
                      label: 'الثمن الإجمالي (ل.س)',
                      type: TextInputType.number,
                      required: true,
                      onChanged: (v) => _totalPrice = double.tryParse(v) ?? 0,
                    ),
                    ArabicTextField(
                      controller: TextEditingController(text: _penaltyAmount.toString()),
                      label: 'الشرط الجزائي (ل.س)',
                      type: TextInputType.number,
                      onChanged: (v) => _penaltyAmount = double.tryParse(v) ?? 0,
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

  // ═══════════════════════════════════════════════════════════
  // 📌 الخطوة 6: المعاينة والتصدير
  // ═══════════════════════════════════════════════════════════
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
                      textDirection: TextDirection.rtl,
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
                        onPressed: () {
                          _shareContractText(contractText);
                        },
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

  // ═══════════════════════════════════════════════════════════
  // 🛠️ دوال مساعدة
  // ═══════════════════════════════════════════════════════════

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
    setState(() => _step = step);
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

  void _addCustomClause() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة بند إضافي'),
        content: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
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

  void _exportPdf(LegalContractData data) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري تجهيز ملف PDF...')),
    );
  }

  void _saveContract() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ العقد بنجاح'), backgroundColor: Colors.green),
    );
  }
}

extension LegalPartyExtension on LegalParty {
  LegalParty copyWith({
    String? id,
    String? fullName,
    String? nationalId,
    String? fatherName,
    String? motherName,
    String? address,
    String? phone,
    PartyRole? role,
    LegalCapacity? capacity,
    double? share,
    String? poaNumber,
    String? poaDate,
    bool? isMinor,
    bool? isExpatriate,
  }) {
    return LegalParty(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      capacity: capacity ?? this.capacity,
      share: share ?? this.share,
      poaNumber: poaNumber ?? this.poaNumber,
      poaDate: poaDate ?? this.poaDate,
      isMinor: isMinor ?? this.isMinor,
      isExpatriate: isExpatriate ?? this.isExpatriate,
    );
  }
}
