import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
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

/// Activity reports feed — all officers, sorted newest first.
/// Filterable by officer or activity type.
class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  String? _officerFilter;
  String? _typeFilter;

  List<DummyActivity> get _filtered {
    var list = [...kAllActivities]..sort((a, b) => b.date.compareTo(a.date));
    if (_officerFilter != null) {
      list = list.where((a) => a.fieldOfficerId == _officerFilter).toList();
    }
    if (_typeFilter != null) {
      list = list.where((a) => a.activityType == _typeFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final hasFilter = _officerFilter != null || _typeFilter != null;
    final hp = _hPad(context);
    final narrow = _isNarrow(context);
    final wide = _isWide(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(
              hp,
              MediaQuery.of(context).padding.top + 14,
              hp,
              18,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activity Reports',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: narrow ? 17 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'All field officers · BSF',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showFilterSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: hasFilter
                          ? AppColors.warning
                          : Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasFilter
                              ? Icons.filter_alt
                              : Icons.filter_alt_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Count + clear ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 10, hp, 4),
            child: Row(
              children: [
                Text(
                  '${list.length} activit${list.length == 1 ? 'y' : 'ies'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (hasFilter) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() {
                      _officerFilter = null;
                      _typeFilter = null;
                    }),
                    child: const Text(
                      'Clear filters',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── List / grid ──────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ? const _EmptyState()
                : wide
                // Wide: 2-column grid
                ? GridView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 0, hp, 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.35,
                        ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _ReportCard(activity: list[i]),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 0, hp, 40),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _ReportCard(activity: list[i]),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final types = kAllActivities.map((a) => a.activityType).toSet().toList()
      ..sort();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Filter Reports',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Officer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _officerFilter == null,
                    onTap: () =>
                        setSheet(() => setState(() => _officerFilter = null)),
                  ),
                  ...kAllOfficers.map(
                    (o) => _FilterChip(
                      label: o.name.split(' ').first,
                      selected: _officerFilter == o.id,
                      onTap: () =>
                          setSheet(() => setState(() => _officerFilter = o.id)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Activity Type',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _typeFilter == null,
                    onTap: () =>
                        setSheet(() => setState(() => _typeFilter = null)),
                  ),
                  ...types.map(
                    (t) => _FilterChip(
                      label: t,
                      selected: _typeFilter == t,
                      onTap: () =>
                          setSheet(() => setState(() => _typeFilter = t)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Report card
// ---------------------------------------------------------------------------

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.activity});
  final DummyActivity activity;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final officer = kAllOfficers.firstWhere(
      (o) => o.id == activity.fieldOfficerId,
      orElse: () => kCurrentOfficer,
    );
    final (badgeColor, badgeLabel) = switch (activity.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + badge
          Row(
            children: [
              Expanded(
                child: Text(
                  activity.activityType,
                  style: TextStyle(
                    fontSize: narrow ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
          const SizedBox(height: 4),
          Text(
            '${activity.community}  ·  ${activity.lga} LGA',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Description — fewer lines on narrow
          Text(
            activity.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
            maxLines: narrow ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Footer
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (activity.totalParticipants > 0) ...[
                const Icon(
                  Icons.groups_outlined,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 2),
                Text(
                  '${activity.totalParticipants}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (activity.photoCount > 0) ...[
                const Icon(
                  Icons.photo_camera_outlined,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 2),
                Text(
                  '${activity.photoCount}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                relativeDate(activity.date),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
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
// Shared
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
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
    return const Center(
      child: Text(
        'No activities match the selected filters',
        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
