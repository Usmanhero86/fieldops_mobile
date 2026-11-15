import 'package:flutter/material.dart';

import '../../core/dummy/dummy_data.dart';
import '../../core/routes/app_router.dart';
import '../../core/themes/app_colors.dart';

/// "More" tab — shows officer profile and navigation to secondary screens.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final officer = kCurrentOfficer;
    final project = kCurrentProject;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header / Profile card ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _ProfileHeader(officer: officer, project: project),
          ),

          // ── Project stats ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _ProjectStatsCard(project: project),
            ),
          ),

          // ── Menu items ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _MenuSection(
                title: 'Tools',
                items: [
                  _MenuItem(
                    icon: Icons.map_outlined,
                    label: 'Field Map',
                    subtitle: 'View beneficiary & activity locations',
                    color: const Color(0xFF00838F),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.mapRoute),
                  ),
                  _MenuItem(
                    icon: Icons.assessment_outlined,
                    label: 'Reports',
                    subtitle: 'Generate PDF & CSV exports',
                    color: const Color(0xFF6A1B9A),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.reports),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _MenuSection(
                title: 'Data',
                items: [
                  _MenuItem(
                    icon: Icons.folder_open,
                    label: 'My Projects',
                    subtitle: '${kProjects.length} assigned projects',
                    color: AppColors.primary,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.projects),
                  ),
                  _MenuItem(
                    icon: Icons.location_city_outlined,
                    label: 'Communities',
                    subtitle: 'Browse communities across projects',
                    color: const Color(0xFF00838F),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.communities),
                  ),
                  _MenuItem(
                    icon: Icons.cloud_sync_outlined,
                    label: 'Sync Status',
                    subtitle: 'View and manage pending uploads',
                    color: AppColors.warning,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.pendingSync),
                    trailingBadge: _pendingCount(),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _MenuSection(
                title: 'Account',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'My Profile',
                    subtitle: officer.email,
                    color: AppColors.textSecondary,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    subtitle: 'FAQs and contact',
                    color: AppColors.textSecondary,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Log Out',
                    subtitle: 'Return to login screen',
                    color: AppColors.error,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  int _pendingCount() {
    return beneficiariesForOfficer(
          kCurrentOfficer.id,
        ).where((b) => b.syncStatus == 'pending').length +
        activitiesForOfficer(
          kCurrentOfficer.id,
        ).where((a) => a.syncStatus == 'pending').length;
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out? Any unsynced data will remain on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile header
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.officer, required this.project});
  final DummyOfficer officer;
  final DummyProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        28,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                officer.avatarInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name / role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  officer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  officer.role,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Project stats card
// ---------------------------------------------------------------------------

class _ProjectStatsCard extends StatelessWidget {
  const _ProjectStatsCard({required this.project});
  final DummyProject project;

  @override
  Widget build(BuildContext context) {
    final pct = (project.progressPercent * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                project.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                project.donor,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.progressPercent,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(project.color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${project.registeredBeneficiaries} / ${project.targetBeneficiaries} beneficiaries registered  ($pct%)',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(
                label: 'Communities',
                value: '${project.communityCount}',
              ),
              _MiniStat(
                label: 'Activities',
                value: '${project.activitiesLogged}',
              ),
              _MiniStat(label: 'LGAs', value: '${project.lgaCount}'),
              _MiniStat(
                label: 'Pending Sync',
                value: '${project.pendingSync}',
                highlight: project.pendingSync > 0,
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
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: highlight ? AppColors.warning : AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu section + item
// ---------------------------------------------------------------------------

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _MenuItemTile(item: items[i]),
                if (i < items.length - 1)
                  const Divider(height: 1, indent: 62, color: AppColors.border),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.trailingBadge = 0,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int trailingBadge;
}

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({required this.item});
  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, color: item.color, size: 20),
      ),
      title: Text(
        item.label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: item.trailingBadge > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${item.trailingBadge}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
      onTap: item.onTap,
    );
  }
}
