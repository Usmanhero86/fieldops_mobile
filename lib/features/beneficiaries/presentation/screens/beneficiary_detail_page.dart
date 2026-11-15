import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import '../widgets/capture_card.dart';
import '../widgets/gps_row.dart';
import '../widgets/sync_card.dart';

class BeneficiaryDetailPage extends StatelessWidget {
  const BeneficiaryDetailPage({super.key, required this.beneficiary});

  final DummyBeneficiary beneficiary;

  @override
  Widget build(BuildContext context) {
    final b = beneficiary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible app bar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {}, // Phase 3: edit flow
                tooltip: 'Edit',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 52, 14),
              title: Text(
                b.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(color: AppColors.primary),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Gender + community
                    Text(
                      '${b.gender}  ·  ${b.community}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    // Sync badge
                    SyncBadge(status: b.syncStatus),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Personal information ─────────────────────────────────
                  SectionLabel('Personal Information'),
                  const SizedBox(height: 10),
                  Card(
                    children: [
                      _Row(
                        icon: Icons.wc_outlined,
                        label: 'Gender',
                        value: b.gender,
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: _dobLabel(b.age),
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: '080XXXXXXXX', // masked for privacy
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.home_outlined,
                        label: 'Household Size',
                        value: '${b.householdSize} people',
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.warning_amber_outlined,
                        label: 'Vulnerability',
                        value: b.vulnerabilityCategory,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Location ─────────────────────────────────────────────
                  SectionLabel('Location'),
                  const SizedBox(height: 10),
                  Card(
                    children: [
                      _Row(
                        icon: Icons.location_on_outlined,
                        label: 'LGA',
                        value: '${b.lga} LGA',
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.near_me_outlined,
                        label: 'Ward',
                        value: b.ward,
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.location_city_outlined,
                        label: 'Community',
                        value: b.community,
                      ),
                      if (b.hasGps) ...[
                        _Divider(),
                        GpsRow(
                          onViewMap: () =>
                              Navigator.pushNamed(context, AppRouter.mapRoute),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Field capture ─────────────────────────────────────────
                  SectionLabel('Field Capture'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CaptureCard(
                          icon: Icons.gps_fixed,
                          label: 'GPS Location',
                          captured: b.hasGps,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CaptureCard(
                          icon: Icons.photo_camera_outlined,
                          label: 'Photo',
                          captured: b.hasPhoto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Registration ──────────────────────────────────────────
                  SectionLabel('Registration'),
                  const SizedBox(height: 10),
                  Card(
                    children: [
                      _Row(
                        icon: Icons.badge_outlined,
                        label: 'Registered by',
                        value: b.registeredBy.isEmpty
                            ? kCurrentOfficer.name
                            : b.registeredBy,
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.calendar_today_outlined,
                        label: 'Registered on',
                        value: _fullDate(b.registeredAt),
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.folder_open,
                        label: 'Project',
                        value: kCurrentProject.name,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Grant Information ─────────────────────────────────────
                  SectionLabel('Grant Information'),
                  const SizedBox(height: 10),
                  Card(
                    children: [
                      _Row(
                        icon: Icons.payments_outlined,
                        label: 'Grant amount',
                        value: b.formattedGrant,
                        valueColor: b.grantAmount > 0
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                      _Divider(),
                      _Row(
                        icon: Icons.storefront_outlined,
                        label: 'Business type',
                        value: b.businessType.isEmpty
                            ? 'Not assigned'
                            : b.businessType,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dobLabel(int age) {
    // Approximate — shows "~age years old" since we only store age in dummy
    return 'Approx. $age years old';
  }

  String _fullDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

// ------------------------
// Widgets
// ------------------------

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});
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

class Card extends StatelessWidget {
  const Card({super.key, required this.children});
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

class _Row extends StatelessWidget {
  const _Row({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
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

