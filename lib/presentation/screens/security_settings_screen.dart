import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الأمان')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Card(
          color: Color(0xFFFEE),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(children: [
              Icon(Icons.security, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('البيانات محلياً فقط. لا يوجد اتصال بأي خادم.', style: TextStyle(fontSize: 12))),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('تشفير قاعدة البيانات'),
          subtitle: const Text('حماية إضافية للبيانات المحلية'),
          value: true,
          onChanged: (v) {},
        ),
        SwitchListTile(
          title: const Text('طلب كلمة مرور عند الفتح'),
          subtitle: const Text('حماية إضافية للوصول للتطبيق'),
          value: false,
          onChanged: (v) {},
        ),
        SwitchListTile(
          title: const Text('إخفاء البيانات الحساسة'),
          subtitle: const Text('إخفاء الأرقام الوطنية في المعاينة'),
          value: false,
          onChanged: (v) {},
        ),
        const SizedBox(height: 16),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('معلومات الأمان'),
          subtitle: Text('التطبيق يستخدم SQLite محلي مع تشفير SHA256 للسجلات.'),
        ),
      ]),
    );
  }
}