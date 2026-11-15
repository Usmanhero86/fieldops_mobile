import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../beneficiaries/presentation/screens/beneficiary_detail_page.dart';

class HouseholdBeneficiaryTile extends StatelessWidget {
  const HouseholdBeneficiaryTile({super.key, required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    bool isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
    final narrow = isNarrow(context);

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
              radius: narrow ? 20.0 : 23.0,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                b.initials,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: narrow ? 11 : 13,
                ),
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),

            // Name + vulnerability
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.fullName,
                    style: TextStyle(
                      fontSize: narrow ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${b.gender}  ·  Age ${b.age}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (b.vulnerabilityCategory.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      b.vulnerabilityCategory,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Household size badge + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00838F).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00838F).withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 13,
                        color: Color(0xFF00838F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${b.householdSize} people',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00838F),
                        ),
                      ),
                    ],
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
}
