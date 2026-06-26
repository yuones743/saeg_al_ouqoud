import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/services/export_service.dart';
import '../state/contract_provider.dart';
import '../widgets/notification_service.dart';
import 'export_options_screen.dart';

class ContractActionsScreen extends StatelessWidget {
  const ContractActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إجراءات العقد')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _actionTile(context, 'تصدير وتصدير العقود', Icons.share, Colors.blue, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportOptionsScreen()));
        }),
        _actionTile(context, 'معاينة نص العقد', Icons.preview, Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ContractPreviewScreen()));
        }),
        _actionTile(context, 'حفظ العقد', Icons.save, Colors.purple, () async {
          await context.read<ContractProvider>().saveContract();
          if (context.mounted) AppNotification.success(context, 'تم حفظ العقد بنجاح');
        }),
        _actionTile(context, 'حذف العقد الحالي', Icons.delete_outline, Colors.red, () async {
          context.read<ContractProvider>().reset();
          if (context.mounted) AppNotification.info(context, 'تم حذف العقد الحالي');
        }),
      ]),
    );
  }

  Widget _actionTile(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}