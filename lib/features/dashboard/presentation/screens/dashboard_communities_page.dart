import 'package:fieldops_mobile/features/dashboard/presentation/widgets/dashboard_community_tile.dart';
import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../features/communities/presentation/screens/community_registration_page.dart';
import '../widgets/dashboard_empty_state.dart';
import '../widgets/dashboard_page_header.dart';

// Responsive helpers
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;

EdgeInsets _rp(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
  if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
  return const EdgeInsets.symmetric(horizontal: 16);
}

/// List of communities for the current project.
/// Tapping a tile opens [DashboardCommunityDetailPage].

class DashboardCommunitiesPage extends StatefulWidget {
  const DashboardCommunitiesPage({super.key});

  @override
  State<DashboardCommunitiesPage> createState() =>
      _DashboardCommunitiesPageState();
}

class _DashboardCommunitiesPageState
    extends State<DashboardCommunitiesPage> {

  @override
  Widget build(BuildContext context) {
    final communities = communitiesForProject(kCurrentProject.id);
    final narrow = _isNarrow(context);
    final rp = _rp(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          // Reusable header
          DashboardPageHeader(
            title: 'Communities',
            subtitle:
            '${communities.length} communities  ·  '
                '${kCurrentProject.name}',
          ),

          // Communities list
          Expanded(
            child: communities.isEmpty
                ? const DashboardEmptyState(
              message: 'No communities found',
              icon: Icons.location_city_outlined,
            )
                : _isWide(context)
                ? GridView.builder(
              padding: rp.copyWith(
                top: 16,
                bottom: 40,
              ),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 10,
                childAspectRatio: 2.6,
              ),
              itemCount: communities.length,
              itemBuilder: (_, i) =>
                  DashboardCommunityTile(
                    community: communities[i],
                  ),
            )
                : ListView.builder(
              padding: rp.copyWith(
                top: 16,
                bottom: 40,
              ),
              itemCount: communities.length,
              itemBuilder: (_, i) =>
                  DashboardCommunityTile(
                    community: communities[i],
                  ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00838F),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(
          narrow ? 'Add' : 'Add Community',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const CommunityRegistrationPage(),
            ),
          );

          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }
}






