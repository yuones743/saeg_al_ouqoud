import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/contract_repository.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.backup, color: Colors.blue, size: 32),
            title: const Text('نسخ احتياطي'),
            subtitle: const Text('حفظ نسخة من جميع العقود كملف JSON'),
            trailing: ElevatedButton(
              onPressed: () => _backup(context),
              child: const Text('تصدير'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.restore, color: Colors.green, size: 32),
            title: const Text('استعادة'),
            subtitle: const Text('استرجاع العقود من ملف JSON'),
            trailing: ElevatedButton(
              onPressed: () => AppNotification.info(context, 'قريباً'),
              child: const Text('استيراد'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          color: Color(0xFFFEE),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text('النسخ الاحتياطي محلي فقط. لا يتم رفع البيانات لأي خادم.', style: TextStyle(fontSize: 12))),
            ]),
          ),
        ),
      ]),
    );
  }

  Future<void> _backup(BuildContext context) async {
    try {
      final contracts = await ContractRepository().loadAll();
      final json = contracts.map((c) => c.toMap()).toList();
      final str = json.toString();
      await Clipboard.setData(ClipboardData(text: str));
      if (context.mounted) AppNotification.success(context, 'تم نسخ ${contracts.length} عقد إلى الحافظة');
    } catch (e) {
      if (context.mounted) AppNotification.error(context, 'خطأ: $e');
    }
  }
}