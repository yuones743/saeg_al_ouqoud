import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class CommonShareScreen extends StatefulWidget {
  const CommonShareScreen({super.key});

  @override
  State<CommonShareScreen> createState() => _CommonShareScreenState();
}

class _CommonShareScreenState extends State<CommonShareScreen> {
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _numeratorCtrl = TextEditingController(text: '1');
  final _denominatorCtrl = TextEditingController(text: '4');
  final _totalCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [_sellerCtrl, _buyerCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _numeratorCtrl, _denominatorCtrl, _totalCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 's1', fullName: _sellerCtrl.text.isEmpty ? 'البائع' : _sellerCtrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'b1', fullName: _buyerCtrl.text.isEmpty ? 'المشتري' : _buyerCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(
      registryNumber: _registryCtrl.text, zone: _zoneCtrl.text,
      isCommonShare: true,
      commonShareNumerator: double.tryParse(_numeratorCtrl.text) ?? 1,
      commonShareDenominator: double.tryParse(_denominatorCtrl.text) ?? 1,
    ));
    provider.updatePayment(Payment(totalPrice: double.tryParse(_totalCtrl.text) ?? 0));
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد بيع حصة شائعة')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات العقد', icon: Icons.share, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
          ArabicTextField(controller: _sellerCtrl, label: 'البائع'),
          ArabicTextField(controller: _buyerCtrl, label: 'المشتري'),
        ]),
        SectionCard(title: 'العقار والحصة', icon: Icons.crop_square, children: [
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: ArabicTextField(controller: _numeratorCtrl, label: 'البسط', type: TextInputType.number)),
            const SizedBox(width: 8),
            const Text('/', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(child: ArabicTextField(controller: _denominatorCtrl, label: 'المقام', type: TextInputType.number)),
          ]),
        ]),
        SectionCard(title: 'الثمن', icon: Icons.attach_money, children: [
          ArabicTextField(controller: _totalCtrl, label: 'ثمن الحصة', required: true, type: TextInputType.number),
        ]),
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
      ]),
    );
  }
}