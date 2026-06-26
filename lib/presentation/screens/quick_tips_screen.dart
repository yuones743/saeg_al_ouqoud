import 'package:flutter/material.dart';

class QuickTipsScreen extends StatelessWidget {
  const QuickTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'عند بيع عقار به حجز قضائي، يجب الحصول على كتاب فك الحجز من المحكمة قبل البيع.',
      'البائع القاصر يحتاج إلى إذن من القاضي أو ولي الأمر.',
      'الوصية الواجبة (المادة 182) تطبق على أحفاد الابن المتوفى.',
      'الأراضي الأميرية تقسم بالتساوي بين الذكور والإناث.',
      'البائع المتوفى لا يبيع بنفسه – يُحضر محضر إرث.',
      'الوكيل لا يستطيع شراء العقار لنفسه بدون إذن صريح.',
      'عند وجود وريث حامل، يجب تأجيل القسمة حتى الولادة.',
      'القتل يمنع القاتل من الميراث شرعاً وقانونياً.',
      'الطلاق في مرض الموت يحفظ حق الزوجة في الميراث.',
      'العقد لا ينقل الملكية – يجب التسجيل في المصالح العقارية.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('نصائح قانونية سريعة')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tips.length,
        itemBuilder: (_, index) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFF1B4F72), child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 11))),
            title: Text(tips[index], style: const TextStyle(fontSize: 13)),
          ),
        ),
      ),
    );
  }
}