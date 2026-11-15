import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../beneficiaries/presentation/widgets/capture_card.dart';
import '../widgets/dashboard_count_chip.dart';
import '../widgets/dashboard_empty_state.dart';
import '../widgets/dashboard_section_label.dart';
import '../widgets/participant_box.dart';

// Responsive helpers
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;

EdgeInsets _rp(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
  if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
  return const EdgeInsets.symmetric(horizontal: 16);
}

/// List of activities logged by the current officer.
/// Tapping a tile opens [DashboardActivityDetailPage].
class DashboardActivitiesPage extends StatefulWidget {
  const DashboardActivitiesPage({super.key});

  @override
  State<DashboardActivitiesPage> createState() =>
      _DashboardActivitiesPageState();
}

class _DashboardActivitiesPageState extends State<DashboardActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    final activities = activitiesForOfficer(kCurrentOfficer.id);
    final narrow = _isNarrow(context);
    final rp = _rp(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
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
                        '${activities.length} logged  ·  '
                        '${kCurrentProject.name}',
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

          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: activities.isEmpty
                ? const DashboardEmptyState()
                : _isWide(context)
                ? GridView.builder(
                    padding: rp.copyWith(top: 16, bottom: 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.4,
                        ),
                    itemCount: activities.length,
                    itemBuilder: (_, i) => ActivityTile(a: activities[i]),
                  )
                : ListView.builder(
                    padding: rp.copyWith(top: 16, bottom: 40),
                    itemCount: activities.length,
                    itemBuilder: (_, i) => ActivityTile(a: activities[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_chart_outlined),
        label: Text(
          narrow ? 'Log' : 'Log Activity',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, AppRouter.activityLog);
          setState(() {});
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Activity tile
// ---------------------------------------------------------------------------

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.a});
  final DummyActivity a;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final (badgeColor, badgeLabel) = switch (a.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardActivityDetailPage(activity: a),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(narrow ? 10 : 14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: narrow ? 36 : 42,
              height: narrow ? 36 : 42,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: AppColors.success,
                size: narrow ? 17 : 20,
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.activityType,
                    style: TextStyle(
                      fontSize: narrow ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${a.community}, ${a.lga}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Participant chips — wrap on narrow so they don't overflow
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      DashboardCountChip(
                        icon: Icons.male,
                        value: a.maleCount,
                        color: AppColors.primary,
                      ),
                      DashboardCountChip(
                        icon: Icons.female,
                        value: a.femaleCount,
                        color: const Color(0xFFE91E63),
                      ),
                      DashboardCountChip(
                        icon: Icons.child_care,
                        value: a.childrenCount,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Date + badge + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  relativeDate(a.date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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

class CountChip extends StatelessWidget {
  const CountChip({super.key,
    required this.icon,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}


// ---------------------------------------------------------------------------
// Activity detail page
// ---------------------------------------------------------------------------

class DashboardActivityDetailPage extends StatelessWidget {
  const DashboardActivityDetailPage({super.key, required this.activity});

  final DummyActivity activity;

  @override
  Widget build(BuildContext context) {
    final a = activity;
    final narrow = _isNarrow(context);
    final rp = _rp(context);
    final (badgeColor, badgeLabel) = switch (a.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible app bar ────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 52, 14),
              title: Text(
                a.activityType,
                style: TextStyle(
                  fontSize: narrow ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                color: AppColors.success,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        '${a.community}, ${a.lga}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.80),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                  // ── Activity info ──────────────────────────────────────
                  const DashboardSectionLabel('Activity Information'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Date',
                        value: _fmtDate(a.date),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Community',
                        value: a.community,
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.map_outlined,
                        label: 'LGA',
                        value: a.lga,
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.assignment_outlined,
                        label: 'Activity type',
                        value: a.activityType,
                      ),
                      if (a.description.isNotEmpty) ...[
                        _Divider(),
                        _InfoRow(
                          icon: Icons.notes_outlined,
                          label: 'Notes',
                          value: a.description,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Participants ───────────────────────────────────────
                  const DashboardSectionLabel('Participants'),
                  const SizedBox(height: 10),
                  // On narrow: 2×2 grid; on normal+: single row of 4
                  narrow
                      ? Column(
                          children: [
                            Row(
                              children: [
                                ParticipantBox(
                                  label: 'Male',
                                  count: a.maleCount,
                                  icon: Icons.male,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                ParticipantBox(
                                  label: 'Female',
                                  count: a.femaleCount,
                                  icon: Icons.female,
                                  color: const Color(0xFFE91E63),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ParticipantBox(
                                  label: 'Children',
                                  count: a.childrenCount,
                                  icon: Icons.child_care,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                ParticipantBox(
                                  label: 'Total',
                                  count: a.totalParticipants,
                                  icon: Icons.groups_outlined,
                                  color: AppColors.success,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            ParticipantBox(
                              label: 'Male',
                              count: a.maleCount,
                              icon: Icons.male,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            ParticipantBox(
                              label: 'Female',
                              count: a.femaleCount,
                              icon: Icons.female,
                              color: const Color(0xFFE91E63),
                            ),
                            const SizedBox(width: 10),
                            ParticipantBox(
                              label: 'Children',
                              count: a.childrenCount,
                              icon: Icons.child_care,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 10),
                            ParticipantBox(
                              label: 'Total',
                              count: a.totalParticipants,
                              icon: Icons.groups_outlined,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),

                  // ── Field capture ──────────────────────────────────────
                  const DashboardSectionLabel('Field Capture'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CaptureCard(
                        icon: Icons.gps_fixed,
                        label: 'GPS Location',
                        captured: a.hasGps,
                      ),
                      const SizedBox(width: 10),
                      CaptureCard(
                        icon: Icons.photo_camera_outlined,
                        label:
                            '${a.photoCount} Photo${a.photoCount == 1 ? '' : 's'}',
                        captured: a.photoCount > 0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Sync status ────────────────────────────────────────
                  const DashboardSectionLabel('Sync Status'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          a.syncStatus == 'synced'
                              ? Icons.check_circle_outline
                              : a.syncStatus == 'failed'
                              ? Icons.error_outline
                              : Icons.cloud_upload_outlined,
                          color: badgeColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            a.syncStatus == 'synced'
                                ? 'Successfully synced to server'
                                : a.syncStatus == 'failed'
                                ? 'Sync failed — will retry automatically'
                                : 'Pending upload — will sync when connected',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
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

  static String _fmtDate(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

// class SectionLabel extends StatelessWidget {
//   const _SectionLabel(this.label);
//   final String label;
//
//   @override
//   Widget build(BuildContext context) => Text(
//     label.toUpperCase(),
//     style: const TextStyle(
//       fontSize: 11,
//       fontWeight: FontWeight.w700,
//       letterSpacing: 1.1,
//       color: AppColors.textSecondary,
//     ),
//   );
// }

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 44, color: AppColors.border);
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: narrow ? 80 : 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


