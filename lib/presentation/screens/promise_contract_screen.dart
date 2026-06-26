import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class PromiseContractScreen extends StatefulWidget {
  const PromiseContractScreen({super.key});

  @override
  State<PromiseContractScreen> createState() => _PromiseContractScreenState();
}

class _PromiseContractScreenState extends State<PromiseContractScreen> {
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _depositCtrl = TextEditingController();
  final _finalDateCtrl = TextEditingController();
  final _penaltyCtrl = TextEditingController();
  bool _sellerHasPoa = false;
  bool _propHasSeizure = false;
  bool _propHasMortgage = false;
  Currency _currency = Currency.syp;

  @override
  void dispose() {
    for (final c in [_sellerCtrl, _buyerCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _totalCtrl, _depositCtrl, _finalDateCtrl, _penaltyCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 'seller_p1', fullName: _sellerCtrl.text.isEmpty ? 'الواعد بالبيع' : _sellerCtrl.text, role: PersonRole.seller, hasPowerOfAttorney: _sellerHasPoa));
    provider.updateBuyer(Person(id: 'buyer_p1', fullName: _buyerCtrl.text.isEmpty ? 'الواعد بالشراء' : _buyerCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, hasSeizure: _propHasSeizure, hasMortgage: _propHasMortgage));
    final total = double.tryParse(_totalCtrl.text) ?? 0;
    final deposit = double.tryParse(_depositCtrl.text) ?? 0;
    provider.updatePayment(Payment(totalPrice: total, paidAmount: deposit, balance: total - deposit, balanceDueDate: _finalDateCtrl.text, currency: _currency, penaltyAmount: double.tryParse(_penaltyCtrl.text) ?? 0));
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد وعد بالبيع')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات العقد', icon: Icons.assignment, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ الوعد'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
        ]),
        SectionCard(title: 'الأطراف', icon: Icons.people, children: [
          ArabicTextField(controller: _sellerCtrl, label: 'الواعد بالبيع', required: true),
          ArabicSwitch(label: 'يحمل وكالة', value: _sellerHasPoa, onChanged: (v) => setState(() => _sellerHasPoa = v)),
          ArabicTextField(controller: _buyerCtrl, label: 'الواعد بالشراء', required: true),
        ]),
        SectionCard(title: 'بيانات العقار', icon: Icons.home, children: [
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          ArabicSwitch(label: 'عليه حجز', value: _propHasSeizure, onChanged: (v) => setState(() => _propHasSeizure = v)),
          ArabicSwitch(label: 'عليه رهن', value: _propHasMortgage, onChanged: (v) => setState(() => _propHasMortgage = v)),
        ]),
        SectionCard(title: 'بيانات الثمن', icon: Icons.attach_money, children: [
          ArabicTextField(controller: _totalCtrl, label: 'الثمن الإجمالي المتفق عليه', required: true, type: TextInputType.number),
          ArabicTextField(controller: _depositCtrl, label: 'العربون المدفوع', type: TextInputType.number),
          ArabicTextField(controller: _finalDateCtrl, label: 'تاريخ إبرام العقد النهائي'),
          ArabicTextField(controller: _penaltyCtrl, label: 'الشرط الجزائي عند التراجع', type: TextInputType.number),
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
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
      ]),
    );
  }
}