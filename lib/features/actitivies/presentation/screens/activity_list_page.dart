import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import 'activity_detail_page.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  String _filterStatus = 'all'; // all | pending | synced | failed

  List<DummyActivity> get _filtered {
    final all = activitiesForOfficer(kCurrentOfficer.id);
    if (_filterStatus == 'all') return all;
    return all.where((a) => a.syncStatus == _filterStatus).toList();
  }

  int get _pendingCount => activitiesForOfficer(
    kCurrentOfficer.id,
  ).where((a) => a.syncStatus == 'pending').length;

  /// Group activities by day label (Today / Yesterday / date string).
  Map<String, List<DummyActivity>> _grouped(List<DummyActivity> items) {
    final map = <String, List<DummyActivity>>{};
    for (final a in items) {
      final label = _dayLabel(a.date);
      map.putIfAbsent(label, () => []).add(a);
    }
    return map;
  }

  String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  static const _months = [
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

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final grouped = _grouped(list);
    final groupKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          _Header(
            total: activitiesForOfficer(kCurrentOfficer.id).length,
            pending: _pendingCount,
          ),

          // ── Filter chips ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _Chip(
                    label: 'All',
                    value: 'all',
                    current: _filterStatus,
                    onTap: () => setState(() => _filterStatus = 'all'),
                  ),
                  _Chip(
                    label: 'Pending',
                    value: 'pending',
                    current: _filterStatus,
                    onTap: () => setState(() => _filterStatus = 'pending'),
                  ),
                  _Chip(
                    label: 'Synced',
                    value: 'synced',
                    current: _filterStatus,
                    onTap: () => setState(() => _filterStatus = 'synced'),
                  ),
                  _Chip(
                    label: 'Failed',
                    value: 'failed',
                    current: _filterStatus,
                    onTap: () => setState(() => _filterStatus = 'failed'),
                  ),
                ],
              ),
            ),
          ),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: groupKeys.length,
                    itemBuilder: (_, i) {
                      final key = groupKeys[i];
                      final items = grouped[key]!;
                      return _DateGroup(label: key, activities: items);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_chart_outlined),
        label: const Text(
          'Log Activity',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () => Navigator.pushNamed(context, AppRouter.activityLog),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.total, required this.pending});
  final int total;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 14,
        20,
        18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Field Activities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$total activities  ·  ${kCurrentProject.name}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (pending > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.50),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.warning,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$pending',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date group header + cards
// ---------------------------------------------------------------------------

class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.label, required this.activities});
  final String label;
  final List<DummyActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...activities.map((a) => _ActivityCard(activity: a)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Activity card
// ---------------------------------------------------------------------------

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});
  final DummyActivity activity;

  static const _typeColors = <String, Color>{
    'Education Awareness Session': Color(0xFF1565C0),
    'Household Registration': Color(0xFF2E7D32),
    'Community Mobilisation': Color(0xFF6A1B9A),
    'Verification Visit': Color(0xFF00838F),
  };

  Color get _color => _typeColors[activity.activityType] ?? AppColors.primary;

  String _timeStr(DateTime d) {
    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final total = activity.totalParticipants;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ActivityDetailPage(activity: activity),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: _color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title + location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.activityType,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activity.community,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _timeStr(activity.date),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sync badge
                  _SyncBadge(status: activity.syncStatus),
                ],
              ),
            ),

            // Footer — participants + indicators
            if (total > 0 || activity.hasGps || activity.photoCount > 0) ...[
              Container(height: 1, color: AppColors.border),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (total > 0) ...[
                      const Icon(
                        Icons.people_outline,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$total participant${total == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (activity.hasGps) ...[
                      const Icon(
                        Icons.gps_fixed,
                        size: 13,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (activity.photoCount > 0) ...[
                      const Icon(
                        Icons.photo_camera_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${activity.photoCount}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'synced' => ('● Synced', AppColors.success),
      'failed' => ('● Failed', AppColors.error),
      _ => ('● Pending', AppColors.warning),
    };
    return Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });
  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = value == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 14),
          const Text(
            'No activities found',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
