import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/notification_service.dart';

class IssueReporterScreen extends StatefulWidget {
  const IssueReporterScreen({super.key});

  @override
  State<IssueReporterScreen> createState() => _IssueReporterScreenState();
}

class _IssueReporterScreenState extends State<IssueReporterScreen> {
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _category = 'bug';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإبلاغ عن مشكلة')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: _subjectCtrl, decoration: const InputDecoration(labelText: 'الموضوع', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: const InputDecoration(labelText: 'النوع', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'bug', child: Text('خلل برمجي')),
            DropdownMenuItem(value: 'improvement', child: Text('اقتراح تحسين')),
            DropdownMenuItem(value: 'question', child: Text('استفسار')),
            DropdownMenuItem(value: 'other', child: Text('أخرى')),
          ],
          onChanged: (v) { if (v != null) setState(() => _category = v); },
        ),
        const SizedBox(height: 8),
        TextField(controller: _bodyCtrl, maxLines: 6, decoration: const InputDecoration(labelText: 'التفاصيل', border: OutlineInputBorder()), textDirection: TextDirection.rtl),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('إرسال'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: 'الموضوع: ${_subjectCtrl.text}\nالفئة: $_category\n\n${_bodyCtrl.text}'));
            AppNotification.success(context, 'تم نسخ التقرير. يمكنك إرساله عبر البريد.');
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4F72), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ]),
    );
  }
}