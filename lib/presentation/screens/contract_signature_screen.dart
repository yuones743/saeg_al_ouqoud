import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';

class ContractSignatureScreen extends StatelessWidget {
  const ContractSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    return Scaffold(
      appBar: AppBar(title: const Text('التوقيعات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ContractTypeHelpers.getTitle(contract.type), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('بتاريخ: ${contract.contractDate}'),
              const SizedBox(height: 8),
              const Text('يتطلب القانون السوري وجود:', style: TextStyle(fontSize: 12)),
              const Text('• توقيع البائع والمشتري'),
              const Text('• شاهدين على الأقل'),
              const Text('• بصمة بالحبر (اختياري)'),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        _signatureBox('البائع', contract.sellers.isNotEmpty ? contract.sellers.first.fullName : 'غير محدد'),
        const SizedBox(height: 12),
        _signatureBox('المشتري', contract.buyers.isNotEmpty ? contract.buyers.first.fullName : 'غير محدد'),
        const SizedBox(height: 12),
        _signatureBox('الشاهد ١', contract.witnesses.isNotEmpty ? contract.witnesses.first.fullName : 'غير محدد'),
        const SizedBox(height: 12),
        _signatureBox('الشاهد ٢', contract.witnesses.length > 1 ? contract.witnesses[1].fullName : 'غير محدد'),
      ]),
    );
  }

  Widget _signatureBox(String label, String name) {
    return Card(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            const Center(child: Text('___________________', style: TextStyle(fontSize: 18))),
            const SizedBox(height: 4),
            const Center(child: Text('التوقيع والبصمة', style: TextStyle(fontSize: 10, color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}