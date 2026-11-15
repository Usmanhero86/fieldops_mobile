import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../beneficiaries/presentation/screens/beneficiary_detail_page.dart';

bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
double _hPad(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return 32;
  if (w < 400) return 12;
  return 16;
}

/// Admin: all pending (and failed) records across every officer.
class AdminPendingSyncPage extends StatelessWidget {
  const AdminPendingSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingBenefs = kAllBeneficiaries
        .where((b) => b.syncStatus != 'synced')
        .toList()
      ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
    final pendingActs = kAllActivities
        .where((a) => a.syncStatus != 'synced')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final total = pendingBenefs.length + pendingActs.length;
    final hp = _hPad(context);
    final narrow = _isNarrow(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.warning,
            padding: EdgeInsets.fromLTRB(
              hp,
              MediaQuery.of(context).padding.top + 14,
              hp,
              18,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 22),
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
                        '$total item${total == 1 ? '' : 's'} awaiting upload · all officers',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
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
                  child: const Icon(Icons.cloud_upload_outlined,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // ── Info banner ────────────────────────────────────────────────
          if (total > 0)
            Padding(
              padding: EdgeInsets.fromLTRB(hp, 12, hp, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.35)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off,
                        color: AppColors.warning, size: 16),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'These records are saved on officers\' devices and '
                        'will upload automatically when they are online.',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: total == 0
                ? const _AllSyncedState()
                : ListView(
                    padding:
                        EdgeInsets.fromLTRB(hp, 12, hp, 40),
                    children: [
                      // ── Beneficiary records ──────────────────────────
                      if (pendingBenefs.isNotEmpty) ...[
                        _SectionHeader(
                          label: 'Beneficiary Records',
                          count: pendingBenefs.length,
                          icon: Icons.people_outline,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        ...pendingBenefs.map(
                            (b) => _PendingBenefTile(b: b)),
                        const SizedBox(height: 16),
                      ],
                      // ── Activity records ─────────────────────────────
                      if (pendingActs.isNotEmpty) ...[
                        _SectionHeader(
                          label: 'Activity Records',
                          count: pendingActs.length,
                          icon: Icons.assignment_outlined,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        ...pendingActs.map(
                            (a) => _PendingActivityTile(a: a)),
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
                color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Divider(color: color.withValues(alpha: 0.30))),
        ],
      );
}

// ---------------------------------------------------------------------------
// Pending beneficiary tile
// ---------------------------------------------------------------------------

class _PendingBenefTile extends StatelessWidget {
  const _PendingBenefTile({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    final isFailed = b.syncStatus == 'failed';
    final color = isFailed ? AppColors.error : AppColors.warning;
    final statusLabel = isFailed ? 'Failed' : 'Pending';
    final officer = kAllOfficers.firstWhere(
        (o) => o.id == b.fieldOfficerId,
        orElse: () => kCurrentOfficer);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BeneficiaryDetailPage(beneficiary: b)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
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
              radius: 20,
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.10),
              child: Text(
                b.initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
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
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${b.community}, ${b.lga}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Officer tag
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          officer.avatarInitials,
                          style: const TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          officer.name,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFailed
                            ? Icons.error_outline
                            : Icons.cloud_upload_outlined,
                        size: 11,
                        color: color,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right,
                    size: 16, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
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
    final statusLabel = isFailed ? 'Failed' : 'Pending';
    final officer = kAllOfficers.firstWhere(
        (o) => o.id == a.fieldOfficerId,
        orElse: () => kCurrentOfficer);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment_outlined,
                color: AppColors.success, size: 20),
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
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${a.community}, ${a.lga}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                      child: Text(
                        officer.avatarInitials,
                        style: const TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${officer.name}  ·  ${relativeDate(a.date)}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFailed
                      ? Icons.error_outline
                      : Icons.cloud_upload_outlined,
                  size: 11,
                  color: color,
                ),
                const SizedBox(width: 3),
                Text(
                  statusLabel,
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
// All synced empty state
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
              child: const Icon(Icons.cloud_done_outlined,
                  color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'All synced!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'All records from all officers have been uploaded.',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
