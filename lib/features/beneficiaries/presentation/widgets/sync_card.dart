import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (status) {
      'synced' => ('Synced', Icons.cloud_done_outlined, AppColors.success),
      'failed' => ('Sync failed', Icons.cloud_off_outlined, AppColors.error),
      _ => ('Pending sync', Icons.cloud_upload_outlined, AppColors.warning),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
