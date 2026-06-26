import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';

class ContractCompareScreen extends StatelessWidget {
  const ContractCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = context.watch<ContractProvider>().savedContracts;
    return Scaffold(
      appBar: AppBar(title: const Text('مقارنة العقود')),
      body: contracts.length < 2
        ? const Center(child: Padding(padding: EdgeInsets.all(24),
            child: Text('يجب وجود عقدين على الأقل لإجراء المقارنة.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey))))
        : ListView(padding: const EdgeInsets.all(12),
            children: contracts.map((c) {
              final t = ContractTypeHelpers.getTitle(c.type);
              final seller = c.sellers.isNotEmpty ? c.sellers.first.fullName : '-';
              final buyer = c.buyers.isNotEmpty ? c.buyers.first.fullName : '-';
              final price = ArabicTextHelpers.toArabicDigits(c.payment.totalPrice);
              return Card(child: ListTile(
                leading: CircleAvatar(child: Text(c.id.substring(0, 4), style: const TextStyle(fontSize: 10))),
                title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('بائع: $seller\nمشتري: $buyer\nالثمن: $price'),
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContractDetailScreen(contract: c)));
                },
              ));
            }).toList()),
    );
  }
}

class ContractDetailScreen extends StatelessWidget {
  final dynamic contract;
  const ContractDetailScreen({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل العقد')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('النوع: ${ContractTypeHelpers.getTitle(contract.type)}'),
        Text('التاريخ: ${contract.contractDate}'),
        Text('المكان: ${contract.city}'),
        const SizedBox(height: 12),
        Text('البائع: ${contract.sellers.isNotEmpty ? contract.sellers.first.fullName : "-"}'),
        Text('المشتري: ${contract.buyers.isNotEmpty ? contract.buyers.first.fullName : "-"}'),
        Text('العقار: ${contract.property.registryNumber}'),
        Text('الثمن: ${ArabicTextHelpers.toArabicDigits(contract.payment.totalPrice)}'),
      ]),
    );
  }
}