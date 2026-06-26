import 'package:flutter/material.dart';

class RtlTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final TextInputType type;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const RtlTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.required = false,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: onChanged,
        validator: validator ?? (required ? (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null : null),
      ),
    );
  }
}