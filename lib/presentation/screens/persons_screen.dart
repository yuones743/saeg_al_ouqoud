import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/person.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';

class PersonsViewerScreen extends StatelessWidget {
  const PersonsViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    return Scaffold(
      appBar: AppBar(title: const Text('الأطراف')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        if (contract.sellers.isNotEmpty) _partyCard('البائعون', contract.sellers),
        if (contract.buyers.isNotEmpty) _partyCard('المشترون', contract.buyers),
        if (contract.witnesses.isNotEmpty) _partyCard('الشهود', contract.witnesses),
        if (contract.heirs.isNotEmpty) _partyCard('الورثة', contract.heirs.map((h) => h.person).toList()),
      ]),
    );
  }

  Widget _partyCard(String title, List<Person> persons) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const Divider(),
          ...persons.map((p) => ListTile(
            leading: CircleAvatar(child: Text(p.fullName.isNotEmpty ? p.fullName[0] : '?')),
            title: Text(p.fullName.isEmpty ? 'بدون اسم' : p.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('الرقم الوطني: ${p.nationalId.isEmpty ? '-' : p.nationalId}\nالهاتف: ${p.phone.isEmpty ? '-' : p.phone}'),
            isThreeLine: true,
            dense: true,
          )),
        ]),
      ),
    );
  }
}