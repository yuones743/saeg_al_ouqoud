import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/contract_type_helpers.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';

class ContractPreviewScreen extends StatelessWidget {
  const ContractPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = context.watch<ContractProvider>().contract;
    return Scaffold(
      appBar: AppBar(title: const Text('معاينة نص العقد')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('العنوان', ContractTypeHelpers.getTitle(contract.type), isHeader: true),
          _buildSection('التاريخ والمكان', '${contract.contractDate} – ${contract.city} – ${contract.governorate}'),
          if (contract.sellers.isNotEmpty)
            _buildSection('البائع', _personSummary(contract.sellers.first)),
          if (contract.buyers.isNotEmpty)
            _buildSection('المشتري', _personSummary(contract.buyers.first)),
          _buildSection('العقار', _propertySummary(contract.property)),
          if (ContractTypeHelpers.requiresPayment(contract.type))
            _buildSection('الثمن', _paymentSummary(contract.payment)),
          if (contract.heirs.isNotEmpty)
            _buildSection('الورثة', '${contract.heirs.length} وارث'),
          _buildSection('الشهود', '${contract.witnesses.length} شاهد'),
          _buildSection('البنود الإضافية', '${contract.customClauses.length} بند'),
          _buildSection('الملاحق', '${contract.annexes.length} ملحق'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
            child: const Text('ملاحظة: التحذيرات لا تظهر في العقد النهائي.', style: TextStyle(fontSize: 12, color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isHeader = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFF1B4F72) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isHeader ? const Color(0xFF1B4F72) : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isHeader ? Colors.white : Colors.black87)),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(fontSize: 13, color: isHeader ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  String _personSummary(person) {
    if (person == null) return 'غير محدد';
    return '${person.fullName} بن ${person.fatherName} – ${person.nationalId}';
  }

  String _propertySummary(property) {
    return 'رقم: ${property.registryNumber} – منطقة: ${property.zone} – نوع: ${ContractTypeHelpers.getPropertyTypeAr(property.type)}';
  }

  String _paymentSummary(payment) {
    return 'الثمن: ${ArabicTextHelpers.toArabicDigits(payment.totalPrice)} ${ContractTypeHelpers.getCurrencyAr(payment.currency)} – مدفوع: ${ArabicTextHelpers.toArabicDigits(payment.paidAmount)}';
  }
}