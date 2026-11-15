import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/themes/app_colors.dart';
import 'report_screen_size.dart';
import 'report_shared_widgets.dart';

/// Table listing each community with beneficiary, activity, and household
/// counts plus a totals row.
///
/// On narrow screens the LGA column is hidden and shown as a subtitle inside
/// the community name cell to keep the numeric columns readable.
class ReportCommunityTable extends StatelessWidget {
  const ReportCommunityTable({
    super.key,
    required this.communities,
    required this.screen,
  });

  final List<DummyCommunity> communities;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) return const ReportEmptySection();

    final showLgaColumn = screen != ReportScreenSize.narrow;
    final nameFlex = showLgaColumn ? 3 : 4;

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                flex: nameFlex,
                child: const Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (showLgaColumn)
                const Expanded(
                  flex: 2,
                  child: Text(
                    'LGA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              for (final label in ['Benef.', 'Act.', 'HH'])
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.border, height: 1),

          // Data rows
          ...communities.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: nameFlex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (!showLgaColumn)
                          Text(
                            c.lga,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showLgaColumn)
                    Expanded(
                      flex: 2,
                      child: Text(
                        c.lga,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      '${c.beneficiaryCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${c.activityCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${c.householdCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),

          // Totals row
          Row(
            children: [
              Expanded(
                flex: nameFlex,
                child: const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (showLgaColumn) const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                child: Text(
                  '${communities.map((c) => c.beneficiaryCount).fold(0, (a, b) => a + b)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: Text(
                  '${communities.map((c) => c.activityCount).fold(0, (a, b) => a + b)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: Text(
                  '${communities.map((c) => c.householdCount).fold(0, (a, b) => a + b)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
