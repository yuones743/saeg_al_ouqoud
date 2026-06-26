import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  List<Contract> _results = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchCtrl.text.toLowerCase();
    final contracts = context.read<ContractProvider>().savedContracts;
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = contracts.where((c) {
        final seller = c.sellers.isNotEmpty ? c.sellers.first.fullName.toLowerCase() : '';
        final buyer = c.buyers.isNotEmpty ? c.buyers.first.fullName.toLowerCase() : '';
        final registry = c.property.registryNumber.toLowerCase();
        return seller.contains(query) || buyer.contains(query) || registry.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البحث في العقود')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchCtrl,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: 'ابحث باسم البائع أو المشتري أو رقم السجل',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: _results.isEmpty
            ? const Center(child: Text('لا توجد نتائج', style: TextStyle(color: Colors.grey)))
            : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, index) {
                  final c = _results[index];
                  final seller = c.sellers.isNotEmpty ? c.sellers.first.fullName : '-';
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      title: Text(seller, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('رقم: ${c.property.registryNumber}'),
                      trailing: Text(ArabicTextHelpers.toArabicDigits(c.payment.totalPrice.toInt())),
                    ),
                  );
                },
              ),
        ),
      ]),
    );
  }
}