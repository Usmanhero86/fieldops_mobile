import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class CaptureCard extends StatelessWidget {
  const CaptureCard({
    required this.icon,
    required this.label,
    required this.captured,
    super.key
  });
  final IconData icon;
  final String label;
  final bool captured;

  @override
  Widget build(BuildContext context) {
    final color = captured ? AppColors.success : AppColors.warning;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              captured ? '✓ Captured' : 'Not captured',
              style: TextStyle(fontSize: 10, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
