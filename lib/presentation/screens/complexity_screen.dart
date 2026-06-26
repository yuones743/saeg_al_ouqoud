import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/services/business_logic_service.dart';
import '../state/contract_provider.dart';

class ComplexityScreen extends StatelessWidget {
  const ComplexityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    final complexity = BusinessLogicService.calculateContractComplexity(contract);
    final level = BusinessLogicService.getComplexityLevel(complexity);
    final balancePercent = BusinessLogicService.calculateBalancePercentage(contract);
    final tax = BusinessLogicService.calculateTax(contract);

    return Scaffold(
      appBar: AppBar(title: const Text('تحليل العقد')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          color: const Color(0xFF1B4F72),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const Text('درجة التعقيد', style: TextStyle(color: Colors.white, fontSize: 14)),
              Text('$complexity', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              Text(level, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        _metricCard('نسبة المدفوع', '${balancePercent.toStringAsFixed(1)}%', Icons.percent, balancePercent >= 100 ? Colors.green : Colors.orange),
        _metricCard('الضريبة المستحقة', tax.toStringAsFixed(0), Icons.attach_money, Colors.blue),
        _metricCard('الرصيد المتبقي', BusinessLogicService.calculateRemainingBalance(contract).toStringAsFixed(0), Icons.account_balance_wallet, Colors.red),
      ]),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}