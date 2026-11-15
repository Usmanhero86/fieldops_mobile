import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';

/// Small coloured pill badge indicating a record's sync status.
///
/// Accepts `'synced'`, `'failed'`, or any other value (treated as `'pending'`).
class DashboardSyncBadge extends StatelessWidget {
  const DashboardSyncBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'synced' => ('Synced', AppColors.success),
      'failed' => ('Failed', AppColors.error),
      _ => ('Pending', AppColors.warning),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
