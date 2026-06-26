// (ملحق - شاشات إضافية متقدمة)
import 'package:flutter/material.dart';

class AboutAdvancedScreen extends StatelessWidget {
  const AboutAdvancedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل تقنية')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('المواصفات التقنية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          _techRow('الإطار', 'Flutter 3.13.x'),
          _techRow('اللغة', 'Dart >=3.1.0'),
          _techRow('قاعدة البيانات', 'SQLite'),
          _techRow('توليد PDF', 'pdf 3.10.7'),
          _techRow('الطباعة', 'printing 5.11.1'),
          _techRow('المشاركة', 'share_plus 7.2.1'),
          _techRow('التشفير', 'crypto 3.0.3'),
          _techRow('إدارة الحالة', 'provider 6.1.1'),
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('الإحصائيات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          _techRow('عدد الشاشات', '٢٢'),
          _techRow('عدد القوالب', '١٢'),
          _techRow('عدد التحذيرات', '٢٦'),
          _techRow('عدد السيناريوهات', '٧٧'),
          _techRow('إجمالي الأسهم', '٢٤٠٠'),
          _techRow('الخطوط المدعومة', '٥'),
          _techRow('أحجام الورق', '٣'),
          _techRow('العملات المدعومة', '٦'),
          _techRow('المحافظات', '١٤'),
          _techRow('أنواع العقارات', '١٧'),
          _techRow('طرق الدفع', '٤'),
        ]))),
      ]),
    );
  }

  static Widget _techRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}