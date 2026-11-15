import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';

/// Four-tile stats row: Beneficiaries · Communities · Activities · Pending Sync.
/// Each tile is tappable and fires its respective [onTap] callback.
class DashboardStatsRow extends StatelessWidget {
  const DashboardStatsRow({
    super.key,
    required this.beneficiaryCount,
    required this.communityCount,
    required this.activityCount,
    required this.pendingSync,
    this.onBeneficiariesTap,
    this.onCommunitiesTap,
    this.onActivitiesTap,
    this.onPendingSyncTap,
  });

  final int beneficiaryCount;
  final int communityCount;
  final int activityCount;
  final int pendingSync;

  final VoidCallback? onBeneficiariesTap;
  final VoidCallback? onCommunitiesTap;
  final VoidCallback? onActivitiesTap;
  final VoidCallback? onPendingSyncTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DashboardStatTile(
          value: '$beneficiaryCount',
          label: 'Beneficiaries',
          icon: Icons.people_outline,
          color: AppColors.primary,
          onTap: onBeneficiariesTap,
        ),
        const SizedBox(width: 10),
        DashboardStatTile(
          value: '$communityCount',
          label: 'Communities',
          icon: Icons.location_city_outlined,
          color: const Color(0xFF00838F),
          onTap: onCommunitiesTap,
        ),
        const SizedBox(width: 10),
        DashboardStatTile(
          value: '$activityCount',
          label: 'Activities',
          icon: Icons.assignment_outlined,
          color: AppColors.success,
          onTap: onActivitiesTap,
        ),
        const SizedBox(width: 10),
        DashboardStatTile(
          value: '$pendingSync',
          label: 'Pending Sync',
          icon: Icons.cloud_upload_outlined,
          color: pendingSync > 0 ? AppColors.warning : AppColors.textSecondary,
          highlight: pendingSync > 0,
          onTap: onPendingSyncTap,
        ),
      ],
    );
  }
}

/// Individual stat tile used inside [DashboardStatsRow].
/// Wraps content in an [InkWell] so it shows a ripple on tap.
class DashboardStatTile extends StatelessWidget {
  const DashboardStatTile({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.highlight = false,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: highlight
            ? AppColors.warning.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: highlight
                  ? Border.all(color: AppColors.warning.withValues(alpha: 0.35))
                  : Border.all(color: AppColors.border.withValues(alpha: 0.60)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: highlight
                        ? AppColors.warning
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                // Small chevron hint that the tile is tappable
                if (onTap != null) ...[
                  const SizedBox(height: 4),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 12,
                    color: color.withValues(alpha: 0.60),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
