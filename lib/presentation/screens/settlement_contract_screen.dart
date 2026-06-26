import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class SettlementContractScreen extends StatefulWidget {
  const SettlementContractScreen({super.key});

  @override
  State<SettlementContractScreen> createState() => _SettlementContractScreenState();
}

class _SettlementContractScreenState extends State<SettlementContractScreen> {
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _party1Ctrl = TextEditingController();
  final _party2Ctrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _termsCtrl = TextEditingController();
  final _mediatorCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _penaltyCtrl = TextEditingController();
  bool _hasMediator = false;
  bool _hasProperty = false;

  @override
  void dispose() {
    for (final c in [_dateCtrl, _cityCtrl, _party1Ctrl, _party2Ctrl, _subjectCtrl, _termsCtrl, _mediatorCtrl, _registryCtrl, _zoneCtrl, _penaltyCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 'party1_1', fullName: _party1Ctrl.text.isEmpty ? 'الطرف الأول' : _party1Ctrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'party2_1', fullName: _party2Ctrl.text.isEmpty ? 'الطرف الثاني' : _party2Ctrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, description: _subjectCtrl.text));
    provider.updatePayment(Payment(totalPrice: 0, penaltyAmount: double.tryParse(_penaltyCtrl.text) ?? 0));
    provider.addClause(ContractClause(id: 'settlement_terms', titleAr: 'بنود الصلح', bodyAr: _termsCtrl.text));
    if (_hasMediator && _mediatorCtrl.text.isNotEmpty) {
      provider.addWitness(Person(id: 'mediator_1', fullName: _mediatorCtrl.text, role: PersonRole.witness));
    }
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عقد صلح ووساطة')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات العقد', icon: Icons.handshake, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
        ]),
        SectionCard(title: 'الأطراف', icon: Icons.people, children: [
          ArabicTextField(controller: _party1Ctrl, label: 'الطرف الأول', required: true),
          ArabicTextField(controller: _party2Ctrl, label: 'الطرف الثاني', required: true),
        ]),
        SectionCard(title: 'موضوع الصلح', icon: Icons.subject, children: [
          ArabicTextField(controller: _subjectCtrl, label: 'موضوع النزاع', maxLines: 3),
          ArabicTextField(controller: _termsCtrl, label: 'بنود الاتفاق', maxLines: 5, required: true),
          ArabicTextField(controller: _penaltyCtrl, label: 'الشرط الجزائي عند الإخلال', type: TextInputType.number),
        ]),
        SectionCard(title: 'العقار (إن وجد)', icon: Icons.home, children: [
          ArabicSwitch(label: 'يتعلق بعقار', value: _hasProperty, onChanged: (v) => setState(() => _hasProperty = v)),
          if (_hasProperty) ...[
            ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
            ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          ],
        ]),
        SectionCard(title: 'الوساطة', icon: Icons.mediation, children: [
          ArabicSwitch(label: 'يوجد وسيط', value: _hasMediator, onChanged: (v) => setState(() => _hasMediator = v)),
          if (_hasMediator) ArabicTextField(controller: _mediatorCtrl, label: 'اسم الوسيط'),
        ]),
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
      ]),
    );
  }
}