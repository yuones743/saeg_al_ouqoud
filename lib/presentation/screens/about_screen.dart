import 'package:flutter/material.dart';
import '../../core/config/system_config.dart';
import '../../core/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الهيدر
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B4F72), Color(0xFF2E86AB)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: const Column(children: [
              Icon(Icons.gavel, color: Colors.white, size: 56),
              SizedBox(height: 12),
              Text('صائغ العقود السوري', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('نظام قرارات قانونية أوفلاين', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ]),
          ),
          const SizedBox(height: 16),

          // معلومات عامة
          Card(
            child: Column(children: [
              _infoTile(Icons.verified, 'الإصدار', SystemConfig.appVersion),
              const Divider(height: 0),
              _infoTile(Icons.business, 'الجهة المطورة', SystemConfig.publisher),
              const Divider(height: 0),
              _infoTile(Icons.offline_bolt, 'وضع التشغيل', 'أوفلاين 100%'),
              const Divider(height: 0),
              _infoTile(Icons.phone_android, 'الجهاز المستهدف', 'Samsung A11 (armeabi-v7a 32-bit)'),
              const Divider(height: 0),
              _infoTile(Icons.android, 'نظام التشغيل', 'Android 5.0+ (API 21)'),
            ]),
          ),
          const SizedBox(height: 12),

          // المميزات
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('المميزات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  _featureTile(Icons.description, '12 قالب عقد جاهز'),
                  _featureTile(Icons.calculate, 'حاسبة مواريث 2400 سهم'),
                  _featureTile(Icons.warning_amber, '26 تحذير قانوني'),
                  _featureTile(Icons.picture_as_pdf, 'تصدير PDF / TXT / صورة'),
                  _featureTile(Icons.font_download, '5 خطوط عربية'),
                  _featureTile(Icons.straighten, 'A4 / A5 / Letter'),
                  _featureTile(Icons.edit, 'قالب فارغ للكتابة بالقلم'),
                  _featureTile(Icons.rtl_screenshot, 'دعم كامل لـ RTL'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // المراجع القانونية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('المراجع القانونية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  ...LegalReferences.syrianLaws.map((law) => ListTile(
                    leading: const Icon(Icons.book, size: 20),
                    title: Text(law['title'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('${law['number']} – ${law['note']}', style: const TextStyle(fontSize: 11)),
                    dense: true,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _infoTile(IconData icon, String label, String value) => ListTile(
    leading: Icon(icon, color: const Color(0xFF1B4F72)),
    title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
    trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    dense: true,
  );

  static Widget _featureTile(IconData icon, String text) => ListTile(
    leading: Icon(icon, color: Colors.green, size: 20),
    title: Text(text, style: const TextStyle(fontSize: 13)),
    dense: true,
  );
}
