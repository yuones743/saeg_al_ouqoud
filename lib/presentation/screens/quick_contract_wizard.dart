import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class QuickContractWizard extends StatefulWidget {
  const QuickContractWizard({super.key});

  @override
  State<QuickContractWizard> createState() => _QuickContractWizardState();
}

class _QuickContractWizardState extends State<QuickContractWizard> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  ContractType _type = ContractType.directSale;
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _governorate = SyrianGovernorates.all.first;

  final _sellerCtrl = TextEditingController();
  final _sellerIdCtrl = TextEditingController();
  final _sellerPhoneCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _buyerIdCtrl = TextEditingController();
  final _buyerPhoneCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _paidCtrl = TextEditingController();
  Currency _currency = Currency.syp;

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in [_dateCtrl, _cityCtrl, _sellerCtrl, _sellerIdCtrl, _sellerPhoneCtrl, _buyerCtrl, _buyerIdCtrl, _buyerPhoneCtrl, _registryCtrl, _zoneCtrl, _totalCtrl, _paidCtrl]) { c.dispose(); }
    super.dispose();
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    } else _submit();
  }

  void _back() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.reset();
    provider.updateType(_type);
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateGovernorate(_governorate);
    provider.updateSeller(Person(id: 'seller_qw1', fullName: _sellerCtrl.text.isEmpty ? 'البائع' : _sellerCtrl.text, nationalId: _sellerIdCtrl.text, phone: _sellerPhoneCtrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'buyer_qw1', fullName: _buyerCtrl.text.isEmpty ? 'المشتري' : _buyerCtrl.text, nationalId: _buyerIdCtrl.text, phone: _buyerPhoneCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text));
    final total = double.tryParse(_totalCtrl.text) ?? 0;
    final paid = double.tryParse(_paidCtrl.text) ?? 0;
    provider.updatePayment(Payment(totalPrice: total, paidAmount: paid, balance: total - paid, currency: _currency));
    await provider.analyze();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('معالج العقد السريع – ${_currentPage + 1}/$_totalPages')),
      body: Column(children: [
        LinearProgressIndicator(value: (_currentPage + 1) / _totalPages),
        Expanded(child: PageView(controller: _pageCtrl, physics: const NeverScrollableScrollPhysics(), children: [
          _page1TypeAndDate(),
          _page2Seller(),
          _page3Buyer(),
          _page4PropertyAndPrice(),
        ])),
        Padding(padding: const EdgeInsets.all(16),
          child: Row(children: [
            if (_currentPage > 0) Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.arrow_forward), label: const Text('السابق'), onPressed: _back)),
            if (_currentPage > 0) const SizedBox(width: 12),
            Expanded(flex: 2,
              child: ElevatedButton.icon(
                icon: Icon(_currentPage == _totalPages - 1 ? Icons.search : Icons.arrow_back),
                label: Text(_currentPage == _totalPages - 1 ? 'فحص العقد' : 'التالي'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4F72), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _next)),
          ])),
      ]),
    );
  }

  Widget _page1TypeAndDate() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('الخطوة الأولى: نوع العقد والتاريخ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 16),
    SectionCard(title: 'نوع العقد', icon: Icons.assignment, children: [
      DropdownButtonFormField<ContractType>(
        value: _type,
        decoration: const InputDecoration(labelText: 'اختر نوع العقد', border: OutlineInputBorder(), isDense: true),
        items: const [
          DropdownMenuItem(value: ContractType.directSale, child: Text('بيع مباشر')),
          DropdownMenuItem(value: ContractType.usufructSale, child: Text('بيع انتفاع')),
          DropdownMenuItem(value: ContractType.commonShareSale, child: Text('بيع حصة شائعة')),
          DropdownMenuItem(value: ContractType.settlement, child: Text('صلح ووساطة')),
          DropdownMenuItem(value: ContractType.promise, child: Text('وعد بالبيع')),
          DropdownMenuItem(value: ContractType.partition, child: Text('قسمة رضائية')),
        ],
        onChanged: (v) => setState(() => _type = v!),
      ),
    ]),
    SectionCard(title: 'التاريخ والمكان', icon: Icons.place, children: [
      ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد (يوم/شهر/سنة)'),
      ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
      Padding(padding: const EdgeInsets.only(bottom: 8),
        child: DropdownButtonFormField<String>(
          value: _governorate,
          decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder(), isDense: true),
          items: SyrianGovernorates.all.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (v) { if (v != null) setState(() => _governorate = v); },
        ),
      ),
    ]),
  ]);

  Widget _page2Seller() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('الخطوة الثانية: بيانات البائع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 16),
    SectionCard(title: 'البائع', icon: Icons.person, children: [
      ArabicTextField(controller: _sellerCtrl, label: 'الاسم الكامل', required: true),
      ArabicTextField(controller: _sellerIdCtrl, label: 'الرقم الوطني'),
      ArabicTextField(controller: _sellerPhoneCtrl, label: 'رقم الهاتف', type: TextInputType.phone),
    ]),
  ]);

  Widget _page3Buyer() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('الخطوة الثالثة: بيانات المشتري', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 16),
    SectionCard(title: 'المشتري', icon: Icons.person_outline, children: [
      ArabicTextField(controller: _buyerCtrl, label: 'الاسم الكامل', required: true),
      ArabicTextField(controller: _buyerIdCtrl, label: 'الرقم الوطني'),
      ArabicTextField(controller: _buyerPhoneCtrl, label: 'رقم الهاتف', type: TextInputType.phone),
    ]),
  ]);

  Widget _page4PropertyAndPrice() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('الخطوة الرابعة: العقار والثمن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 16),
    SectionCard(title: 'العقار', icon: Icons.home, children: [
      ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
      ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
    ]),
    SectionCard(title: 'الثمن', icon: Icons.attach_money, children: [
      ArabicTextField(controller: _totalCtrl, label: 'الثمن الإجمالي', type: TextInputType.number),
      ArabicTextField(controller: _paidCtrl, label: 'المبلغ المدفوع', type: TextInputType.number),
      Padding(padding: const EdgeInsets.only(bottom: 8),
        child: DropdownButtonFormField<Currency>(
          value: _currency,
          decoration: const InputDecoration(labelText: 'العملة', border: OutlineInputBorder(), isDense: true),
          items: const [
            DropdownMenuItem(value: Currency.syp, child: Text('ليرة سورية (ل.س)')),
            DropdownMenuItem(value: Currency.usd, child: Text('دولار أمريكي')),
            DropdownMenuItem(value: Currency.eur, child: Text('يورو')),
            DropdownMenuItem(value: Currency.sar, child: Text('ريال سعودي')),
          ],
          onChanged: (v) => setState(() => _currency = v!),
        ),
      ),
    ]),
  ]);
}