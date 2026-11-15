import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';

// ── Responsive helpers ────────────────────────────────────────────────────────
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;

double _hPad(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return 32;
  if (w < 400) return 12;
  return 16;
}

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = kCurrentAdmin;
    final hp = _hPad(context);
    final wide = _isWide(context);

    // On wide screens the two info cards sit side by side
    final totalGrants = kAllBeneficiaries.fold<double>(
      0,
      (s, b) => s + b.grantAmount,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHero(admin: admin)),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hp, 16, hp, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Contact ──────────────────────────────────────────
                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: admin.email,
                      ),
                      const _Divider(),
                      _InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: admin.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Organisation + Programme summary
                  // Wide: side by side | Normal: stacked
                  wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionLabel('Organisation'),
                                  const SizedBox(height: 10),
                                  _OrgCard(admin: admin),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionLabel('Programme Summary'),
                                  const SizedBox(height: 10),
                                  _ProgrammeCard(totalGrants: totalGrants),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionLabel('Organisation'),
                            const SizedBox(height: 10),
                            _OrgCard(admin: admin),
                            const SizedBox(height: 16),
                            const _SectionLabel('Programme Summary'),
                            const SizedBox(height: 10),
                            _ProgrammeCard(totalGrants: totalGrants),
                          ],
                        ),
                  const SizedBox(height: 24),

                  // ── Logout ───────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.60),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'BSF FieldOps  v1.0.0  ·  Admin Build',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
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

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('You will be returned to the login screen.'),
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
// Hero header — avatar scales with screen width
// ---------------------------------------------------------------------------

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.admin});
  final DummyAdmin admin;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final hp = _hPad(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        hp,
        MediaQuery.of(context).padding.top + 16,
        hp,
        32,
      ),
      child: Column(
        children: [
          Container(
            width: narrow ? 64 : 80,
            height: narrow ? 64 : 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.40),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                admin.avatarInitials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: narrow ? 22 : 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            admin.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: narrow ? 18 : 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            admin.role,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: narrow ? 13 : 14,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              narrow ? 'BSF' : 'Borno Startups Foundation (BSF)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Organisation card
// ---------------------------------------------------------------------------

class _OrgCard extends StatelessWidget {
  const _OrgCard({required this.admin});
  final DummyAdmin admin;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      children: [
        _InfoRow(
          icon: Icons.business_outlined,
          label: 'Organisation',
          value: 'Borno Startups Foundation (BSF)',
        ),
        const _Divider(),
        _InfoRow(icon: Icons.badge_outlined, label: 'Role', value: admin.role),
        const _Divider(),
        _InfoRow(
          icon: Icons.supervised_user_circle_outlined,
          label: 'Officers',
          value: '${kAllOfficers.length} field officers',
        ),
        const _Divider(),
        _InfoRow(
          icon: Icons.folder_open_outlined,
          label: 'Projects',
          value: '${kProjects.length} active projects',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Programme summary card
// ---------------------------------------------------------------------------

class _ProgrammeCard extends StatelessWidget {
  const _ProgrammeCard({required this.totalGrants});
  final double totalGrants;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      children: [
        _InfoRow(
          icon: Icons.group_outlined,
          label: 'Beneficiaries',
          value: '${kAllBeneficiaries.length}',
        ),
        const _Divider(),
        _InfoRow(
          icon: Icons.payments_outlined,
          label: 'Grants Disbursed',
          value: '₦${(totalGrants / 1000000).toStringAsFixed(2)}M',
          valueColor: AppColors.success,
        ),
        const _Divider(),
        _InfoRow(
          icon: Icons.assignment_outlined,
          label: 'Activities',
          value: '${kAllActivities.length}',
        ),
        const _Divider(),
        _InfoRow(
          icon: Icons.task_outlined,
          label: 'Tasks Assigned',
          value: '${kTasks.length} total',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
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
    child: Column(children: children),
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 50, color: AppColors.border);
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          SizedBox(
            // Shrink label column on narrow screens
            width: narrow ? 90 : 110,
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
