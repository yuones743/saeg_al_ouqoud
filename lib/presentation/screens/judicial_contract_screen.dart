import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class JudicialContractScreen extends StatefulWidget {
  const JudicialContractScreen({super.key});

  @override
  State<JudicialContractScreen> createState() => _JudicialContractScreenState();
}

class _JudicialContractScreenState extends State<JudicialContractScreen> {
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _judgmentNumCtrl = TextEditingController();
  final _judgmentDateCtrl = TextEditingController();
  final _judgmentCourtCtrl = TextEditingController();
  bool _judgmentIsFinal = false;
  bool _propHasSeizure = false;
  Currency _currency = Currency.syp;

  @override
  void dispose() {
    for (final c in [_sellerCtrl, _buyerCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _totalCtrl, _judgmentNumCtrl, _judgmentDateCtrl, _judgmentCourtCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 'seller_j1', fullName: _sellerCtrl.text.isEmpty ? 'البائع' : _sellerCtrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'buyer_j1', fullName: _buyerCtrl.text.isEmpty ? 'المشتري' : _buyerCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, hasSeizure: _propHasSeizure));
    final total = double.tryParse(_totalCtrl.text) ?? 0;
    provider.updatePayment(Payment(totalPrice: total, currency: _currency));
    provider.updateJudgmentIsFinal(_judgmentIsFinal);
    provider.setJudgment(_judgmentNumCtrl.text, _judgmentDateCtrl.text, _judgmentCourtCtrl.text);
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final type = context.read<ContractProvider>().contract.type;
    final title = type == ContractType.judicialExit ? 'عقد تخارج قضائي' : 'عقد بيع بموجب حكم قضائي';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات الحكم القضائي', icon: Icons.gavel, children: [
          ArabicTextField(controller: _judgmentNumCtrl, label: 'رقم الحكم', required: true),
          ArabicTextField(controller: _judgmentDateCtrl, label: 'تاريخ الحكم'),
          ArabicTextField(controller: _judgmentCourtCtrl, label: 'المحكمة المصدِرة'),
          ArabicSwitch(label: 'الحكم مبرم (بات)', value: _judgmentIsFinal, onChanged: (v) => setState(() => _judgmentIsFinal = v)),
        ]),
        SectionCard(title: 'بيانات العقد', icon: Icons.assignment, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ التنفيذ'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
        ]),
        SectionCard(title: 'الأطراف', icon: Icons.people, children: [
          ArabicTextField(controller: _sellerCtrl, label: 'البائع / المُخرَج'),
          ArabicTextField(controller: _buyerCtrl, label: 'المشتري / الراسي عليه'),
        ]),
        SectionCard(title: 'بيانات العقار', icon: Icons.home, children: [
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          ArabicSwitch(label: 'عليه حجز', value: _propHasSeizure, onChanged: (v) => setState(() => _propHasSeizure = v)),
        ]),
        SectionCard(title: 'بيانات الثمن', icon: Icons.attach_money, children: [
          ArabicTextField(controller: _totalCtrl, label: 'قيمة البيع / الثمن', type: TextInputType.number),
          Padding(padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<Currency>(
              value: _currency,
              decoration: const InputDecoration(labelText: 'العملة', border: OutlineInputBorder(), isDense: true),
              items: const [
                DropdownMenuItem(value: Currency.syp, child: Text('ليرة سورية (ل.س)')),
                DropdownMenuItem(value: Currency.usd, child: Text('دولار أمريكي')),
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