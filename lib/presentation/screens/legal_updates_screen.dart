import 'package:flutter/material.dart';

class LegalUpdatesScreen extends StatelessWidget {
  const LegalUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final updates = [
      {'date': '2026', 'title': 'تعميم 2026 حول الصورية', 'details': 'تعميم جديد لمكافحة عقود الصورية في البيوع العقارية'},
      {'date': '2021', 'title': 'قانون الاستثمار الجديد 18', 'details': 'تحديثات على إجراءات تملك الأجانب للعقارات'},
      {'date': '2018', 'title': 'قانون الأوقاف 31', 'details': 'تنظيم جديد للأوقاف وإدارتها'},
      {'date': '2018', 'title': 'قانون حماية القاصرين', 'details': 'تشديد الرقابة على أموال القاصرين'},
      {'date': '2004', 'title': 'قانون التنفيذ 30', 'details': 'إجراءات التنفيذ الجبري للأحكام'},
      {'date': '1953', 'title': 'قانون الأحوال الشخصية 59', 'details': 'القانون الناظم للزواج والطلاق والإرث'},
      {'date': '1949', 'title': 'القانون المدني 84', 'details': 'القانون الأساسي للعقود والملكية'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('التحديثات القانونية')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: updates.length,
        itemBuilder: (_, index) {
          final u = updates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFF1B4F72), child: Text(u['date']!.substring(2, 4), style: const TextStyle(color: Colors.white, fontSize: 11))),
              title: Text(u['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(u['details']!),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}