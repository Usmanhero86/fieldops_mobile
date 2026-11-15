import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/themes/app_colors.dart';

/// "MY TASKS" section on the dashboard.
///
/// Shows the pending/in-progress tasks assigned to the current officer by
/// the Supervisor or Admin. Completed tasks are excluded. Tapping a task
/// card opens [DashboardTaskDetailSheet] as a bottom sheet.
class DashboardMyTasks extends StatelessWidget {
  const DashboardMyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = pendingTasksForOfficer(kCurrentOfficer.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ────────────────────────────────────────────
        Row(
          children: [
            const Expanded(
              child: Text(
                'MY TASKS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (tasks.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${tasks.length} pending',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Task list ─────────────────────────────────────────────────
        if (tasks.isEmpty)
          _AllDoneCard()
        else
          ...tasks.map((t) => _TaskCard(task: t)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state — no pending tasks
// ---------------------------------------------------------------------------

class _AllDoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.25),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.task_alt, color: AppColors.success, size: 22),
          SizedBox(width: 12),
          Text(
            'No pending tasks — great work!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single task card
// ---------------------------------------------------------------------------

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});
  final DummyTask task;

  @override
  Widget build(BuildContext context) {
    final (priorityColor, priorityLabel) = _priorityMeta(task.priority);
    final (statusColor, statusLabel) = _statusMeta(task.status);
    final (typeIcon, typeColor) = _typeMeta(task.taskType);
    final overdue = task.isOverdue;

    return GestureDetector(
      onTap: () => _showDetail(context, task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: overdue
                ? AppColors.error.withValues(alpha: 0.40)
                : AppColors.border,
          ),
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
            // Type icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: typeColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.community}  ·  Assigned by ${task.assignedBy}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      // Priority badge
                      _Badge(
                        label: priorityLabel,
                        color: priorityColor,
                        dot: true,
                      ),
                      // Status badge
                      _Badge(label: statusLabel, color: statusColor),
                      // Due date
                      _Badge(
                        label: dueDateLabel(task.dueDate),
                        color: overdue ? AppColors.error : AppColors.textSecondary,
                        icon: Icons.schedule_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, DummyTask task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DashboardTaskDetailSheet(task: task),
    );
  }
}

// ---------------------------------------------------------------------------
// Small badge pill
// ---------------------------------------------------------------------------

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    this.dot = false,
    this.icon,
  });
  final String label;
  final Color color;
  final bool dot;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            )
          else if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(icon, size: 10, color: color),
            ),
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

// ---------------------------------------------------------------------------
// Task detail bottom sheet
// ---------------------------------------------------------------------------

class DashboardTaskDetailSheet extends StatelessWidget {
  const DashboardTaskDetailSheet({super.key, required this.task});
  final DummyTask task;

  @override
  Widget build(BuildContext context) {
    final (priorityColor, priorityLabel) = _priorityMeta(task.priority);
    final (statusColor, statusLabel) = _statusMeta(task.status);
    final (typeIcon, typeColor) = _typeMeta(task.taskType);
    final overdue = task.isOverdue;

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  // ── Header ───────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(typeIcon, color: typeColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Assigned by ${task.assignedBy}',
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

                  // ── Status badges ─────────────────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Badge(
                          label: priorityLabel,
                          color: priorityColor,
                          dot: true),
                      _Badge(label: statusLabel, color: statusColor),
                      _Badge(
                        label: dueDateLabel(task.dueDate),
                        color: overdue
                            ? AppColors.error
                            : AppColors.textSecondary,
                        icon: Icons.schedule_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── Description ───────────────────────────────────────
                  const _SheetSectionLabel('Description'),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Details card ──────────────────────────────────────
                  const _SheetSectionLabel('Details'),
                  const SizedBox(height: 8),
                  _DetailsCard(task: task),
                  const SizedBox(height: 24),

                  // ── Action buttons ────────────────────────────────────
                  if (task.status == 'pending')
                    _ActionButton(
                      label: 'Mark as In Progress',
                      icon: Icons.play_circle_outline,
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task marked in progress'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  if (task.status == 'in_progress') ...[
                    _ActionButton(
                      label: 'Submit Report & Complete',
                      icon: Icons.send_outlined,
                      color: AppColors.success,
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Report submitted — task marked complete'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetSectionLabel extends StatelessWidget {
  const _SheetSectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.textSecondary,
        ),
      );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.task});
  final DummyTask task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.location_city_outlined,
            label: 'Community',
            value: task.community,
          ),
          const Divider(height: 1, indent: 44, color: AppColors.border),
          _DetailRow(
            icon: Icons.folder_open_outlined,
            label: 'Project',
            value: kProjects
                .firstWhere(
                  (p) => p.id == task.projectId,
                  orElse: () => kCurrentProject,
                )
                .name,
          ),
          const Divider(height: 1, indent: 44, color: AppColors.border),
          _DetailRow(
            icon: Icons.schedule_outlined,
            label: 'Due date',
            value: _fmtDate(task.dueDate),
          ),
          const Divider(height: 1, indent: 44, color: AppColors.border),
          _DetailRow(
            icon: Icons.category_outlined,
            label: 'Task type',
            value: _taskTypeLabel(task.taskType),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers (file-private)
// ---------------------------------------------------------------------------

(Color, String) _priorityMeta(String p) => switch (p) {
      'high' => (AppColors.error, 'High priority'),
      'medium' => (AppColors.warning, 'Medium priority'),
      _ => (AppColors.textSecondary, 'Low priority'),
    };

(Color, String) _statusMeta(String s) => switch (s) {
      'in_progress' => (AppColors.primary, 'In progress'),
      'completed' => (AppColors.success, 'Completed'),
      _ => (AppColors.warning, 'Pending'),
    };

(IconData, Color) _typeMeta(String t) => switch (t) {
      'registration' => (Icons.person_add_outlined, AppColors.primary),
      'grant_disbursement' => (Icons.payments_outlined, AppColors.success),
      'monitoring' => (Icons.visibility_outlined, const Color(0xFF00838F)),
      'medical' => (Icons.medical_services_outlined, AppColors.error),
      'education' => (Icons.school_outlined, const Color(0xFF6A1B9A)),
      'report' => (Icons.summarize_outlined, AppColors.warning),
      _ => (Icons.task_outlined, AppColors.textSecondary),
    };

String _taskTypeLabel(String t) => switch (t) {
      'registration' => 'Beneficiary Registration',
      'grant_disbursement' => 'Grant Disbursement',
      'monitoring' => 'Business Monitoring',
      'medical' => 'Medical Support',
      'education' => 'Education / Skills',
      'report' => 'Activity Report',
      _ => 'General Task',
    };
