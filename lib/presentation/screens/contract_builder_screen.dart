import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/contract.dart';
import '../../domain/models/person.dart';
import '../../domain/models/property.dart';
import '../../domain/models/payment.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';

class ContractBuilderScreen extends StatefulWidget {
  final ContractType type;
  const ContractBuilderScreen({super.key, required this.type});

  @override
  State<ContractBuilderScreen> createState() => _ContractBuilderScreenState();
}

class _ContractBuilderScreenState extends State<ContractBuilderScreen> {
  final _sellerCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _propertyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منشئ العقد السريع')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF1B4F72),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('منشئ مبسط: أدخل البيانات الأساسية وسيتم إنشاء المسودة تلقائياً',
                style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 12),
          TextField(controller: _dateCtrl, decoration: const InputDecoration(labelText: 'تاريخ العقد', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 8),
          TextField(controller: _cityCtrl, decoration: const InputDecoration(labelText: 'المدينة', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 8),
          TextField(controller: _sellerCtrl, decoration: const InputDecoration(labelText: 'اسم البائع', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 8),
          TextField(controller: _buyerCtrl, decoration: const InputDecoration(labelText: 'اسم المشتري', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 8),
          TextField(controller: _propertyCtrl, decoration: const InputDecoration(labelText: 'رقم السجل العقاري', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 8),
          TextField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الثمن', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.create),
            label: const Text('إنشاء المسودة'),
            onPressed: () => _create(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4F72), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  void _create(BuildContext context) {
    final provider = context.read<ContractProvider>();
    provider.updateType(widget.type);
    provider.updateDate(_dateCtrl.text);
    provider.updateCity(_cityCtrl.text);
    provider.updateSeller(Person(id: 's', fullName: _sellerCtrl.text, role: PersonRole.seller));
    provider.updateBuyer(Person(id: 'b', fullName: _buyerCtrl.text, role: PersonRole.buyer));
    provider.updateProperty(Property(registryNumber: _propertyCtrl.text));
    provider.updatePayment(Payment(totalPrice: double.tryParse(_priceCtrl.text) ?? 0));
    AppNotification.success(context, 'تم إنشاء المسودة. أكمل البيانات في النموذج التفصيلي.');
    Navigator.pop(context);
  }
}