import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../beneficiaries/presentation/screens/beneficiary_detail_page.dart';

class DashboardBeneficiaryTile extends StatelessWidget {
  const DashboardBeneficiaryTile({super.key, required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    bool isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
    final narrow = isNarrow(context);
    (Color, String) syncColors(String status) => switch (status) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    final (dotColor, _) = syncColors(b.syncStatus);
    final avatarRadius = narrow ? 20.0 : 24.0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BeneficiaryDetailPage(beneficiary: b),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: narrow ? 10 : 14,
          vertical: narrow ? 10 : 12,
        ),
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
            // Avatar
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                b.initials,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: narrow ? 12 : 14,
                ),
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),

            // Name + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          b.fullName,
                          style: TextStyle(
                            fontSize: narrow ? 13 : 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${b.gender}  ·  ${b.community}, ${b.lga}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    b.vulnerabilityCategory.isEmpty
                        ? 'HH: ${b.householdSize}'
                        : '${b.vulnerabilityCategory}  ·  HH: ${b.householdSize}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Indicators + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (b.hasGps)
                      const Icon(
                        Icons.gps_fixed,
                        size: 13,
                        color: AppColors.success,
                      ),
                    if (b.hasGps && b.hasPhoto) const SizedBox(width: 4),
                    if (b.hasPhoto)
                      const Icon(
                        Icons.photo_camera_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  relativeDate(b.registeredAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
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
