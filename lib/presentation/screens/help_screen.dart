import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دليل الاستخدام')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpSection(
            title: 'كيفية إنشاء عقد',
            steps: [
              'اختر نوع العقد من الصفحة الرئيسية.',
              'أدخل بيانات البائع والمشتري والعقار.',
              'اضغط "فحص العقد" لمراجعة التحذيرات القانونية.',
              'اضغط "معاينة العقد وتصديره" لتوليد PDF.',
              'اضغط "حفظ العقد" لحفظه في قاعدة البيانات.',
            ],
          ),
          _HelpSection(
            title: 'حاسبة المواريث',
            steps: [
              'افتح "اتفاق ورثة + حاسبة" من الصفحة الرئيسية.',
              'أدخل بيانات المتوفى وأضف الورثة مع تحديد صلة القرابة.',
              'اضغط "حساب الأسهم" لعرض التوزيع وفق 2400 سهم.',
              'يمكنك رؤية الملخص الكامل من أيقونة الملخص أعلى يسار الشاشة.',
            ],
          ),
          _HelpSection(
            title: 'التصدير والمشاركة',
            steps: [
              'PDF: الصيغة الرسمية الكاملة للعقد.',
              'TXT: نص مبسط للعقد.',
              'صورة PNG: للمشاركة السريعة.',
              'القالب الفارغ: للطباعة والكتابة بالقلم الأزرق.',
            ],
          ),
          _HelpSection(
            title: 'التحذيرات القانونية',
            steps: [
              'التحذيرات تظهر في شاشة الفحص فقط ولا تُطبع على العقد.',
              'يمكن توليد العقد في جميع الأحوال بغض النظر عن التحذيرات.',
              'التحذيرات للإرشاد فقط – القرار النهائي للمختص القانوني.',
            ],
          ),
          _HelpSection(
            title: 'الإعدادات',
            steps: [
              'يمكن تغيير خط العقد من القائمة الجانبية > الإعدادات.',
              'يمكن تغيير حجم الورقة (A4 / A5 / Letter).',
              'يمكن تكبير/تصغير الخط في شاشة المعاينة.',
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final String title;
  final List<String> steps;
  const _HelpSection({required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.help_outline),
        children: steps.asMap().entries.map((e) => ListTile(
          leading: CircleAvatar(radius: 12, child: Text('${e.key + 1}', style: const TextStyle(fontSize: 11))),
          title: Text(e.value, style: const TextStyle(fontSize: 13)),
          dense: true,
        )).toList(),
      ),
    );
  }
}
