import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../screens/dashboard_activities_page.dart';
import 'dashboard_count_chip.dart';

class DashboardListTile extends StatelessWidget {
  const DashboardListTile({super.key, required this.a});
  final DummyActivity a;
  bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;


  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final (badgeColor, badgeLabel) = switch (a.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardActivityDetailPage(activity: a),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(narrow ? 10 : 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: narrow ? 36 : 42,
              height: narrow ? 36 : 42,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: AppColors.success,
                size: narrow ? 17 : 20,
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.activityType,
                    style: TextStyle(
                      fontSize: narrow ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _fmtDate(a.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      DashboardCountChip(
                        icon: Icons.male,
                        value: a.maleCount,
                        color: AppColors.primary,
                      ),
                      DashboardCountChip(
                        icon: Icons.female,
                        value: a.femaleCount,
                        color: const Color(0xFFE91E63),
                      ),
                      DashboardCountChip(
                        icon: Icons.child_care,
                        value: a.childrenCount,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }
}
