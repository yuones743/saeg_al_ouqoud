import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';
import 'inheritance_calculator_screen.dart';

class InheritanceContractScreen extends StatefulWidget {
  const InheritanceContractScreen({super.key});

  @override
  State<InheritanceContractScreen> createState() => _InheritanceContractScreenState();
}

class _InheritanceContractScreenState extends State<InheritanceContractScreen> {
  final _deceasedNameCtrl = TextEditingController();
  final _deceasedFatherCtrl = TextEditingController();
  final _deceasedMotherCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();

  bool _isKalala = false;
  bool _propIsAmiriaLand = false;
  bool _willExceedsThird = false;
  bool _willHasHeirConsent = false;

  // ✅ الوصية الواجبة (المادة 182)
  bool _isObligatoryWill = false;
  bool _hasWill = false;

  final List<_HeirEntry> _heirs = [];

  @override
  void dispose() {
    for (final c in [_deceasedNameCtrl, _deceasedFatherCtrl, _deceasedMotherCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl]) {
      c.dispose();
    }
    for (final h in _heirs) {
      h.nameCtrl.dispose();
      h.sharesCtrl.dispose();
    }
    super.dispose();
  }

  void _addHeir() => setState(() => _heirs.add(_HeirEntry()));

  void _removeHeir(int index) {
    final e = _heirs[index];
    e.nameCtrl.dispose();
    e.sharesCtrl.dispose();
    setState(() => _heirs.removeAt(index));
  }

  void _pushDataToProvider() {
    final provider = context.read<ContractProvider>();

    provider.updateDeceased(
      Person(
        id: 'deceased_1',
        fullName: _deceasedNameCtrl.text,
        fatherName: _deceasedFatherCtrl.text,
        motherName: _deceasedMotherCtrl.text,
        role: PersonRole.heir,
        isDeceased: true,
      ),
    );
    provider.updateIsInheritance(true);

    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateProperty(Property(
      registryNumber: _registryCtrl.text.isEmpty ? 'إرث' : _registryCtrl.text,
      zone: _zoneCtrl.text,
      isAmiriaLand: _propIsAmiriaLand,
    ));
    provider.updatePayment(const Payment(totalPrice: 0));
    provider.updateKalala(_isKalala);
    provider.updateWillExceedsThird(_willExceedsThird);
    provider.updateWillHasHeirConsent(_willHasHeirConsent);
    provider.clearHeirs();

    for (var i = 0; i < _heirs.length; i++) {
      final entry = _heirs[i];
      provider.addHeir(Heir(
        person: Person(
          id: 'heir_$i',
          fullName: entry.nameCtrl.text,
          role: PersonRole.heir,
          isMinor: entry.isMinor,
          isMissing: entry.isMissing,
          isExpatriate: entry.isExpatriate,
        ),
        shares: int.tryParse(entry.sharesCtrl.text) ?? 0,
        isKiller: entry.isKiller,
        isApostate: entry.isApostate,
        isPrisoner: entry.isPrisoner,
        isIntersex: entry.isIntersex,
        isPregnant: entry.isPregnant,
        relation: entry.relation,
      ));
    }

    // ✅ إضافة الوصية الواجبة إلى الملاحظات
    if (_isObligatoryWill || _hasWill) {
      final notes = <String>[];
      if (_isObligatoryWill) notes.add('وصية واجبة (المادة 182) لأولاد الابن المتوفى');
      if (_hasWill) notes.add('يوجد وصية في التركة');
      provider.addClause(ContractClause(
        id: 'will_notes',
        titleAr: 'ملاحظات الوصية',
        bodyAr: notes.join(' - '),
      ));
    }
  }

  Future<void> _submit() async {
    _pushDataToProvider();
    await context.read<ContractProvider>().analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  void _openCalculator() {
    _pushDataToProvider();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const InheritanceCalculatorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عقد الإرث / اتفاق الورثة'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text('حاسبة الأسهم', style: TextStyle(color: Colors.white, fontSize: 12)),
            onPressed: _openCalculator,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'بيانات المتوفى',
            icon: Icons.person_off,
            children: [
              ArabicTextField(controller: _deceasedNameCtrl, label: 'اسم المتوفى', required: true),
              ArabicTextField(controller: _deceasedFatherCtrl, label: 'اسم الأب'),
              ArabicTextField(controller: _deceasedMotherCtrl, label: 'اسم الأم'),
              ArabicTextField(controller: _dateCtrl, label: 'تاريخ الوفاة / العقد'),
              ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
              ArabicSwitch(label: 'حالة كلالة (لا أولاد ولا والدين)', value: _isKalala, onChanged: (v) => setState(() => _isKalala = v)),
              ArabicSwitch(label: 'وصية تتجاوز الثلث', value: _willExceedsThird, onChanged: (v) => setState(() => _willExceedsThird = v)),
              if (_willExceedsThird) ArabicSwitch(label: 'موافقة الورثة على الوصية', value: _willHasHeirConsent, onChanged: (v) => setState(() => _willHasHeirConsent = v)),
              const Divider(),
              const Text('الوصية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              ArabicSwitch(label: 'يوجد وصية في التركة', value: _hasWill, onChanged: (v) => setState(() => _hasWill = v)),
              ArabicSwitch(label: 'وصية واجبة (المادة 182 - لأولاد الابن المتوفى)', value: _isObligatoryWill, onChanged: (v) => setState(() => _isObligatoryWill = v)),
            ],
          ),
          SectionCard(
            title: 'بيانات العقار',
            icon: Icons.home,
            children: [
              ArabicTextField(controller: _registryCtrl, label: 'رقم السجل'),
              ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
              ArabicSwitch(label: 'أرض أميرية (تساوي الذكور والإناث)', value: _propIsAmiriaLand, onChanged: (v) => setState(() => _propIsAmiriaLand = v)),
            ],
          ),
          SectionCard(
            title: 'الورثة',
            icon: Icons.people,
            children: [
              ..._heirs.asMap().entries.map((e) => _heirTile(e.key, e.value)),
              TextButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('إضافة وارث'),
                onPressed: _addHeir,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.pie_chart),
                  label: const Text('حساب الأسهم'),
                  onPressed: _openCalculator,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryActionButton(
                  icon: Icons.search,
                  label: 'فحص العقد',
                  onPressed: _submit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _heirTile(int index, _HeirEntry entry) => Card(
    color: Colors.grey.shade100,
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ArabicTextField(
                  controller: entry.nameCtrl,
                  label: 'اسم الوارث',
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 70,
                child: ArabicTextField(
                  controller: entry.sharesCtrl,
                  label: 'أسهم',
                  type: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _removeHeir(index),
              ),
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: entry.relation.isEmpty ? null : entry.relation,
            decoration: const InputDecoration(
              labelText: 'صلة القرابة',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'زوجة', child: Text('زوجة')),
              DropdownMenuItem(value: 'زوج', child: Text('زوج')),
              DropdownMenuItem(value: 'ابن', child: Text('ابن')),
              DropdownMenuItem(value: 'ابنة', child: Text('ابنة')),
              DropdownMenuItem(value: 'أب', child: Text('أب')),
              DropdownMenuItem(value: 'أم', child: Text('أم')),
              DropdownMenuItem(value: 'أخ شقيق', child: Text('أخ شقيق')),
              DropdownMenuItem(value: 'أخت شقيقة', child: Text('أخت شقيقة')),
              DropdownMenuItem(value: 'أخ لأب', child: Text('أخ لأب')),
              DropdownMenuItem(value: 'أخت لأب', child: Text('أخت لأب')),
              DropdownMenuItem(value: 'جد', child: Text('جد')),
              DropdownMenuItem(value: 'جدة', child: Text('جدة')),
              DropdownMenuItem(value: 'ابن ابن', child: Text('ابن ابن')),
              DropdownMenuItem(value: 'بنت ابن', child: Text('بنت ابن')),
              DropdownMenuItem(value: 'عم', child: Text('عم')),
              DropdownMenuItem(value: 'ابن عم', child: Text('ابن عم')),
            ],
            onChanged: (v) => setState(() => entry.relation = v ?? ''),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 0,
            children: [
              _hSw('قاصر', entry.isMinor, (v) => setState(() => entry.isMinor = v)),
              _hSw('مغترب', entry.isExpatriate, (v) => setState(() => entry.isExpatriate = v)),
              _hSw('مفقود', entry.isMissing, (v) => setState(() => entry.isMissing = v)),
              _hSw('أسير', entry.isPrisoner, (v) => setState(() => entry.isPrisoner = v)),
              _hSw('خنثى', entry.isIntersex, (v) => setState(() => entry.isIntersex = v)),
              _hSw('حامل', entry.isPregnant, (v) => setState(() => entry.isPregnant = v)),
              _hSw('قاتل', entry.isKiller, (v) => setState(() => entry.isKiller = v)),
              _hSw('مرتد', entry.isApostate, (v) => setState(() => entry.isApostate = v)),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _hSw(String label, bool value, ValueChanged<bool> onChanged) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Transform.scale(scale: 0.8, child: Switch(value: value, onChanged: onChanged)),
      Text(label, style: const TextStyle(fontSize: 11)),
      const SizedBox(width: 4),
    ],
  );
}

class _HeirEntry {
  final nameCtrl = TextEditingController();
  final sharesCtrl = TextEditingController();
  String relation = '';
  bool isMinor = false;
  bool isExpatriate = false;
  bool isMissing = false;
  bool isPrisoner = false;
  bool isIntersex = false;
  bool isPregnant = false;
  bool isKiller = false;
  bool isApostate = false;
}
