import 'package:flutter/material.dart';
import '../../core/config/system_config.dart';
import '../../domain/models/contract.dart';

class LawManagerScreen extends StatefulWidget {
  const LawManagerScreen({super.key});

  @override
  State<LawManagerScreen> createState() => _LawManagerScreenState();
}

class _LawManagerScreenState extends State<LawManagerScreen> {
  ContractType _selectedType = ContractType.directSale;
  final _titleCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _clauseCtrl = TextEditingController();

  void _addLaw() {
    if (_titleCtrl.text.trim().isNotEmpty &&
        _numberCtrl.text.trim().isNotEmpty &&
        _clauseCtrl.text.trim().isNotEmpty) {
      SystemConfig.addLawForType(
        _selectedType,
        _titleCtrl.text.trim(),
        _numberCtrl.text.trim(),
        _clauseCtrl.text.trim(),
      );
      _titleCtrl.clear();
      _numberCtrl.clear();
      _clauseCtrl.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة القانون بنجاح'), backgroundColor: Colors.green),
      );
    }
  }

  void _editLaw(int index) {
    final laws = SystemConfig.getLawsForType(_selectedType);
    if (index >= laws.length) return;
    final law = laws[index];
    _titleCtrl.text = law['title'] ?? '';
    _numberCtrl.text = law['number'] ?? '';
    _clauseCtrl.text = law['clause'] ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل القانون'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'عنوان القانون')),
            const SizedBox(height: 8),
            TextField(controller: _numberCtrl, decoration: const InputDecoration(labelText: 'رقم القانون')),
            const SizedBox(height: 8),
            TextField(controller: _clauseCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'نص البند')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              SystemConfig.removeLawForType(_selectedType, index);
              SystemConfig.addLawForType(_selectedType, _titleCtrl.text.trim(), _numberCtrl.text.trim(), _clauseCtrl.text.trim());
              _titleCtrl.clear(); _numberCtrl.clear(); _clauseCtrl.clear();
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث القانون'), backgroundColor: Colors.blue),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _removeLaw(int index) {
    final laws = SystemConfig.getLawsForType(_selectedType);
    if (index >= laws.length) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف القانون'),
        content: Text('هل أنت متأكد من حذف "${laws[index]['title']}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              SystemConfig.removeLawForType(_selectedType, index);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف القانون'), backgroundColor: Colors.red),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(ContractType type) {
    switch (type) {
      case ContractType.directSale: return 'بيع عقاري';
      case ContractType.usufructSale: return 'بيع انتفاع';
      case ContractType.commonShareSale: return 'بيع حصة شائعة';
      case ContractType.inheritanceAgreement: return 'إرث/اتفاق ورثة';
      case ContractType.partition: return 'قسمة';
      case ContractType.settlement: return 'صلح ووساطة';
      case ContractType.promise: return 'وعد بالبيع';
      case ContractType.judicialSale: return 'بيع قضائي';
      case ContractType.judicialInheritance: return 'حصر إرث قضائي';
      case ContractType.judicialPartition: return 'قسمة قضائية';
      case ContractType.judicialExit: return 'تخارج قضائي';
      case ContractType.complexProperty: return 'محضر متعدد الوحدات';
    }
  }

  @override
  Widget build(BuildContext context) {
    final laws = SystemConfig.getLawsForType(_selectedType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة القوانين'),
        backgroundColor: const Color(0xFF1B4F72),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('اختر نوع العقد:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ContractType>(
                    value: _selectedType,
                    items: ContractType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedType = v);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('إضافة قانون جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'عنوان القانون', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextField(controller: _numberCtrl, decoration: const InputDecoration(labelText: 'رقم القانون', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextField(controller: _clauseCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'نص البند', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _addLaw,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة قانون'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4F72),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text('القوانين المطبقة (${_getTypeLabel(_selectedType)}):', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),

          if (laws.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('لا توجد قوانين مضافة لهذا النوع.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...laws.asMap().entries.map((entry) {
              final index = entry.key;
              final law = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(law['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('رقم: ${law['number'] ?? ''}'),
                      Text('${law['clause'] ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editLaw(index)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removeLaw(index)),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber),
            ),
            child: const Text(
              'تنبيه: القوانين المضافة هنا ستظهر تلقائياً في عقود هذا النوع ضمن قسم "القوانين الواجبة التطبيق".',
              style: TextStyle(fontSize: 12, color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
