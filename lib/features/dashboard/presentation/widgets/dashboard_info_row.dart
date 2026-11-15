import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class DashboardInfoRow extends StatelessWidget {
  const DashboardInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    bool isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
    final narrow = isNarrow(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: narrow ? 80 : 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
