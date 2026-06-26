// (شاشات إضافية شاملة - الجزء الأخير)
import 'package:flutter/material.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دليل البدء السريع')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF1B4F72), child: Text('1', style: TextStyle(color: Colors.white))), title: Text('اختر نوع العقد'), subtitle: Text('من الصفحة الرئيسية، اختر نوع العقد المناسب لاحتياجك.'))),
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF1B4F72), child: Text('2', style: TextStyle(color: Colors.white))), title: Text('أدخل البيانات'), subtitle: Text('املأ حقول البيانات بشكل كامل ودقيق.'))),
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF1B4F72), child: Text('3', style: TextStyle(color: Colors.white))), title: Text('افحص العقد'), subtitle: Text('اضغط "فحص العقد" لمراجعة التحذيرات القانونية.'))),
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF1B4F72), child: Text('4', style: TextStyle(color: Colors.white))), title: Text('صدّر العقد'), subtitle: Text('اختر صيغة التصدير: PDF، TXT، أو صورة.'))),
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF1B4F72), child: Text('5', style: TextStyle(color: Colors.white))), title: Text('احفظ العقد'), subtitle: Text('احفظ العقد في قاعدة البيانات المحلية للرجوع إليه لاحقاً.'))),
        SizedBox(height: 16),
        Card(color: Color(0xFFE3F2FD), child: Padding(padding: EdgeInsets.all(12), child: Text('💡 نصيحة: يمكنك استخدام "معالج العقد السريع" لإنشاء عقد بخطوات مبسطة.', style: TextStyle(fontSize: 13)))),
      ]),
    );
  }
}