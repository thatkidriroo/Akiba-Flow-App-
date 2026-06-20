import 'package:flutter/material.dart';

class BehaviorBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final Color textSecondary;
  final Color barBg;

  const BehaviorBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.textSecondary,
    required this.barBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: textSecondary)),
              Text('$value%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: barBg,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
