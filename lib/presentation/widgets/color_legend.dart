import 'package:flutter/material.dart';

class ColorLegend extends StatelessWidget {
  final List<LegendItem> items;
  const ColorLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items.map((item) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 4),
        Text(item.label, style: const TextStyle(fontSize: 11)),
      ])).toList(),
    );
  }
}

class LegendItem {
  final String label;
  final Color color;
  LegendItem({required this.label, required this.color});
}