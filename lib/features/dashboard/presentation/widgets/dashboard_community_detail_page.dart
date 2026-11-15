import 'package:fieldops_mobile/features/dashboard/presentation/widgets/dashboard_info_row.dart';
import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'commmunity_house_holds_page.dart';
import 'community_beneficiaries_page.dart';
import 'dashboard_activity_tile.dart';
import 'dashboard_community_activity_page.dart';
import 'dashboard_divider.dart';
import 'dashboard_info_card.dart';
import 'dashboard_person_tile.dart';
import 'dashboard_section_label.dart';
import 'dashboard_stat_card.dart';

class DashboardCommunityDetailPage extends StatelessWidget {
  const DashboardCommunityDetailPage({super.key, required this.community});
  final DummyCommunity community;
  bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;


  @override
  Widget build(BuildContext context) {
    final c = community;
    final narrow = _isNarrow(context);
    EdgeInsets _rp(BuildContext ctx) {
      final w = MediaQuery.of(ctx).size.width;
      if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
      if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    final rp = _rp(context);
    final beneficiaries = beneficiariesForCommunity(c.name);
    final activities = activitiesForCommunity(c.name);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: const Color(0xFF00838F),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 52, 14),
              title: Text(
                c.name,
                style: TextStyle(
                  fontSize: narrow ? 14 : 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                color: const Color(0xFF00838F),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 14),
                child: Text(
                  '${c.ward}  ·  ${c.lga} LGA  ·  ${c.state}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: rp.copyWith(top: 16, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row — tappable; each opens its own list page ─
                  const DashboardSectionLabel('Overview'),                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          label: 'Beneficiaries',
                          value: '${c.beneficiaryCount}',
                          icon: Icons.people_outline,
                          color: AppColors.primary,
                          onTap: beneficiaries.isEmpty
                              ? null
                              : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommunityBeneficiariesPage(
                                community: c,
                                beneficiaries: beneficiaries,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          label: 'Activities',
                          value: '${c.activityCount}',
                          icon: Icons.assignment_outlined,
                          color: AppColors.success,
                          onTap: activities.isEmpty
                              ? null
                              : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashboardCommunityActivitiesPage(
                                community: c,
                                activities: activities,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          label: 'Households',
                          value: '${c.householdCount}',
                          icon: Icons.home_outlined,
                          color: const Color(0xFF00838F),
                          onTap: beneficiaries.isEmpty
                              ? null
                              : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommunityHouseholdsPage(
                                community: c,
                                beneficiaries: beneficiaries,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),                  const SizedBox(height: 16),

                  // ── Location card ────
                  const DashboardSectionLabel('Location'),                  const SizedBox(height: 10),
                  DashboardInfoCard(
                    children: [
                      DashboardInfoRow(
                        icon: Icons.near_me_outlined,
                        label: 'Ward',
                        value: c.ward,
                      ),
                      const DashboardDivider(),
                      DashboardInfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'LGA',
                        value: '${c.lga} LGA',
                      ),
                      const DashboardDivider(),
                      DashboardInfoRow(
                        icon: Icons.map_outlined,
                        label: 'State',
                        value: c.state,
                      ),
                     const DashboardDivider(),
                      DashboardInfoRow(
                        icon: Icons.gps_fixed,
                        label: 'Coordinates',
                        value:
                        '${c.latitude.toStringAsFixed(4)}, '
                            '${c.longitude.toStringAsFixed(4)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Beneficiaries list ─────────────────────────────────
                  if (beneficiaries.isNotEmpty) ...[
                    DashboardSectionLabel(
                      'Registered beneficiaries (${beneficiaries.length})',
                    ),
                    const SizedBox(height: 10),
                    ...beneficiaries.map(
                          (b) => DashboardPersonTile(
                        name: b.fullName,
                        sub: '${b.gender}  ·  Age ${b.age}',
                        initials: b.initials,
                        syncStatus: b.syncStatus,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Activities list ────────────────────────────────────
                  if (activities.isNotEmpty) ...[
                    DashboardSectionLabel('Logged activities (${activities.length})'),
                    const SizedBox(height: 10),
                    ...activities.map((a) => DashboardActivityTile(activity: a)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
