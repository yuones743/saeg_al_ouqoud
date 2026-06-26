import 'package:flutter/material.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../../domain/models/contract.dart';

class ContractTypesInfoScreen extends StatelessWidget {
  const ContractTypesInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final types = ContractType.values;
    return Scaffold(
      appBar: AppBar(title: const Text('أنواع العقود (١٢)')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: types.length,
        itemBuilder: (_, index) {
          final type = types[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFF1B4F72), child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
              title: Text(ContractTypeHelpers.getTitle(type), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(ContractTypeHelpers.getShortName(type)),
            ),
          );
        },
      ),
    );
  }
}