import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'admin_beneficiaries_page.dart';
import 'admin_grants_page.dart';
import 'admin_activities_overview_page.dart';
import 'admin_pending_sync_page.dart';

// Responsive helpers ─────────────────────────────────────────────────────────
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;
double _hPad(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return 32;
  if (w < 400) return 12;
  return 16;
}

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = kCurrentAdmin;
    final allBenefs = kAllBeneficiaries;
    final allActs = kAllActivities;
    final summaries = kOfficerSummaries;

    final totalGrants = allBenefs.fold<double>(0, (s, b) => s + b.grantAmount);
    final totalBenefs = allBenefs.length;
    final totalActs = allActs.length;
    final pendingSync =
        allBenefs.where((b) => b.syncStatus != 'synced').length +
        allActs.where((a) => a.syncStatus != 'synced').length;

    final recentActivities = [...kAllActivities]
      ..sort((x, y) => y.date.compareTo(x.date));
    final feed = recentActivities.take(6).toList();
    final hp = _hPad(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async =>
            await Future.delayed(const Duration(milliseconds: 600)),
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────────
            SliverToBoxAdapter(child: _AdminHeader(admin: admin)),

            // ── Programme stats (tappable) ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hp, 20, hp, 0),
                child: _ProgrammeStats(
                  totalBenefs: totalBenefs,
                  totalGrants: totalGrants,
                  totalActs: totalActs,
                  pendingSync: pendingSync,
                ),
              ),
            ),

            // ── Officers status ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hp, 24, hp, 0),
                child: _OfficersStatusRow(summaries: summaries),
              ),
            ),

            // ── Grant disbursement summary ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hp, 24, hp, 0),
                child: _GrantSummary(summaries: summaries),
              ),
            ),

            // ── Recent field activities ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hp, 24, hp, 0),
                child: _RecentActivitiesFeed(activities: feed),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.admin});
  final DummyAdmin admin;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final pendingTasks = kTasks.where((t) => t.status != 'completed').length;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        _hPad(context),
        MediaQuery.of(context).padding.top + 16,
        _hPad(context),
        24,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: narrow ? 40 : 46,
            height: narrow ? 40 : 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                admin.avatarInitials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: narrow ? 14 : 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currentGreeting 👋',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: narrow ? 11 : 13,
                  ),
                ),
                Text(
                  admin.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: narrow ? 15 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  admin.role,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: narrow ? 11 : 12,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {},
              ),
              if (pendingTasks > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Programme stats — 4 tappable tiles in a 2×2 grid
// ---------------------------------------------------------------------------

class _ProgrammeStats extends StatelessWidget {
  const _ProgrammeStats({
    required this.totalBenefs,
    required this.totalGrants,
    required this.totalActs,
    required this.pendingSync,
  });

  final int totalBenefs;
  final double totalGrants;
  final int totalActs;
  final int pendingSync;

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);
    final gap = wide ? 14.0 : 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Programme Overview'),
        const SizedBox(height: 10),
        // Wide: single row of 4 | Normal/narrow: 2×2 grid
        wide
            ? Row(
                children: [
                  _StatTile(
                    value: '$totalBenefs',
                    label: 'Beneficiaries',
                    icon: Icons.group_outlined,
                    color: AppColors.primary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminBeneficiariesPage(),
                      ),
                    ),
                  ),
                  SizedBox(width: gap),
                  _StatTile(
                    value: _fmtNaira(totalGrants),
                    label: 'Grants Disbursed',
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminGrantsPage(),
                      ),
                    ),
                  ),
                  SizedBox(width: gap),
                  _StatTile(
                    value: '$totalActs',
                    label: 'Activities Logged',
                    icon: Icons.assignment_outlined,
                    color: const Color(0xFF00838F),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminActivitiesOverviewPage(),
                      ),
                    ),
                  ),
                  SizedBox(width: gap),
                  _StatTile(
                    value: '$pendingSync',
                    label: 'Pending Sync',
                    icon: Icons.cloud_upload_outlined,
                    color: pendingSync > 0
                        ? AppColors.warning
                        : AppColors.textSecondary,
                    highlight: pendingSync > 0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminPendingSyncPage(),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      _StatTile(
                        value: '$totalBenefs',
                        label: 'Beneficiaries',
                        icon: Icons.group_outlined,
                        color: AppColors.primary,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminBeneficiariesPage(),
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      _StatTile(
                        value: _fmtNaira(totalGrants),
                        label: 'Grants Disbursed',
                        icon: Icons.payments_outlined,
                        color: AppColors.success,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminGrantsPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: gap),
                  Row(
                    children: [
                      _StatTile(
                        value: '$totalActs',
                        label: 'Activities Logged',
                        icon: Icons.assignment_outlined,
                        color: const Color(0xFF00838F),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminActivitiesOverviewPage(),
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      _StatTile(
                        value: '$pendingSync',
                        label: 'Pending Sync',
                        icon: Icons.cloud_upload_outlined,
                        color: pendingSync > 0
                            ? AppColors.warning
                            : AppColors.textSecondary,
                        highlight: pendingSync > 0,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminPendingSyncPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  static String _fmtNaira(double n) {
    if (n >= 1000000) return '₦${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '₦${(n / 1000).toStringAsFixed(0)}K';
    return '₦${n.toStringAsFixed(0)}';
  }
}

// ---------------------------------------------------------------------------
// Stat tile — tappable with ripple
// ---------------------------------------------------------------------------

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.highlight = false,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);

    return Expanded(
      child: Material(
        color: highlight
            ? AppColors.warning.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: narrow ? 12 : 16,
              horizontal: narrow ? 10 : 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: highlight
                  ? Border.all(color: AppColors.warning.withValues(alpha: 0.40))
                  : Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: narrow ? 34 : 40,
                  height: narrow ? 34 : 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: narrow ? 17 : 20),
                ),
                SizedBox(width: narrow ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: narrow ? 15 : 18,
                            fontWeight: FontWeight.w800,
                            color: highlight
                                ? AppColors.warning
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      if (onTap != null) ...[
                        const SizedBox(height: 2),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 11,
                          color: color.withValues(alpha: 0.60),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Officers status row
// ---------------------------------------------------------------------------

class _OfficersStatusRow extends StatelessWidget {
  const _OfficersStatusRow({required this.summaries});
  final List<OfficerSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);
    // On wide screens show officer cards in a wrap grid; narrow stays horizontal scroll
    final cardWidth = wide ? 180.0 : 150.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionLabel('Field Officers')),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: summaries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (_, i) => SizedBox(
              width: cardWidth,
              child: _OfficerCard(summary: summaries[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _OfficerCard extends StatelessWidget {
  const _OfficerCard({required this.summary});
  final OfficerSummary summary;

  @override
  Widget build(BuildContext context) {
    final isActiveToday =
        summary.lastActiveDate != null &&
        DateTime.now().difference(summary.lastActiveDate!).inDays == 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActiveToday
              ? AppColors.success.withValues(alpha: 0.40)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  summary.officer.avatarInitials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: isActiveToday
                      ? AppColors.success
                      : AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            summary.officer.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            summary.lastActiveSummary,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _MiniStat(
                icon: Icons.group_outlined,
                value: summary.beneficiariesCount,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _MiniStat(
                icon: Icons.task_alt,
                value: summary.pendingTasksCount,
                color: summary.pendingTasksCount > 0
                    ? AppColors.warning
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 3),
      Text(
        '$value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Grant disbursement summary per officer
// ---------------------------------------------------------------------------

class _GrantSummary extends StatelessWidget {
  const _GrantSummary({required this.summaries});
  final List<OfficerSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final totalGrants = summaries.fold<double>(0, (s, o) => s + o.grantsTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Grant Disbursement by Officer'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: summaries.map((s) {
              final fraction = totalGrants == 0
                  ? 0.0
                  : s.grantsTotal / totalGrants;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.12,
                          ),
                          child: Text(
                            s.officer.avatarInitials,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.officer.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          s.grantsTotal == 0
                              ? '—'
                              : '₦${(s.grantsTotal / 1000).toStringAsFixed(0)}K',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Recent activities feed
// ---------------------------------------------------------------------------

class _RecentActivitiesFeed extends StatelessWidget {
  const _RecentActivitiesFeed({required this.activities});
  final List<DummyActivity> activities;

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Recent Field Activities'),
        const SizedBox(height: 10),
        wide
            // Wide: 2-column grid
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.0,
                ),
                itemCount: activities.length,
                itemBuilder: (_, i) =>
                    _ActivityFeedCard(activity: activities[i]),
              )
            : Column(
                children: activities
                    .map((a) => _ActivityFeedCard(activity: a))
                    .toList(),
              ),
      ],
    );
  }
}

class _ActivityFeedCard extends StatelessWidget {
  const _ActivityFeedCard({required this.activity});
  final DummyActivity activity;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final officer = kAllOfficers.firstWhere(
      (o) => o.id == activity.fieldOfficerId,
      orElse: () => kCurrentOfficer,
    );
    final (iconData, iconColor) = _activityIcon(activity.activityType);
    final (badgeColor, badgeLabel) = switch (activity.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return Container(
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
          Container(
            width: narrow ? 34 : 40,
            height: narrow ? 34 : 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconColor, size: narrow ? 16 : 20),
          ),
          SizedBox(width: narrow ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityType,
                  style: TextStyle(
                    fontSize: narrow ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.community}, ${activity.lga}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.12,
                      ),
                      child: Text(
                        officer.avatarInitials,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        officer.name,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                relativeDate(activity.date),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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
            ],
          ),
        ],
      ),
    );
  }

  (IconData, Color) _activityIcon(String type) => switch (type) {
    'Grant Disbursement' => (Icons.payments_outlined, AppColors.success),
    'Beneficiary Registration' => (
      Icons.person_add_outlined,
      AppColors.primary,
    ),
    'Business Monitoring Visit' => (
      Icons.storefront_outlined,
      const Color(0xFF00838F),
    ),
    'Medical Support Visit' => (
      Icons.medical_services_outlined,
      AppColors.error,
    ),
    'Skills Training' => (Icons.school_outlined, const Color(0xFF6A1B9A)),
    _ => (Icons.assignment_outlined, AppColors.textSecondary),
  };
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      color: AppColors.textSecondary,
    ),
  );
}
