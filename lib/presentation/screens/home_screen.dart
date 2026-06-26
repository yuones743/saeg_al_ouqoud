import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/system_config.dart';
import '../../core/utils/arabic_text_helpers.dart';
import '../../domain/models/contract.dart';
import '../state/contract_provider.dart';
import '../widgets/arabic_widgets.dart';
import 'simple_contract_screen.dart';
import 'usufruct_contract_screen.dart';
import 'common_share_screen.dart';
import 'inheritance_contract_screen.dart';
import 'partition_contract_screen.dart';
import 'settlement_contract_screen.dart';
import 'promise_contract_screen.dart';
import 'judicial_contract_screen.dart';
import 'complex_property_screen.dart';
import 'file_manager_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'quick_contract_wizard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractProvider>().loadContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('صائغ العقود السوري'),
        actions: [
          IconButton(icon: const Icon(Icons.folder_open), tooltip: 'الملفات',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FileManagerScreen()))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _HeroCard(),
          const SizedBox(height: 12),
          _StatsRow(),
          const SizedBox(height: 16),
          _sectionHeader('الإجراءات السريعة'),
          _btn(context, 'معالج العقد السريع', Icons.flash_on, const Color(0xFFE67E22),
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickContractWizard()))),
          const SizedBox(height: 12),
          _sectionHeader('عقود البيع العقاري'),
          _gridBtn(context, 'بيع مباشر', Icons.home, Colors.blue, ContractType.directSale),
          _gridBtn(context, 'بيع انتفاع', Icons.layers, Colors.blueAccent, ContractType.usufructSale),
          _gridBtn(context, 'بيع حصة شائعة', Icons.share, Colors.indigo, ContractType.commonShareSale),
          const SizedBox(height: 12),
          _sectionHeader('عقود الإرث والتسوية'),
          _gridBtn(context, 'اتفاق ورثة + حاسبة', Icons.family_restroom, Colors.green, ContractType.inheritanceAgreement),
          _gridBtn(context, 'قسمة رضائية', Icons.pie_chart, Colors.teal, ContractType.partition),
          _gridBtn(context, 'صلح ووساطة', Icons.handshake, Colors.orange, ContractType.settlement),
          _gridBtn(context, 'وعد بالبيع', Icons.assignment, Colors.amber, ContractType.promise),
          const SizedBox(height: 12),
          _sectionHeader('العقود القضائية'),
          _gridBtn(context, 'بيع بحكم قضائي', Icons.gavel, Colors.red, ContractType.judicialSale),
          _gridBtn(context, 'حصر إرث قضائي', Icons.account_tree, Colors.deepOrange, ContractType.judicialInheritance),
          _gridBtn(context, 'قسمة قضائية', Icons.balance, Colors.brown, ContractType.judicialPartition),
          _gridBtn(context, 'تخارج قضائي', Icons.exit_to_app, Colors.grey, ContractType.judicialExit),
          const SizedBox(height: 12),
          _sectionHeader('المحاضر العقارية'),
          _gridBtn(context, 'محضر متعدد الوحدات', Icons.apartment, Colors.purple, ContractType.complexProperty),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.shade300)),
            child: const Row(children: [
              Icon(Icons.info, color: Colors.amber),
              SizedBox(width: 8),
              Expanded(child: Text('ملاحظة: التحذيرات تظهر داخل التطبيق فقط ولا تُطبع على العقد. يمكن توليد العقد في جميع الأحوال.', style: TextStyle(fontSize: 11, color: Colors.amber))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primary,
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.gavel, color: Colors.white, size: 36),
              SizedBox(height: 8),
              Text('صائغ العقود السوري', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('نظام قرارات قانونية أوفلاين', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          ListTile(leading: const Icon(Icons.help_outline), title: const Text('دليل الاستخدام'),
            onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())); }),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text('عن التطبيق'),
            onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())); }),
          ListTile(leading: const Icon(Icons.settings), title: const Text('الإعدادات'),
            onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); }),
          const Divider(),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(12),
            child: Text('الإصدار ${SystemConfig.appVersion}', style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center)),
        ]),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Row(children: [
      const Expanded(child: Divider(color: Colors.black26)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54))),
      const Expanded(child: Divider(color: Colors.black26)),
    ]),
  );

  Widget _gridBtn(BuildContext context, String label, IconData icon, Color color, ContractType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 11), alignment: Alignment.centerRight),
        onPressed: () {
          context.read<ContractProvider>().reset();
          context.read<ContractProvider>().updateType(type);
          Navigator.push(context, MaterialPageRoute(builder: (_) => _screenForType(type)));
        },
      ),
    );
  }

  Widget _btn(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 12), alignment: Alignment.centerRight),
        onPressed: onTap,
      ),
    );
  }

  Widget _screenForType(ContractType type) {
    switch (type) {
      case ContractType.usufructSale: return const UsufructContractScreen();
      case ContractType.commonShareSale: return const CommonShareScreen();
      case ContractType.inheritanceAgreement:
      case ContractType.judicialInheritance: return const InheritanceContractScreen();
      case ContractType.partition:
      case ContractType.judicialPartition: return const PartitionContractScreen();
      case ContractType.settlement: return const SettlementContractScreen();
      case ContractType.promise: return const PromiseContractScreen();
      case ContractType.judicialSale:
      case ContractType.judicialExit: return const JudicialContractScreen();
      case ContractType.complexProperty: return const ComplexPropertyScreen();
      default: return const SimpleContractScreen();
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B4F72), Color(0xFF2E86AB)], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('صائغ العقود السوري', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text('نظام قرارات قانونية – أوفلاين بالكامل', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ]),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractProvider>();
    return Row(children: [
      Expanded(child: StatCard(label: 'عقود محفوظة', value: ArabicTextHelpers.toArabicDigits(provider.savedContracts.length), icon: Icons.folder, color: Colors.blue)),
      const SizedBox(width: 8),
      Expanded(child: StatCard(label: 'قوالب جاهزة', value: '١٢', icon: Icons.description, color: Colors.green)),
      const SizedBox(width: 8),
      Expanded(child: StatCard(label: 'تحذيرات', value: '٢٦', icon: Icons.warning_amber, color: Colors.orange)),
    ]);
  }
}