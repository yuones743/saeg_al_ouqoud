import 'package:flutter/material.dart';
import '../../core/config/system_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ContractFontFamily _font = SystemConfig.contractFont;
  ContractPageFormat _format = SystemConfig.pageFormat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── قسم خط العقد ───
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('خط العقد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  ...ContractFontFamily.values.map((f) => RadioListTile<ContractFontFamily>(
                    title: Text(_fontName(f)),
                    subtitle: Text('معاينة بالعربية: ${_fontPreview(f)}', style: const TextStyle(fontFamily: null)),
                    value: f,
                    groupValue: _font,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _font = v;
                          SystemConfig.setContractFont(v);
                        });
                      }
                    },
                    dense: true,
                  )),
                ],
              ),
            ),
          ),

          // ─── قسم حجم الورقة ───
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('حجم الورقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  ...ContractPageFormat.values.map((f) => RadioListTile<ContractPageFormat>(
                    title: Text(_formatName(f)),
                    value: f,
                    groupValue: _format,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _format = v;
                          SystemConfig.setPageFormat(v);
                        });
                      }
                    },
                    dense: true,
                  )),
                ],
              ),
            ),
          ),

          // ─── قسم المواصفات التقنية (من AboutAdvancedScreen) ───
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المواصفات التقنية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildTechRow('الإطار', 'Flutter 3.13.x'),
                  _buildTechRow('اللغة', 'Dart >=3.1.0'),
                  _buildTechRow('قاعدة البيانات', 'SQLite'),
                  _buildTechRow('توليد PDF', 'pdf 3.10.7'),
                  _buildTechRow('الطباعة', 'printing 5.11.1'),
                  _buildTechRow('المشاركة', 'share_plus 7.2.1'),
                  _buildTechRow('التشفير', 'crypto 3.0.3'),
                  _buildTechRow('إدارة الحالة', 'provider 6.1.1'),
                ],
              ),
            ),
          ),

          // ─── قسم الإحصائيات (من AboutAdvancedScreen) ───
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الإحصائيات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildTechRow('عدد الشاشات', '٢٢'),
                  _buildTechRow('عدد القوالب', '١٢'),
                  _buildTechRow('عدد التحذيرات', '٢٦'),
                  _buildTechRow('عدد السيناريوهات', '٧٧'),
                  _buildTechRow('إجمالي الأسهم', '٢٤٠٠'),
                  _buildTechRow('الخطوط المدعومة', '٥'),
                  _buildTechRow('أحجام الورق', '٣'),
                  _buildTechRow('العملات المدعومة', '٦'),
                  _buildTechRow('المحافظات', '١٤'),
                  _buildTechRow('أنواع العقارات', '١٧'),
                  _buildTechRow('طرق الدفع', '٤'),
                ],
              ),
            ),
          ),

          // ─── معلومات إضافية ───
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('معلومات التطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('الإصدار'),
                    trailing: Text(SystemConfig.appVersion),
                    dense: true,
                  ),
                  const ListTile(
                    leading: Icon(Icons.offline_bolt),
                    title: Text('وضع العمل'),
                    trailing: Text('أوفلاين 100%'),
                    dense: true,
                  ),
                  const ListTile(
                    leading: Icon(Icons.phone_android),
                    title: Text('الجهاز المستهدف'),
                    trailing: Text('Samsung A11 (32-bit)'),
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── دوال مساعدة ───

  // دالة لعرض صف تقني (بدون const لتفادي الأخطاء)
  Widget _buildTechRow(String label, String value) {
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

  String _fontName(ContractFontFamily f) {
    switch (f) {
      case ContractFontFamily.traditionalArabic: return 'Traditional Arabic';
      case ContractFontFamily.amiri: return 'Amiri';
      case ContractFontFamily.cairo: return 'Cairo';
      case ContractFontFamily.notoNaskh: return 'Noto Naskh Arabic';
      case ContractFontFamily.lateef: return 'Lateef';
    }
  }

  String _fontPreview(ContractFontFamily f) {
    switch (f) {
      case ContractFontFamily.traditionalArabic: return 'عقد بيع عقار';
      case ContractFontFamily.amiri: return 'عقد بيع عقار';
      case ContractFontFamily.cairo: return 'عقد بيع عقار';
      case ContractFontFamily.notoNaskh: return 'عقد بيع عقار';
      case ContractFontFamily.lateef: return 'عقد بيع عقار';
    }
  }

  String _formatName(ContractPageFormat f) {
    switch (f) {
      case ContractPageFormat.a4: return 'A4';
      case ContractPageFormat.a5: return 'A5';
      case ContractPageFormat.letter: return 'Letter';
    }
  }
}
