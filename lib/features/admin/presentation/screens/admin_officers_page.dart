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

/// Officers tab — lists all field officers with summary stats.
class AdminOfficersPage extends StatelessWidget {
  const AdminOfficersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final summaries = kOfficerSummaries;
    final hp = _hPad(context);
    final narrow = _isNarrow(context);
    final wide = _isWide(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(
              hp,
              MediaQuery.of(context).padding.top + 14,
              hp,
              18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Field Officers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: narrow ? 17 : 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'Borno Startups Foundation (BSF)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${summaries.length} officers',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _PendingTasksBadge(),
              ],
            ),
          ),

          // ── Officer list / grid ───────────────────────────────────────
          Expanded(
            child: wide
                ? GridView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 16, hp, 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.55,
                        ),
                    itemCount: summaries.length,
                    itemBuilder: (_, i) => _OfficerCard(summary: summaries[i]),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 16, hp, 40),
                    itemCount: summaries.length,
                    itemBuilder: (_, i) => _OfficerCard(summary: summaries[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task),
        label: Text(
          narrow ? 'Assign' : 'Assign Task',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showAssignTaskSheet(context),
      ),
    );
  }

  void _showAssignTaskSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AdminAssignTaskSheet(),
    );
  }
}

// ---------------------------------------------------------------------------
// Pending tasks badge
// ---------------------------------------------------------------------------

class _PendingTasksBadge extends StatelessWidget {
  const _PendingTasksBadge();

  @override
  Widget build(BuildContext context) {
    final pending = kTasks.where((t) => t.status != 'completed').length;
    final overdue = kTasks.where((t) => t.isOverdue).length;

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.task_outlined, color: Colors.white, size: 13),
              const SizedBox(width: 5),
              Text(
                '$pending pending task${pending == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (overdue > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  '$overdue overdue',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Officer card
// ---------------------------------------------------------------------------

class _OfficerCard extends StatelessWidget {
  const _OfficerCard({required this.summary});
  final OfficerSummary summary;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final isActiveToday =
        summary.lastActiveDate != null &&
        DateTime.now().difference(summary.lastActiveDate!).inDays == 0;
    final officerTasks = kTasks
        .where(
          (t) => t.assignedTo == summary.officer.id && t.status != 'completed',
        )
        .toList();
    final overdueCount = officerTasks.where((t) => t.isOverdue).length;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminOfficerDetailPage(summary: summary),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(narrow ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: overdueCount > 0
                ? AppColors.error.withValues(alpha: 0.35)
                : isActiveToday
                ? AppColors.success.withValues(alpha: 0.35)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Name row
            Row(
              children: [
                CircleAvatar(
                  radius: narrow ? 20 : 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    summary.officer.avatarInitials,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: narrow ? 12 : 14,
                    ),
                  ),
                ),
                SizedBox(width: narrow ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.officer.name,
                        style: TextStyle(
                          fontSize: narrow ? 13 : 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary.officer.role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: isActiveToday
                                ? AppColors.success
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.40,
                                  ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isActiveToday
                              ? 'Active today'
                              : summary.lastActiveSummary,
                          style: TextStyle(
                            fontSize: 10,
                            color: isActiveToday
                                ? AppColors.success
                                : AppColors.textSecondary,
                            fontWeight: isActiveToday
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: narrow ? 10 : 14),
            const Divider(height: 1, color: AppColors.border),
            SizedBox(height: narrow ? 8 : 12),

            // Stats — Wrap on narrow so chips don't overflow
            narrow
                ? Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _StatChip(
                        icon: Icons.group_outlined,
                        label: '${summary.beneficiariesCount} beneficiaries',
                        color: AppColors.primary,
                      ),
                      _StatChip(
                        icon: Icons.assignment_outlined,
                        label: '${summary.activitiesCount} activities',
                        color: AppColors.success,
                      ),
                      _StatChip(
                        icon: Icons.task_outlined,
                        label: '${officerTasks.length} tasks',
                        color: overdueCount > 0
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _StatChip(
                        icon: Icons.group_outlined,
                        label: '${summary.beneficiariesCount} beneficiaries',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.assignment_outlined,
                        label: '${summary.activitiesCount} activities',
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.task_outlined,
                        label: '${officerTasks.length} tasks',
                        color: overdueCount > 0
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                    ],
                  ),

            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 14,
                  color: AppColors.success,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    summary.grantsTotal == 0
                        ? 'No grants disbursed'
                        : 'Disbursed ₦${(summary.grantsTotal / 1000).toStringAsFixed(0)}K in grants',
                    style: const TextStyle(
                      fontSize: 12,
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
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Officer Detail Page
// ===========================================================================

class AdminOfficerDetailPage extends StatelessWidget {
  const AdminOfficerDetailPage({super.key, required this.summary});
  final OfficerSummary summary;

  @override
  Widget build(BuildContext context) {
    final officer = summary.officer;
    final hp = _hPad(context);
    final narrow = _isNarrow(context);
    final wide = _isWide(context);

    final benefs =
        kAllBeneficiaries.where((b) => b.fieldOfficerId == officer.id).toList()
          ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
    final acts =
        kAllActivities.where((a) => a.fieldOfficerId == officer.id).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    final tasks = kTasks.where((t) => t.assignedTo == officer.id).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              TextButton.icon(
                onPressed: () => _showAssignTask(context, officer),
                icon: const Icon(Icons.add_task, color: Colors.white, size: 18),
                label: Text(
                  narrow ? 'Assign' : 'Assign Task',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.fromLTRB(20, 0, narrow ? 100 : 120, 14),
              title: Text(
                officer.name,
                style: TextStyle(
                  fontSize: narrow ? 14 : 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withValues(alpha: 0.20),
                      child: Text(
                        officer.avatarInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            officer.role,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.80),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            officer.phone,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.70),
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hp, 16, hp, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Summary stats ──────────────────────────────────
                  // Narrow: 2×2 grid | Normal/wide: single row of 3
                  narrow
                      ? Column(
                          children: [
                            Row(
                              children: [
                                _DetailStatBox(
                                  label: 'Beneficiaries',
                                  value: '${summary.beneficiariesCount}',
                                  icon: Icons.group_outlined,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10),
                                _DetailStatBox(
                                  label: 'Activities',
                                  value: '${summary.activitiesCount}',
                                  icon: Icons.assignment_outlined,
                                  color: AppColors.success,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _DetailStatBox(
                                  label: 'Grants',
                                  value: summary.grantsTotal == 0
                                      ? '—'
                                      : '₦${(summary.grantsTotal / 1000).toStringAsFixed(0)}K',
                                  icon: Icons.payments_outlined,
                                  color: const Color(0xFF00838F),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            _DetailStatBox(
                              label: 'Beneficiaries',
                              value: '${summary.beneficiariesCount}',
                              icon: Icons.group_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            _DetailStatBox(
                              label: 'Activities',
                              value: '${summary.activitiesCount}',
                              icon: Icons.assignment_outlined,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 10),
                            _DetailStatBox(
                              label: 'Grants',
                              value: summary.grantsTotal == 0
                                  ? '—'
                                  : '₦${(summary.grantsTotal / 1000).toStringAsFixed(0)}K',
                              icon: Icons.payments_outlined,
                              color: const Color(0xFF00838F),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),

                  // ── Tasks ──────────────────────────────────────────
                  if (tasks.isNotEmpty) ...[
                    _SectionLabel('Tasks (${tasks.length})'),
                    const SizedBox(height: 10),
                    // Wide: 2-col grid
                    wide
                        ? GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.8,
                            children: tasks
                                .map((t) => _TaskRow(task: t))
                                .toList(),
                          )
                        : Column(
                            children: tasks
                                .map((t) => _TaskRow(task: t))
                                .toList(),
                          ),
                    const SizedBox(height: 16),
                  ],

                  // ── Recent activities ──────────────────────────────
                  if (acts.isNotEmpty) ...[
                    _SectionLabel('Recent Activities (${acts.length})'),
                    const SizedBox(height: 10),
                    ...acts.take(4).map((a) => _ActivityRow(activity: a)),
                    const SizedBox(height: 16),
                  ],

                  // ── Beneficiaries ──────────────────────────────────
                  if (benefs.isNotEmpty) ...[
                    _SectionLabel(
                      'Registered Beneficiaries (${benefs.length})',
                    ),
                    const SizedBox(height: 10),
                    ...benefs.map((b) => _BeneficiaryRow(b: b)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignTask(BuildContext context, DummyOfficer officer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminAssignTaskSheet(preSelectedOfficer: officer),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared detail widgets
// ---------------------------------------------------------------------------

class _DetailStatBox extends StatelessWidget {
  const _DetailStatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
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
    ),
  );
}

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

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});
  final DummyTask task;

  @override
  Widget build(BuildContext context) {
    final (priorityColor, _) = _priorityMeta(task.priority);
    final (statusColor, statusLabel) = _statusMeta(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: task.isOverdue
              ? AppColors.error.withValues(alpha: 0.40)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.community}  ·  ${dueDateLabel(task.dueDate)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: task.isOverdue
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});
  final DummyActivity activity;

  @override
  Widget build(BuildContext context) {
    final (badgeColor, badgeLabel) = switch (activity.syncStatus) {
      'synced' => (AppColors.success, 'Synced'),
      'failed' => (AppColors.error, 'Failed'),
      _ => (AppColors.warning, 'Pending'),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityType,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${activity.community}  ·  ${relativeDate(activity.date)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
    );
  }
}

class _BeneficiaryRow extends StatelessWidget {
  const _BeneficiaryRow({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    final dotColor = switch (b.syncStatus) {
      'synced' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.warning,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              b.initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        b.fullName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${b.community}  ·  ${b.businessType}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (b.grantAmount > 0) ...[
            const SizedBox(width: 6),
            Text(
              '₦${(b.grantAmount / 1000).toStringAsFixed(0)}K',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================================
// Assign Task Sheet
// ===========================================================================

class AdminAssignTaskSheet extends StatefulWidget {
  const AdminAssignTaskSheet({super.key, this.preSelectedOfficer});
  final DummyOfficer? preSelectedOfficer;

  @override
  State<AdminAssignTaskSheet> createState() => _AdminAssignTaskSheetState();
}

class _AdminAssignTaskSheetState extends State<AdminAssignTaskSheet> {
  late DummyOfficer? _selectedOfficer;
  String? _selectedTaskType;
  String? _selectedPriority;
  String? _selectedCommunity;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dueDate;
  final _dueDateCtrl = TextEditingController();

  static const _taskTypes = [
    'registration',
    'grant_disbursement',
    'monitoring',
    'medical',
    'education',
    'report',
  ];
  static const _priorities = ['high', 'medium', 'low'];

  @override
  void initState() {
    super.initState();
    _selectedOfficer = widget.preSelectedOfficer;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dueDateCtrl.dispose();
    super.dispose();
  }

  String _taskTypeLabel(String t) => switch (t) {
    'registration' => 'Beneficiary Registration',
    'grant_disbursement' => 'Grant Disbursement',
    'monitoring' => 'Business Monitoring',
    'medical' => 'Medical Support',
    'education' => 'Education / Skills',
    'report' => 'Activity Report',
    _ => t,
  };

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select due date',
    );
    if (picked == null) return;
    setState(() {
      _dueDate = picked;
      _dueDateCtrl.text =
          '${picked.day.toString().padLeft(2, '0')} '
          '${_months[picked.month - 1]} ${picked.year}';
    });
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

  void _submit() {
    if (_selectedOfficer == null ||
        _titleCtrl.text.trim().isEmpty ||
        _selectedTaskType == null ||
        _selectedPriority == null ||
        _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task assigned to ${_selectedOfficer!.name.split(' ').first}',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final communities = _selectedOfficer != null
        ? communitiesForProject(
            _selectedOfficer!.projectId,
          ).map((c) => c.name).toList()
        : <String>[];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.50,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
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
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.add_task, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Assign New Task',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fill in the task details and assign it to an officer.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  // Assign to
                  _buildLabel('Assign to *'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: kAllOfficers.map((o) {
                      final sel = _selectedOfficer?.id == o.id;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedOfficer = o;
                          _selectedCommunity = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: sel
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : AppColors.primary.withValues(alpha: 0.12),
                                child: Text(
                                  o.avatarInitials,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: sel
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                o.name.split(' ').first,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Task title
                  _buildLabel('Task Title *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDec(
                      'e.g. Register 10 new beneficiaries in Gamboru',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Task type
                  _buildLabel('Task Type *'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _taskTypes.map((t) {
                      final sel = _selectedTaskType == t;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTaskType = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            _taskTypeLabel(t),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Community
                  _buildLabel('Community'),
                  const SizedBox(height: 8),
                  if (communities.isEmpty)
                    const Text(
                      'Select an officer first',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: communities.map((c) {
                        final sel = _selectedCommunity == c;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCommunity = c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.primary : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              c,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),

                  // Priority
                  _buildLabel('Priority *'),
                  const SizedBox(height: 8),
                  Row(
                    children: _priorities.map((p) {
                      final sel = _selectedPriority == p;
                      final color = switch (p) {
                        'high' => AppColors.error,
                        'medium' => AppColors.warning,
                        _ => AppColors.textSecondary,
                      };
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPriority = p),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: sel
                                  ? color.withValues(alpha: 0.12)
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: sel ? color : AppColors.border,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p[0].toUpperCase() + p.substring(1),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: sel
                                        ? color
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Due date
                  _buildLabel('Due Date *'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDueDate,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dueDateCtrl,
                        decoration: _inputDec(
                          'Select due date',
                          suffix: const Icon(Icons.calendar_today, size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 4,
                    minLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDec(
                      'Describe what the officer should do…',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.send_outlined, size: 18),
                      label: const Text(
                        'Assign Task',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
  );

  InputDecoration _inputDec(String hint, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.background,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

(Color, String) _priorityMeta(String p) => switch (p) {
  'high' => (AppColors.error, 'High'),
  'medium' => (AppColors.warning, 'Medium'),
  _ => (AppColors.textSecondary, 'Low'),
};

(Color, String) _statusMeta(String s) => switch (s) {
  'in_progress' => (AppColors.primary, 'In progress'),
  'completed' => (AppColors.success, 'Completed'),
  _ => (AppColors.warning, 'Pending'),
};
