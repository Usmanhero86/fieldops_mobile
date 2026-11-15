import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.activity});
  final DummyActivity activity;

  static const _typeColors = <String, Color>{
    'Education Awareness Session': Color(0xFF1565C0),
    'Household Registration': Color(0xFF2E7D32),
    'Community Mobilisation': Color(0xFF6A1B9A),
    'Verification Visit': Color(0xFF00838F),
  };

  Color get _color => _typeColors[activity.activityType] ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final total = activity.totalParticipants;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 52, 14),
              title: Text(
                activity.activityType,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_color, _color.withValues(alpha: 0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${activity.community}  ·  ${activity.lga}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    _SyncBadge(status: activity.syncStatus),
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
                  // ── Activity info ────────────────────────────────────────
                  _Card(
                    children: [
                      _Row(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: _fullDate(activity.date),
                      ),
                      _Div(),
                      _Row(
                        icon: Icons.schedule_outlined,
                        label: 'Time',
                        value: _timeStr(activity.date),
                      ),
                      _Div(),
                      _Row(
                        icon: Icons.location_on_outlined,
                        label: 'Community',
                        value: activity.community,
                      ),
                      _Div(),
                      _Row(
                        icon: Icons.map_outlined,
                        label: 'LGA',
                        value: '${activity.lga} LGA',
                      ),
                      _Div(),
                      _Row(
                        icon: Icons.folder_open,
                        label: 'Project',
                        value: kCurrentProject.name,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Participants ──────────────────────────────────────────
                  if (total > 0) ...[
                    _SectionLabel('Participants'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _StatBox(
                          value: '${activity.maleCount}',
                          label: 'Male',
                          color: const Color(0xFF1565C0),
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          value: '${activity.femaleCount}',
                          label: 'Female',
                          color: const Color(0xFF880E4F),
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          value: '${activity.childrenCount}',
                          label: 'Children',
                          color: const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          value: '$total',
                          label: 'Total',
                          color: _color,
                          highlight: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Field capture ─────────────────────────────────────────
                  _SectionLabel('Field Capture'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _CaptureCard(
                          icon: Icons.gps_fixed,
                          label: 'GPS Location',
                          captured: activity.hasGps,
                          onTap: activity.hasGps
                              ? () => Navigator.pushNamed(
                                  context,
                                  AppRouter.mapRoute,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _CaptureCard(
                          icon: Icons.photo_camera_outlined,
                          label:
                              '${activity.photoCount} Photo${activity.photoCount == 1 ? '' : 's'}',
                          captured: activity.photoCount > 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Description ───────────────────────────────────────────
                  if (activity.description.isNotEmpty) ...[
                    _SectionLabel('Description'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        activity.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Registered by ─────────────────────────────────────────
                  _SectionLabel('Registration'),
                  const SizedBox(height: 10),
                  _Card(
                    children: [
                      _Row(
                        icon: Icons.badge_outlined,
                        label: 'Logged by',
                        value: kCurrentOfficer.name,
                      ),
                      _Div(),
                      _Row(
                        icon: Icons.calendar_today_outlined,
                        label: 'Logged on',
                        value: _fullDate(activity.date),
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

  String _timeStr(DateTime d) {
    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }
}

// ---------------------------------------------------------------------------
// Widgets
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

class _Card extends StatelessWidget {
  const _Card({required this.children});
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

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 44, color: AppColors.border);
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
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

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
    this.highlight = false,
  });
  final String value;
  final String label;
  final Color color;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: highlight ? color.withValues(alpha: 0.08) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? color.withValues(alpha: 0.30) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
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
    ),
  );
}

class _CaptureCard extends StatelessWidget {
  const _CaptureCard({
    required this.icon,
    required this.label,
    required this.captured,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final bool captured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = captured ? AppColors.success : AppColors.warning;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onTap != null) ...[
              const SizedBox(height: 4),
              Text('View map', style: TextStyle(fontSize: 10, color: color)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (status) {
      'synced' => ('Synced', Icons.cloud_done_outlined),
      'failed' => ('Sync failed', Icons.cloud_off_outlined),
      _ => ('Pending sync', Icons.cloud_upload_outlined),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
