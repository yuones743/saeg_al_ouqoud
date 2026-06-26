import 'package:flutter/material.dart';
import '../../core/scenarios/scenario_registry.dart';

class QuickReferenceScreen extends StatelessWidget {
  const QuickReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مرجع سريع للقوانين')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        _refSection('القانون المدني السوري', 'رقم 84 لعام 1949', 'ينظم العقود والملكية والالتزامات المدنية'),
        _refSection('قانون الأحوال الشخصية', 'رقم 59 لعام 1953', 'ينظم الزواج والطلاق والإرث والوصايا'),
        _refSection('قانون الرسوم العقارية', 'رقم 188 لعام 1924', 'ينظم رسوم نقل الملكية العقارية'),
        _refSection('قانون التجارة', 'رقم 33 لعام 1942', 'ينظم العقود التجارية والأوراق التجارية'),
        _refSection('قانون الرسوم القضائية', 'رقم 31 لعام 1955', 'ينظم رسوم المحاكم والقضاء'),
        _refSection('قانون إيجار العقارات', 'رقم 6 لعام 2001', 'ينظم عقود الإيجار'),
        _refSection('قانون الاستثمار', 'رقم 18 لعام 2021', 'ينظم استثمار رأس المال العربي والأجنبي'),
        _refSection('قانون حماية القاصرين', 'رقم 18 لعام 2021', 'حماية القاصرين وأموالهم'),
        _refSection('قانون الأوقاف', 'رقم 31 لعام 2018', 'الأوقاف وإدارتها'),
        _refSection('قانون التنفيذ', 'رقم 30 لعام 2004', 'التنفيذ الجبري للأحكام'),
        _refSection('المادة 558 مدني', 'عقد البيع', 'أركان البيع: الإيجاب والقبول والمبيع والثمن'),
        _refSection('المادة 837 مدني', 'الوكالة', 'شروط الوكالة وصحتها'),
        _refSection('المادة 182 أحوال', 'الوصية الواجبة', 'الوصية الواجبة لأولاد الابن المتوفى'),
        _refSection('المادة 28 أحوال', 'الحرمان من الإرث – قتل', 'من قتل مورثه عمداً حرم من الميراث'),
        _refSection('المادة 29 أحوال', 'الحرمان من الإرث – ردة', 'من ارتد عن الإسلام لا يرث'),
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('تنبيه مهم', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'هذا المرجع للاسترشاد فقط. يجب دائماً الرجوع إلى النصوص القانونية الأصلية والمحامين المختصين قبل اتخاذ أي إجراء قانوني.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('السيناريوهات المغطاة: ${ScenarioRegistry.all.length}'),
      ]),
    );
  }

  Widget _refSection(String title, String number, String note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.book, color: Color(0xFF1B4F72)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('$number\n$note', style: const TextStyle(fontSize: 11)),
        isThreeLine: true,
      ),
    );
  }
}