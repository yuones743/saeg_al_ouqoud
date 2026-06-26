import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  const SectionCard({super.key, required this.title, this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18), const SizedBox(width: 6)],
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ArabicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final TextInputType type;
  final int maxLines;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  const ArabicTextField({super.key, required this.controller, required this.label, this.required = false, this.type = TextInputType.text, this.maxLines = 1, this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(labelText: required ? '$label *' : label, border: const OutlineInputBorder(), isDense: true),
        onChanged: onChanged,
        validator: validator ?? (required ? (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null : null),
      ),
    );
  }
}

class ArabicSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool dense;
  const ArabicSwitch({super.key, required this.label, required this.value, required this.onChanged, this.dense = true});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(title: Text(label, style: TextStyle(fontSize: dense ? 13 : 14)), value: value, onChanged: onChanged, dense: dense, contentPadding: EdgeInsets.zero);
  }
}

class PrimaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  const PrimaryActionButton({super.key, required this.icon, required this.label, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(backgroundColor: color ?? Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
      onPressed: onPressed,
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard({super.key, required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11)),
        ]),
      ),
    );
  }
}