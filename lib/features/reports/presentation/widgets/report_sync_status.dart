import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import '../../../../../core/themes/app_colors.dart';
import 'report_shared_widgets.dart';

/// Card showing synced / pending / failed counts for both beneficiary
/// and activity records.
class ReportSyncStatus extends StatelessWidget {
  const ReportSyncStatus({
    super.key,
    required this.beneficiaries,
    required this.activities,
  });

  final List<DummyBeneficiary> beneficiaries;
  final List<DummyActivity> activities;

  @override
  Widget build(BuildContext context) {
    final bSynced =
        beneficiaries.where((b) => b.syncStatus == 'synced').length;
    final bPending =
        beneficiaries.where((b) => b.syncStatus == 'pending').length;
    final bFailed =
        beneficiaries.where((b) => b.syncStatus == 'failed').length;
    final aSynced = activities.where((a) => a.syncStatus == 'synced').length;
    final aPending = activities.where((a) => a.syncStatus == 'pending').length;
    final aFailed = activities.where((a) => a.syncStatus == 'failed').length;

    return ReportCard(
      child: Column(
        children: [
          ReportSyncRow(
            label: 'Beneficiary records',
            synced: bSynced,
            pending: bPending,
            failed: bFailed,
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          ReportSyncRow(
            label: 'Activity records',
            synced: aSynced,
            pending: aPending,
            failed: aFailed,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row for one record type (beneficiaries or activities)
// ---------------------------------------------------------------------------

class ReportSyncRow extends StatelessWidget {
  const ReportSyncRow({
    super.key,
    required this.label,
    required this.synced,
    required this.pending,
    required this.failed,
  });

  final String label;
  final int synced;
  final int pending;
  final int failed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        // Wrap lets badges flow onto a second line on very narrow screens
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ReportSyncBadge(
              count: synced,
              label: 'Synced',
              color: AppColors.success,
            ),
            ReportSyncBadge(
              count: pending,
              label: 'Pending',
              color: AppColors.warning,
            ),
            ReportSyncBadge(
              count: failed,
              label: 'Failed',
              color: AppColors.error,
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Individual pill badge
// ---------------------------------------------------------------------------

class ReportSyncBadge extends StatelessWidget {
  const ReportSyncBadge({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
