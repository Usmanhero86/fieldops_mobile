import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';

// ---------------------------------------------------------------------------
// Dummy sync history entries
// ---------------------------------------------------------------------------

class _SyncHistoryEntry {
  const _SyncHistoryEntry({
    required this.recordCount,
    required this.timestamp,
    required this.success,
  });
  final int recordCount;
  final DateTime timestamp;
  final bool success;
}

final _syncHistory = [
  _SyncHistoryEntry(
    recordCount: 24,
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
    success: true,
  ),
  _SyncHistoryEntry(
    recordCount: 18,
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    success: true,
  ),
  _SyncHistoryEntry(
    recordCount: 7,
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
    success: true,
  ),
  _SyncHistoryEntry(
    recordCount: 3,
    timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    success: false,
  ),
  _SyncHistoryEntry(
    recordCount: 31,
    timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
    success: true,
  ),
];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class SyncCenterPage extends StatefulWidget {
  const SyncCenterPage({super.key});

  @override
  State<SyncCenterPage> createState() => _SyncCenterPageState();
}

class _SyncCenterPageState extends State<SyncCenterPage> {
  // Simulated connection state — toggling shows the online/offline UX
  bool _isOnline = true;
  bool _isSyncing = false;

  int get _pendingBeneficiaries =>
      beneficiariesForOfficer(kCurrentOfficer.id)
          .where((b) => b.syncStatus == 'pending')
          .length;

  int get _pendingActivities =>
      activitiesForOfficer(kCurrentOfficer.id)
          .where((a) => a.syncStatus == 'pending')
          .length;

  int get _failedBeneficiaries =>
      beneficiariesForOfficer(kCurrentOfficer.id)
          .where((b) => b.syncStatus == 'failed')
          .length;

  int get _totalPending => _pendingBeneficiaries + _pendingActivities;

  Future<void> _syncNow() async {
    if (!_isOnline || _isSyncing) return;
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _isSyncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync complete — all records uploaded'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text('Sync Center'),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            actions: [
              // Toggle online/offline (demo only)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _isOnline = !_isOnline),
                  icon: Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    color: Colors.white70,
                    size: 16,
                  ),
                  label: Text(
                    _isOnline ? 'Go offline' : 'Go online',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Connection status card ───────────────────────────────
                  _ConnectionCard(
                    isOnline: _isOnline,
                    lastSyncTime: _syncHistory.first.timestamp,
                  ),
                  const SizedBox(height: 16),

                  // ── Pending records ─────────────────────────────────────
                  _SectionLabel('Pending Records'),
                  const SizedBox(height: 10),

                  if (_totalPending == 0 && _failedBeneficiaries == 0)
                    _AllSyncedCard()
                  else
                    Column(
                      children: [
                        if (_pendingBeneficiaries > 0)
                          _PendingRow(
                            icon: Icons.people_outline,
                            label: 'Beneficiar${_pendingBeneficiaries == 1 ? 'y' : 'ies'}',
                            count: _pendingBeneficiaries,
                            status: 'pending',
                          ),
                        if (_pendingActivities > 0) ...[
                          if (_pendingBeneficiaries > 0)
                            const SizedBox(height: 8),
                          _PendingRow(
                            icon: Icons.assignment_outlined,
                            label:
                                'Activit${_pendingActivities == 1 ? 'y' : 'ies'}',
                            count: _pendingActivities,
                            status: 'pending',
                          ),
                        ],
                        if (_failedBeneficiaries > 0) ...[
                          const SizedBox(height: 8),
                          _PendingRow(
                            icon: Icons.people_outline,
                            label:
                                'Failed beneficiar${_failedBeneficiaries == 1 ? 'y' : 'ies'}',
                            count: _failedBeneficiaries,
                            status: 'failed',
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 20),

                  // ── Sync Now button ─────────────────────────────────────
                  if (_isOnline) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (_isSyncing || _totalPending == 0)
                            ? null
                            : _syncNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.border,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isSyncing
                            ? const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Syncing…',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cloud_sync_outlined,
                                      size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    _totalPending == 0
                                        ? 'All Synced'
                                        : 'Sync Now  ($_totalPending records)',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    // Offline notice
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_off_outlined,
                              color: AppColors.error, size: 36),
                          const SizedBox(height: 10),
                          const Text(
                            'You are offline',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${_totalPending + _failedBeneficiaries} record${(_totalPending + _failedBeneficiaries) == 1 ? '' : 's'} waiting to sync.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Your data is being saved securely on this device.\nIt will automatically sync when internet returns.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Sync history ────────────────────────────────────────
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  _SectionLabel('Sync History'),
                  const SizedBox(height: 12),
                  ..._syncHistory.map((e) => _HistoryRow(entry: e)),
                  const SizedBox(height: 32),
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
// Connection card
// ---------------------------------------------------------------------------

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.isOnline,
    required this.lastSyncTime,
  });
  final bool isOnline;
  final DateTime lastSyncTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection status
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isOnline ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  key: ValueKey(isOnline),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isOnline ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          // Last synced
          Row(
            children: [
              const Icon(Icons.history, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Last synchronized',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                _relativeTime(lastSyncTime),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Today, ${_timeStr(d)}';
    return 'Yesterday, ${_timeStr(d)}';
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
// Pending row
// ---------------------------------------------------------------------------

class _PendingRow extends StatelessWidget {
  const _PendingRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.status,
  });
  final IconData icon;
  final String label;
  final int count;
  final String status; // pending | failed

  @override
  Widget build(BuildContext context) {
    final color =
        status == 'failed' ? AppColors.error : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count $label',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  status == 'failed'
                      ? 'Failed to sync — will retry'
                      : 'Waiting to sync',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            status == 'failed'
                ? Icons.cloud_off_outlined
                : Icons.cloud_upload_outlined,
            color: color,
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// All synced card
// ---------------------------------------------------------------------------

class _AllSyncedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: const Column(
        children: [
          Icon(Icons.cloud_done_outlined,
              color: AppColors.success, size: 36),
          SizedBox(height: 10),
          Text(
            'All records synced',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'No pending data on this device.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// History row
// ---------------------------------------------------------------------------

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});
  final _SyncHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final color =
        entry.success ? AppColors.success : AppColors.error;
    final icon = entry.success
        ? Icons.check_circle_outline
        : Icons.error_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.success
                      ? '${entry.recordCount} records synced'
                      : '${entry.recordCount} records failed',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(entry.timestamp),
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              entry.success ? 'Success' : 'Failed',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;

    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final time = '$hour12:$m $period';

    if (diff == 0) return 'Today, $time';
    if (diff == 1) return 'Yesterday, $time';
    return '${d.day} ${_months[d.month - 1]}, $time';
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}

// ---------------------------------------------------------------------------
// Section label
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
