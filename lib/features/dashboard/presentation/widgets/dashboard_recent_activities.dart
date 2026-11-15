import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/themes/app_colors.dart';
import 'dashboard_sync_badge.dart';

/// "RECENT ACTIVITIES" section header + list of [DashboardActivityCard]s.
class DashboardRecentActivities extends StatelessWidget {
  const DashboardRecentActivities({
    super.key,
    required this.activities,
  });

  final List<DummyActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'RECENT ACTIVITIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.activities),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...activities.map((a) => DashboardActivityCard(activity: a)),
      ],
    );
  }
}

/// Single activity list card with icon, type, location, participants, date
/// and a sync status badge.
class DashboardActivityCard extends StatelessWidget {
  const DashboardActivityCard({super.key, required this.activity});

  final DummyActivity activity;

  @override
  Widget build(BuildContext context) {
    final total = activity.totalParticipants;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Activity type + location + participants
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.community}, ${activity.lga}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$total participants',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Date + sync badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                relativeDate(activity.date),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              DashboardSyncBadge(status: activity.syncStatus),
            ],
          ),
        ],
      ),
    );
  }
}
