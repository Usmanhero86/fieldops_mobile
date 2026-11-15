import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class CaptureCard extends StatelessWidget {
  const CaptureCard({super.key,
    required this.icon,
    required this.label,
    required this.captured,
  });
  final IconData icon;
  final String label;
  final bool captured;

  @override
  Widget build(BuildContext context) {
    final color = captured ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            captured ? 'Captured' : 'Not captured',
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}