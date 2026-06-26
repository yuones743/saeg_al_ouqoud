// (ملحق شامل)
import 'package:flutter/material.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.description, 'title': '١٢ قالب عقد', 'subtitle': 'قوالب جاهزة لجميع أنواع العقارات'},
      {'icon': Icons.calculate, 'title': 'حاسبة المواريث', 'subtitle': 'توزيع ٢٤٠٠ سهم بدقة عالية'},
      {'icon': Icons.warning_amber, 'title': '٢٦ تحذير قانوني', 'subtitle': 'تنبيهات إرشادية لا تمنع التوليد'},
      {'icon': Icons.checklist, 'title': '٧٧ سيناريو', 'subtitle': 'تغطية شاملة للحالات القانونية'},
      {'icon': Icons.picture_as_pdf, 'title': 'تصدير PDF', 'subtitle': 'عقد رسمي بإطار وتنسيق كامل'},
      {'icon': Icons.text_snippet, 'title': 'تصدير TXT', 'subtitle': 'نص مبسط قابل للنسخ'},
      {'icon': Icons.image, 'title': 'تصدير صورة', 'subtitle': 'للمشاركة السريعة'},
      {'icon': Icons.font_download, 'title': '٥ خطوط عربية', 'subtitle': 'Traditional Arabic, Amiri, Cairo, Noto Naskh, Lateef'},
      {'icon': Icons.straighten, 'title': '٣ أحجام ورق', 'subtitle': 'A4, A5, Letter'},
      {'icon': Icons.zoom_in, 'title': 'تكبير/تصغير الخط', 'subtitle': 'في شاشة المعاينة'},
      {'icon': Icons.edit, 'title': 'قالب فارغ', 'subtitle': 'للتعبئة بالقلم الأزرق'},
      {'icon': Icons.offline_bolt, 'title': 'أوفلاين ١٠٠٪', 'subtitle': 'لا حاجة للإنترنت'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('مميزات التطبيق')),
      body: GridView.count(
        padding: const EdgeInsets.all(12),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: features.map((f) => Card(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(f['icon'] as IconData, size: 36, color: const Color(0xFF1B4F72)),
                  const SizedBox(height: 8),
                  Text(f['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(f['subtitle'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center, maxLines: 3),
                ],
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
}