import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../../core/utils/contract_search.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';

class ContractsListScreen extends StatefulWidget {
  const ContractsListScreen({super.key});

  @override
  State<ContractsListScreen> createState() => _ContractsListScreenState();
}

class _ContractsListScreenState extends State<ContractsListScreen> {
  final _searchCtrl = TextEditingController();
  ContractType? _typeFilter;
  String _sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    final contracts = context.watch<ContractProvider>().savedContracts;
    var filtered = ContractSearch.search(contracts, _searchCtrl.text);
    if (_typeFilter != null) {
      filtered = ContractSearch.filterByType(filtered, _typeFilter!);
    }
    if (_sortBy == 'date') {
      filtered = ContractSearch.sortByDate(filtered);
    } else if (_sortBy == 'price') {
      filtered = ContractSearch.sortByPrice(filtered);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة العقود')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'بحث...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                value: _sortBy,
                decoration: const InputDecoration(labelText: 'ترتيب حسب', isDense: true),
                items: const [
                  DropdownMenuItem(value: 'date', child: Text('التاريخ')),
                  DropdownMenuItem(value: 'price', child: Text('السعر')),
                ],
                onChanged: (v) { if (v != null) setState(() => _sortBy = v); },
              )),
              const SizedBox(width: 8),
              Expanded(child: DropdownButtonFormField<String?>(
                value: _typeFilter?.name,
                decoration: const InputDecoration(labelText: 'النوع', isDense: true),
                items: [
                  const DropdownMenuItem(value: null, child: Text('الكل')),
                  ...ContractType.values.map((t) => DropdownMenuItem(value: t.name, child: Text(ContractTypeHelpers.getShortName(t), style: const TextStyle(fontSize: 12)))),
                ],
                onChanged: (v) {
                  setState(() => _typeFilter = v == null ? null : ContractType.values.firstWhere((t) => t.name == v));
                },
              )),
            ]),
          ]),
        ),
        Expanded(child: filtered.isEmpty
          ? const Center(child: Text('لا توجد عقود'))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final c = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(ArabicTextHelpers.toArabicDigits(index + 1), style: const TextStyle(fontSize: 11))),
                    title: Text(ContractTypeHelpers.getTitle(c.type), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${c.sellers.isNotEmpty ? c.sellers.first.fullName : "-"} – ${ArabicTextHelpers.toArabicDigits(c.payment.totalPrice.toInt())}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'open') {
                          context.read<ContractProvider>().reset();
                          // In a real app, we'd load the contract into provider
                          AppNotification.info(context, 'تم فتح العقد');
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'open', child: Text('فتح')),
                      ],
                    ),
                  ),
                );
              },
            )),
      ]),
    );
  }
}