import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'dashboard_community_detail_page.dart';
import 'dashboard_stat_pill.dart';

class DashboardCommunityTile extends StatelessWidget {
  const DashboardCommunityTile({super.key, required this.community});
  final DummyCommunity community;
  bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;


  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardCommunityDetailPage(community: community),
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
          children: [
            // Icon container
            Container(
              width: narrow ? 38 : 44,
              height: narrow ? 38 : 44,
              decoration: BoxDecoration(
                color: const Color(0xFF00838F).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_city_outlined,
                color: const Color(0xFF00838F),
                size: narrow ? 18 : 22,
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),

            // Name + ward + LGA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: TextStyle(
                      fontSize: narrow ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    narrow
                        ? community.lga
                        : '${community.ward}  ·  ${community.lga} LGA',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Counts + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                DashboardStatPill(
                  icon: Icons.people_outline,
                  value: community.beneficiaryCount,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                DashboardStatPill(
                  icon: Icons.assignment_outlined,
                  value: community.activityCount,
                  color: AppColors.success,
                ),
                const SizedBox(height: 4),
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
}
