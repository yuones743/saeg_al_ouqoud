import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class UsufructContractScreen extends StatefulWidget {
  const UsufructContractScreen({super.key});

  @override
  State<UsufructContractScreen> createState() => _UsufructContractScreenState();
}

class _UsufructContractScreenState extends State<UsufructContractScreen> {
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _paidCtrl = TextEditingController();
  PropertyType _subType = PropertyType.rooftop;
  bool _isCommonShare = false;
  ExpenseAllocation _expenseAlloc = ExpenseAllocation.buyer;

  @override
  void dispose() {
    for (final c in [_sellerCtrl, _buyerCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _totalCtrl, _paidCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 's1', fullName: _sellerCtrl.text.isEmpty ? 'البائع' : _sellerCtrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'b1', fullName: _buyerCtrl.text.isEmpty ? 'المشتري' : _buyerCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, type: _subType, isCommonShare: _isCommonShare));
    final total = double.tryParse(_totalCtrl.text) ?? 0;
    final paid = double.tryParse(_paidCtrl.text) ?? 0;
    provider.updatePayment(Payment(totalPrice: total, paidAmount: paid, balance: total - paid, expenseAllocation: _expenseAlloc));
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد بيع حق انتفاع')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات العقد', icon: Icons.layers, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
          ArabicTextField(controller: _sellerCtrl, label: 'البائع (المنتفع البائع)'),
          ArabicTextField(controller: _buyerCtrl, label: 'المشتري (المنتفع الجديد)'),
        ]),
        SectionCard(title: 'بيانات العقار', icon: Icons.home, children: [
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          Padding(padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<PropertyType>(
              value: _subType,
              decoration: const InputDecoration(labelText: 'نوع الحق', border: OutlineInputBorder(), isDense: true),
              items: const [
                DropdownMenuItem(value: PropertyType.rooftop, child: Text('سطح')),
                DropdownMenuItem(value: PropertyType.basement, child: Text('قبو')),
                DropdownMenuItem(value: PropertyType.annex, child: Text('ملحق')),
                DropdownMenuItem(value: PropertyType.apartment, child: Text('شقة بالانتفاع')),
              ],
              onChanged: (v) => setState(() => _subType = v!),
            ),
          ),
          ArabicSwitch(label: 'حصة شائعة', value: _isCommonShare, onChanged: (v) => setState(() => _isCommonShare = v)),
        ]),
        SectionCard(title: 'بيانات الثمن', icon: Icons.attach_money, children: [
          ArabicTextField(controller: _totalCtrl, label: 'الثمن الإجمالي', required: true, type: TextInputType.number),
          ArabicTextField(controller: _paidCtrl, label: 'المبلغ المدفوع', type: TextInputType.number),
          Padding(padding: const EdgeInsets.only(bottom: 8),
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
          ),
        ]),
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
      ]),
    );
  }
}