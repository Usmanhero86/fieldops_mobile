import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class DashboardSectionLabel extends StatelessWidget {
  const DashboardSectionLabel(
      this.label, {
        super.key,
        this.uppercase = true,
      });

  final String label;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Text(
      uppercase ? label.toUpperCase() : label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: AppColors.textSecondary,
      ),
    );
  }
}
