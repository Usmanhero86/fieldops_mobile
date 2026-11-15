import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'dashboard_stat_card.dart';
import 'house_hold_beneficiary_tile.dart';

class CommunityHouseholdsPage extends StatelessWidget {
  const CommunityHouseholdsPage({super.key,
    required this.community,
    required this.beneficiaries,
  });

  final DummyCommunity community;
  final List<DummyBeneficiary> beneficiaries;

  @override
  Widget build(BuildContext context) {
    EdgeInsets _rp(BuildContext ctx) {
      final w = MediaQuery.of(ctx).size.width;
      if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
      if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    bool isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
    final narrow = isNarrow(context);
    final rp = _rp(context);

    // Build summary stats
    final totalHH = community.householdCount;
    final avgSize = beneficiaries.isEmpty
        ? 0.0
        : beneficiaries.map((b) => b.householdSize).reduce((a, b) => a + b) /
        beneficiaries.length;
    final largestHH = beneficiaries.isEmpty
        ? 0
        : beneficiaries
        .map((b) => b.householdSize)
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            color: const Color(0xFF00838F),
            padding: EdgeInsets.fromLTRB(
              rp.horizontal / 2,
              MediaQuery.of(context).padding.top + 14,
              rp.horizontal / 2,
              18,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Households',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: narrow ? 17 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$totalHH households  ·  ${community.name}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: rp.copyWith(top: 16, bottom: 40),
              children: [
                // Summary stats
                Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        label: 'Total HH',
                        value: '$totalHH',
                        icon: Icons.home_outlined,
                        color: const Color(0xFF00838F),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DashboardStatCard(
                        label: 'Avg size',
                        value: avgSize.toStringAsFixed(1),
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DashboardStatCard(
                        label: 'Largest HH',
                        value: '$largestHH',
                        icon: Icons.family_restroom_outlined,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section label
                Text(
                  'REGISTERED BENEFICIARIES & HOUSEHOLD SIZE'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                // One tile per beneficiary showing their household size
                ...beneficiaries.map((b) => HouseholdBeneficiaryTile(b: b)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
