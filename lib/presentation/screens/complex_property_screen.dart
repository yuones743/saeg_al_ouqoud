import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'warning_system_screen.dart';

class ComplexPropertyScreen extends StatefulWidget {
  const ComplexPropertyScreen({super.key});

  @override
  State<ComplexPropertyScreen> createState() => _ComplexPropertyScreenState();
}

class _ComplexPropertyScreenState extends State<ComplexPropertyScreen> {
  final _ownerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _buildingDescCtrl = TextEditingController();
  final List<_UnitEntry> _units = [];

  @override
  void dispose() {
    for (final c in [_ownerCtrl, _dateCtrl, _cityCtrl, _registryCtrl, _zoneCtrl, _buildingDescCtrl]) { c.dispose(); }
    for (final u in _units) { u.titleCtrl.dispose(); u.descCtrl.dispose(); u.areaCtrl.dispose(); }
    super.dispose();
  }

  void _addUnit() => setState(() => _units.add(_UnitEntry()));

  void _removeUnit(int index) {
    final u = _units[index];
    u.titleCtrl.dispose();
    u.descCtrl.dispose();
    u.areaCtrl.dispose();
    setState(() => _units.removeAt(index));
  }

  Future<void> _submit() async {
    final provider = context.read<ContractProvider>();
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 'owner_cp1', fullName: _ownerCtrl.text.isEmpty ? 'المالك' : _ownerCtrl.text, role: PersonRole.seller));
    provider.updateProperty(Property(registryNumber: _registryCtrl.text, zone: _zoneCtrl.text, type: PropertyType.multiUnit, description: _buildingDescCtrl.text));
    provider.updatePayment(const Payment(totalPrice: 0));
    provider.clearClauses();
    for (var i = 0; i < _units.length; i++) {
      final u = _units[i];
      provider.addClause(ContractClause(
        id: 'unit_${i + 1}',
        titleAr: u.titleCtrl.text.isEmpty ? 'وحدة ${i + 1}' : u.titleCtrl.text,
        bodyAr: 'المساحة: ${u.areaCtrl.text} م² – ${u.descCtrl.text}',
      ));
    }
    await provider.analyze();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WarningSystemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محضر عقاري متعدد الوحدات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SectionCard(title: 'بيانات المحضر', icon: Icons.apartment, children: [
          ArabicTextField(controller: _dateCtrl, label: 'التاريخ'),
          ArabicTextField(controller: _cityCtrl, label: 'المدينة', required: true),
          ArabicTextField(controller: _ownerCtrl, label: 'اسم المالك', required: true),
        ]),
        SectionCard(title: 'بيانات المبنى', icon: Icons.home, children: [
          ArabicTextField(controller: _registryCtrl, label: 'رقم السجل العقاري'),
          ArabicTextField(controller: _zoneCtrl, label: 'المنطقة العقارية'),
          ArabicTextField(controller: _buildingDescCtrl, label: 'وصف المبنى', maxLines: 3),
        ]),
        SectionCard(title: 'الوحدات العقارية', icon: Icons.layers, children: [
          ..._units.asMap().entries.map((e) => _unitTile(e.key, e.value)),
          TextButton.icon(icon: const Icon(Icons.add), label: const Text('إضافة وحدة'), onPressed: _addUnit),
        ]),
        const SizedBox(height: 24),
        PrimaryActionButton(icon: Icons.search, label: 'فحص المحضر', onPressed: _submit),
      ]),
    );
  }

  Widget _unitTile(int index, _UnitEntry entry) => Card(
    color: Colors.grey.shade100, margin: const EdgeInsets.only(bottom: 8),
    child: Padding(padding: const EdgeInsets.all(8),
      child: Column(children: [
        Row(children: [
          Expanded(child: ArabicTextField(controller: entry.titleCtrl, label: 'اسم الوحدة')),
          const SizedBox(width: 6),
          SizedBox(width: 80, child: ArabicTextField(controller: entry.areaCtrl, label: 'المساحة', type: TextInputType.number)),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => _removeUnit(index)),
        ]),
        ArabicTextField(controller: entry.descCtrl, label: 'الوصف', maxLines: 2),
      ])),
  );
}

class _UnitEntry {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
}