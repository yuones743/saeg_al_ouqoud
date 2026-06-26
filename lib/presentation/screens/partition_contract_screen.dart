import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class PartitionContractScreen extends StatefulWidget {
  const PartitionContractScreen({super.key});

  @override
  State<PartitionContractScreen> createState() => _PartitionContractScreenState();
}

class _PartitionContractScreenState extends State<PartitionContractScreen> {
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _partiesCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();
  final _courtCtrl = TextEditingController();
  bool _isJudicial = false;
  bool _judgmentIsFinal = false;

  @override
  void dispose() {
    for (final c in [_dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _partiesCtrl, _sharesCtrl, _courtCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 'party_1', fullName: _partiesCtrl.text, role: PersonRole.seller));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, isCommonShare: true));
    provider.updatePayment(const Payment(totalPrice: 0));
    provider.updateJudgmentIsFinal(_isJudicial ? _judgmentIsFinal : false);
    if (_isJudicial) provider.setJudgment('', '', _courtCtrl.text);
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isJudicial ? 'قسمة قضائية' : 'قسمة رضائية')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات العقد', icon: Icons.assignment, children: [
          ArabicTextField(controller: _dateCtrl, label: 'تاريخ العقد'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
        ]),
        SectionCard(title: 'الأطراف والحصص', icon: Icons.pie_chart, children: [
          ArabicTextField(controller: _partiesCtrl, label: 'أسماء الأطراف', maxLines: 3),
          ArabicTextField(controller: _sharesCtrl, label: 'تفاصيل الحصص', maxLines: 3),
        ]),
        if (_isJudicial)
          SectionCard(title: 'بيانات الحكم', icon: Icons.gavel, children: [
            ArabicTextField(controller: _courtCtrl, label: 'المحكمة المصدِرة'),
            ArabicSwitch(label: 'الحكم مبرم (بات)', value: _judgmentIsFinal, onChanged: (v) => setState(() => _judgmentIsFinal = v)),
          ])
        else
          Padding(padding: const EdgeInsets.symmetric(vertical: 8),
            child: OutlinedButton.icon(icon: const Icon(Icons.gavel), label: const Text('تحويل إلى عقد قضائي'),
              onPressed: () => setState(() => _isJudicial = true))),
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص العقد', onPressed: _submit),
      ]),
    );
  }
}