import 'package:flutter/material.dart';

class DashboardCountChip extends StatelessWidget {
  const DashboardCountChip({super.key,
    required this.icon,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 2),
      Text(
        '$value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    ],
  );
}
