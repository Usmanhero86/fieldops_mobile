import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';

class CommunityDetailPage extends StatelessWidget {
  const CommunityDetailPage({super.key, required this.community});
  final DummyCommunity community;

  @override
  Widget build(BuildContext context) {
    final beneficiaries = beneficiariesForCommunity(community.name);
    final activities = activitiesForCommunity(community.name);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: Text(community.name),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Location info card ──────────────────────────────────
                  _InfoCard(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_city_outlined,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${community.lga} LGA  ·  ${community.state}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  community.ward,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 14),

                      // Coordinates row with map button
                      Row(
                        children: [
                          const Icon(Icons.gps_fixed,
                              size: 15, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            '${community.latitude.toStringAsFixed(4)}, '
                            '${community.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, AppRouter.mapRoute),
                            icon: const Icon(Icons.map_outlined, size: 16),
                            label: const Text('Map'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Statistics ──────────────────────────────────────────
                  _SectionLabel(label: 'Statistics'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatBox(
                        icon: Icons.people_outline,
                        value: '${community.beneficiaryCount}',
                        label: 'Beneficiaries',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        icon: Icons.assignment_outlined,
                        value: '${community.activityCount}',
                        label: 'Activities',
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        icon: Icons.home_outlined,
                        value: '${community.householdCount}',
                        label: 'Households',
                        color: const Color(0xFF00838F),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Quick actions ───────────────────────────────────────
                  _SectionLabel(label: 'Actions'),
                  const SizedBox(height: 10),
                  _ActionRow(
                    icon: Icons.person_add_outlined,
                    label: 'Register Beneficiary',
                    color: AppColors.primary,
                    onTap: () => Navigator.pushNamed(
                        context, AppRouter.beneficiaryRegister),
                  ),
                  const SizedBox(height: 8),
                  _ActionRow(
                    icon: Icons.add_chart_outlined,
                    label: 'Record Activity',
                    color: AppColors.success,
                    onTap: () => Navigator.pushNamed(
                        context, AppRouter.activityLog),
                  ),
                  const SizedBox(height: 24),

                  // ── Recent beneficiaries preview ────────────────────────
                  if (beneficiaries.isNotEmpty) ...[
                    Row(
                      children: [
                        const Expanded(
                          child: _SectionLabel(
                              label: 'Recent Beneficiaries'),
                        ),
                        Text(
                          '${beneficiaries.length} total',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...beneficiaries.take(3).map(
                          (b) => _BeneficiaryRow(b: b),
                        ),
                    if (beneficiaries.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${beneficiaries.length - 3} more',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.primary),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],

                  // ── Recent activities preview ───────────────────────────
                  if (activities.isNotEmpty) ...[
                    Row(
                      children: [
                        const Expanded(
                          child:
                              _SectionLabel(label: 'Recent Activities'),
                        ),
                        Text(
                          '${activities.length} total',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...activities.take(3).map(
                          (a) => _ActivityRow(a: a),
                        ),
                    const SizedBox(height: 24),
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

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right,
                  color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeneficiaryRow extends StatelessWidget {
  const _BeneficiaryRow({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              b.initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.fullName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${b.gender}  ·  Age ${b.age}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          _SyncDot(status: b.syncStatus),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.a});
  final DummyActivity a;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.assignment_outlined,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.activityType,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  relativeDate(a.date),
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (a.totalParticipants > 0)
            Text(
              '${a.totalParticipants} pax',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _SyncDot extends StatelessWidget {
  const _SyncDot({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'synced' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.warning,
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
