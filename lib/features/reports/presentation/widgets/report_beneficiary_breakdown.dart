import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/themes/app_colors.dart';
import 'report_screen_size.dart';
import 'report_shared_widgets.dart';

/// Card showing gender split, age-group distribution, and household data
/// for the selected project's beneficiaries.
class ReportBeneficiaryBreakdown extends StatelessWidget {
  const ReportBeneficiaryBreakdown({
    super.key,
    required this.beneficiaries,
    required this.screen,
  });

  final List<DummyBeneficiary> beneficiaries;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    if (beneficiaries.isEmpty) return const ReportEmptySection();

    final male = beneficiaries.where((b) => b.gender == 'Male').length;
    final female = beneficiaries.where((b) => b.gender == 'Female').length;
    final other = beneficiaries.length - male - female;
    final under18 = beneficiaries.where((b) => b.age < 18).length;
    final age1835 =
        beneficiaries.where((b) => b.age >= 18 && b.age <= 35).length;
    final age3660 =
        beneficiaries.where((b) => b.age >= 36 && b.age <= 60).length;
    final over60 = beneficiaries.where((b) => b.age > 60).length;
    final total = beneficiaries.length;
    final gap = screen == ReportScreenSize.narrow ? 8.0 : 10.0;

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gender ──────────────────────────────────────────────────────
          const ReportRowDivider(label: 'Gender'),
          const SizedBox(height: 10),
          Row(
            children: [
              ReportBreakdownTile(
                label: 'Female',
                count: female,
                total: total,
                color: const Color(0xFFE91E63),
                icon: Icons.female,
                screen: screen,
              ),
              SizedBox(width: gap),
              ReportBreakdownTile(
                label: 'Male',
                count: male,
                total: total,
                color: AppColors.primary,
                icon: Icons.male,
                screen: screen,
              ),
              if (other > 0) ...[
                SizedBox(width: gap),
                ReportBreakdownTile(
                  label: 'Other',
                  count: other,
                  total: total,
                  color: AppColors.textSecondary,
                  icon: Icons.person_outline,
                  screen: screen,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // ── Age groups — 2×2 on narrow, single row otherwise ────────────
          const ReportRowDivider(label: 'Age Groups'),
          const SizedBox(height: 10),
          screen == ReportScreenSize.narrow
              ? Column(
                  children: [
                    Row(
                      children: [
                        ReportBreakdownTile(
                          label: '< 18',
                          count: under18,
                          total: total,
                          color: AppColors.warning,
                          icon: Icons.child_care,
                          screen: screen,
                        ),
                        SizedBox(width: gap),
                        ReportBreakdownTile(
                          label: '18–35',
                          count: age1835,
                          total: total,
                          color: AppColors.success,
                          icon: Icons.person,
                          screen: screen,
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    Row(
                      children: [
                        ReportBreakdownTile(
                          label: '36–60',
                          count: age3660,
                          total: total,
                          color: AppColors.primary,
                          icon: Icons.person,
                          screen: screen,
                        ),
                        SizedBox(width: gap),
                        ReportBreakdownTile(
                          label: '60+',
                          count: over60,
                          total: total,
                          color: AppColors.error,
                          icon: Icons.elderly,
                          screen: screen,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    ReportBreakdownTile(
                      label: '< 18',
                      count: under18,
                      total: total,
                      color: AppColors.warning,
                      icon: Icons.child_care,
                      screen: screen,
                    ),
                    SizedBox(width: gap),
                    ReportBreakdownTile(
                      label: '18–35',
                      count: age1835,
                      total: total,
                      color: AppColors.success,
                      icon: Icons.person,
                      screen: screen,
                    ),
                    SizedBox(width: gap),
                    ReportBreakdownTile(
                      label: '36–60',
                      count: age3660,
                      total: total,
                      color: AppColors.primary,
                      icon: Icons.person,
                      screen: screen,
                    ),
                    SizedBox(width: gap),
                    ReportBreakdownTile(
                      label: '60+',
                      count: over60,
                      total: total,
                      color: AppColors.error,
                      icon: Icons.elderly,
                      screen: screen,
                    ),
                  ],
                ),
          const SizedBox(height: 16),

          // ── Household data — stack on narrow ────────────────────────────
          const ReportRowDivider(label: 'Household Data'),
          const SizedBox(height: 10),
          _householdRow(total),
        ],
      ),
    );
  }

  Widget _householdRow(int total) {
    final avgSize = beneficiaries.isEmpty
        ? '—'
        : (beneficiaries.map((b) => b.householdSize).reduce((a, b) => a + b) /
                beneficiaries.length)
            .toStringAsFixed(1);
    final gpsCount = beneficiaries.where((b) => b.hasGps).length;
    final photoCount = beneficiaries.where((b) => b.hasPhoto).length;

    if (screen == ReportScreenSize.narrow) {
      return Column(
        children: [
          Row(
            children: [
              ReportStatBox(
                label: 'Avg household size',
                value: avgSize,
                icon: Icons.home_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              ReportStatBox(
                label: 'With GPS',
                value: '$gpsCount/$total',
                icon: Icons.gps_fixed,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ReportStatBox(
                label: 'With photo',
                value: '$photoCount/$total',
                icon: Icons.photo_camera_outlined,
                color: const Color(0xFF00838F),
              ),
              // Spacer so the single box occupies ~half width
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        ReportStatBox(
          label: 'Avg household size',
          value: avgSize,
          icon: Icons.home_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        ReportStatBox(
          label: 'With GPS captured',
          value: '$gpsCount/$total',
          icon: Icons.gps_fixed,
          color: AppColors.success,
        ),
        const SizedBox(width: 10),
        ReportStatBox(
          label: 'With photo',
          value: '$photoCount/$total',
          icon: Icons.photo_camera_outlined,
          color: const Color(0xFF00838F),
        ),
      ],
    );
  }
}
