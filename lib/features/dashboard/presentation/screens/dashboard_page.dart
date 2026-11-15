import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_my_tasks.dart';
import '../widgets/dashboard_project_card.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_activities.dart';
import '../widgets/dashboard_stats_row.dart';
import 'dashboard_activities_page.dart';
import 'dashboard_beneficiaries_page.dart';
import 'dashboard_communities_page.dart';
import 'dashboard_pending_sync_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final officer = kCurrentOfficer;
    final project = kCurrentProject;
    final recentActivities = activitiesForOfficer(officer.id).take(3).toList();
    final myBeneficiaries = beneficiariesForOfficer(officer.id);
    final pendingCount =
        myBeneficiaries.where((b) => b.syncStatus == 'pending').length +
        activitiesForOfficer(
          officer.id,
        ).where((a) => a.syncStatus == 'pending').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async =>
            await Future.delayed(const Duration(milliseconds: 600)),
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────────
            SliverToBoxAdapter(child: DashboardHeader(officer: officer)),

            // ── Project card ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: DashboardProjectCard(project: project),
              ),
            ),

            // ── Stats row ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: DashboardStatsRow(
                  beneficiaryCount: myBeneficiaries.length,
                  communityCount: communitiesForProject(project.id).length,
                  activityCount: activitiesForOfficer(officer.id).length,
                  pendingSync: pendingCount,
                  onBeneficiariesTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardBeneficiariesPage(),
                    ),
                  ),
                  onCommunitiesTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardCommunitiesPage(),
                    ),
                  ),
                  onActivitiesTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardActivitiesPage(),
                    ),
                  ),
                  onPendingSyncTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardPendingSyncPage(),
                    ),
                  ),
                ),
              ),
            ),

            // ── Quick actions ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const DashboardQuickActions(),
              ),
            ),

            // ── Recent activities ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: DashboardRecentActivities(activities: recentActivities),
              ),
            ),

            // My Tasks assigned by Supervisor/Admin
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: DashboardMyTasks(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
