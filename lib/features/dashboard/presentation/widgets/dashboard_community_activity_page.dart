import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'dashboard_list_tile.dart';

class DashboardCommunityActivitiesPage extends StatelessWidget {
  const DashboardCommunityActivitiesPage({super.key,
    required this.community,
    required this.activities,
  });

  final DummyCommunity community;
  final List<DummyActivity> activities;

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            color: AppColors.success,
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
                        'Activities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: narrow ? 17 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${activities.length} logged  ·  ${community.name}',
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

          // ── List ────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: rp.copyWith(top: 16, bottom: 40),
              itemCount: activities.length,
              itemBuilder: (_, i) => DashboardListTile(a: activities[i]),
            ),
          ),
        ],
      ),
    );
  }
}
