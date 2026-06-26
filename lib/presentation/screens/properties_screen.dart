import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/property.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../state/contract_provider.dart';

class PropertyViewerScreen extends StatelessWidget {
  const PropertyViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final property = context.watch<ContractProvider>().contract.property;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل العقار')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('السجل العقاري', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Divider(),
                _row('رقم السجل', property.registryNumber.isEmpty ? '-' : property.registryNumber),
                _row('المنطقة العقارية', property.zone.isEmpty ? '-' : property.zone),
                _row('المخطط', property.planNumber.isEmpty ? '-' : property.planNumber),
                _row('القسيمة', property.plotNumber.isEmpty ? '-' : property.plotNumber),
                _row('المساحة', property.area > 0 ? '${ArabicTextHelpers.toArabicDigits(property.area)} م²' : '-'),
                _row('النوع', property.type.name),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('سند الملكية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Divider(),
                _row('رقم السند', property.ownershipDocNumber.isEmpty ? '-' : property.ownershipDocNumber),
                _row('تاريخ السند', property.ownershipDocDate.isEmpty ? '-' : property.ownershipDocDate),
                _row('مصدر السند', property.ownershipDocSource.isEmpty ? '-' : property.ownershipDocSource),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('الحدود', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Divider(),
                _row('الحدود العامة', property.boundaries.isEmpty ? '-' : property.boundaries),
                _row('شمالاً', property.northBoundary.isEmpty ? '-' : property.northBoundary),
                _row('جنوباً', property.southBoundary.isEmpty ? '-' : property.southBoundary),
                _row('شرقاً', property.eastBoundary.isEmpty ? '-' : property.eastBoundary),
                _row('غرباً', property.westBoundary.isEmpty ? '-' : property.westBoundary),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('الحالة القانونية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Divider(),
                _flag('عليه حجز', property.hasSeizure),
                _flag('عليه رهن', property.hasMortgage),
                _flag('يوجد كتاب فك', property.hasReleaseLetter),
                _flag('موقوف', property.isEndowment),
                _flag('مخالف', property.isViolation),
                _flag('حصة شائعة', property.isCommonShare),
                _flag('تحت الاستملاك', property.underExpropriation),
                _flag('عليه دعوى', property.hasActiveLawsuit),
                _flag('أرض أميرية', property.isAmiriaLand),
                _flag('مهر قاصر', property.isMinorsDowry),
                _flag('قانون الاستثمار', property.subjectToInvestmentLaw),
                _flag('مؤشرات صورية', property.hasShamIndicators),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _flag(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(value ? Icons.check_circle : Icons.cancel, color: value ? Colors.red : Colors.green, size: 16),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(value ? 'نعم' : 'لا', style: TextStyle(fontSize: 12, color: value ? Colors.red : Colors.green)),
        ],
      ),
    );
  }
}