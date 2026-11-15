import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/themes/app_colors.dart';
import 'report_screen_size.dart';
import 'report_shared_widgets.dart';

/// Card showing total sessions, participant counts by gender/age,
/// and a breakdown by activity type.
class ReportActivitySummary extends StatelessWidget {
  const ReportActivitySummary({
    super.key,
    required this.activities,
    required this.screen,
  });

  final List<DummyActivity> activities;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) return const ReportEmptySection();

    final totalParticipants =
        activities.map((a) => a.totalParticipants).fold(0, (a, b) => a + b);
    final totalMale =
        activities.map((a) => a.maleCount).fold(0, (a, b) => a + b);
    final totalFemale =
        activities.map((a) => a.femaleCount).fold(0, (a, b) => a + b);
    final totalChildren =
        activities.map((a) => a.childrenCount).fold(0, (a, b) => a + b);

    final Map<String, int> typeCount = {};
    for (final a in activities) {
      typeCount[a.activityType] = (typeCount[a.activityType] ?? 0) + 1;
    }

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Totals — always 2 columns
          Row(
            children: [
              ReportStatBox(
                label: 'Total sessions',
                value: '${activities.length}',
                icon: Icons.assignment_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              ReportStatBox(
                label: 'Total participants',
                value: '$totalParticipants',
                icon: Icons.groups_outlined,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Participant gender/age — 2×2 on narrow, 3-col on normal+
          screen == ReportScreenSize.narrow
              ? Column(
                  children: [
                    Row(
                      children: [
                        ReportStatBox(
                          label: 'Male',
                          value: '$totalMale',
                          icon: Icons.male,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        ReportStatBox(
                          label: 'Female',
                          value: '$totalFemale',
                          icon: Icons.female,
                          color: const Color(0xFFE91E63),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ReportStatBox(
                          label: 'Children',
                          value: '$totalChildren',
                          icon: Icons.child_care,
                          color: AppColors.warning,
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    ReportStatBox(
                      label: 'Male participants',
                      value: '$totalMale',
                      icon: Icons.male,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    ReportStatBox(
                      label: 'Female participants',
                      value: '$totalFemale',
                      icon: Icons.female,
                      color: const Color(0xFFE91E63),
                    ),
                    const SizedBox(width: 10),
                    ReportStatBox(
                      label: 'Children',
                      value: '$totalChildren',
                      icon: Icons.child_care,
                      color: AppColors.warning,
                    ),
                  ],
                ),
          const SizedBox(height: 16),

          const ReportRowDivider(label: 'By Activity Type'),
          const SizedBox(height: 12),

          ...typeCount.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${e.value} session${e.value == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
