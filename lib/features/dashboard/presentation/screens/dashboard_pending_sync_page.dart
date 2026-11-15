import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';

// Responsive helpers
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;

EdgeInsets _rp(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
  if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
  return const EdgeInsets.symmetric(horizontal: 16);
}

/// Shows all pending (and failed) beneficiary and activity records for the
/// current officer so the user can see what is waiting to be synced.
class DashboardPendingSyncPage extends StatelessWidget {
  const DashboardPendingSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingBeneficiaries = beneficiariesForOfficer(
      kCurrentOfficer.id,
    ).where((b) => b.syncStatus != 'synced').toList();
    final pendingActivities = activitiesForOfficer(
      kCurrentOfficer.id,
    ).where((a) => a.syncStatus != 'synced').toList();

    final totalPending = pendingBeneficiaries.length + pendingActivities.length;
    final narrow = _isNarrow(context);
    final rp = _rp(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.warning,
            padding: EdgeInsets.fromLTRB(
              rp.horizontal / 2,
              MediaQuery.of(context).padding.top + 14,
              rp.horizontal / 2,
              18,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Sync',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: narrow ? 17 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$totalPending item${totalPending == 1 ? '' : 's'} '
                        'awaiting upload',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // ── Info banner ───────────────────────────────────────────────
          if (totalPending > 0)
            Padding(
              padding: rp.copyWith(top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off, color: AppColors.warning, size: 16),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'These records are saved on your device. '
                        'They will upload automatically when you are online.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: totalPending == 0
                ? const _AllSyncedState()
                : ListView(
                    padding: rp.copyWith(top: 12, bottom: 40),
                    children: [
                      if (pendingBeneficiaries.isNotEmpty) ...[
                        _SectionHeader(
                          label: 'Beneficiaries',
                          count: pendingBeneficiaries.length,
                          icon: Icons.people_outline,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        ...pendingBeneficiaries.map(
                          (b) => _PendingBeneficiaryTile(b: b),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (pendingActivities.isNotEmpty) ...[
                        _SectionHeader(
                          label: 'Activities',
                          count: pendingActivities.length,
                          icon: Icons.assignment_outlined,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        ...pendingActivities.map(
                          (a) => _PendingActivityTile(a: a),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Text(
        '$label ($count)',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: color,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(child: Divider(color: color.withValues(alpha: 0.30))),
    ],
  );
}

// ---------------------------------------------------------------------------
// Pending beneficiary tile
// ---------------------------------------------------------------------------

class _PendingBeneficiaryTile extends StatelessWidget {
  const _PendingBeneficiaryTile({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    final isFailed = b.syncStatus == 'failed';
    final color = isFailed ? AppColors.error : AppColors.warning;
    final label = isFailed ? 'Failed' : 'Pending';
    final narrow = _isNarrow(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(narrow ? 10 : 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: narrow ? 17 : 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            child: Text(
              b.initials,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: narrow ? 11 : 12,
              ),
            ),
          ),
          SizedBox(width: narrow ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.fullName,
                  style: TextStyle(
                    fontSize: narrow ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${b.gender}  ·  ${b.community}, ${b.lga}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Registered: ${relativeDate(b.registeredAt)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFailed ? Icons.error_outline : Icons.cloud_upload_outlined,
                  size: 11,
                  color: color,
                ),
                const SizedBox(width: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
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
// Pending activity tile
// ---------------------------------------------------------------------------

class _PendingActivityTile extends StatelessWidget {
  const _PendingActivityTile({required this.a});
  final DummyActivity a;

  @override
  Widget build(BuildContext context) {
    final isFailed = a.syncStatus == 'failed';
    final color = isFailed ? AppColors.error : AppColors.warning;
    final label = isFailed ? 'Failed' : 'Pending';
    final narrow = _isNarrow(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(narrow ? 10 : 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: narrow ? 36 : 40,
            height: narrow ? 36 : 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: AppColors.success,
              size: narrow ? 17 : 20,
            ),
          ),
          SizedBox(width: narrow ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.activityType,
                  style: TextStyle(
                    fontSize: narrow ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${a.community}, ${a.lga}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${a.totalParticipants} participants  ·  '
                  '${relativeDate(a.date)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFailed ? Icons.error_outline : Icons.cloud_upload_outlined,
                  size: 11,
                  color: color,
                ),
                const SizedBox(width: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
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
// All-synced empty state
// ---------------------------------------------------------------------------

class _AllSyncedState extends StatelessWidget {
  const _AllSyncedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_done_outlined,
                color: AppColors.success,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'All synced!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'All records have been uploaded to the server.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
