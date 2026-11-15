import 'package:flutter/material.dart';

import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import 'beneficiary_detail_page.dart';

class BeneficiaryListPage extends StatefulWidget {
  const BeneficiaryListPage({super.key});

  @override
  State<BeneficiaryListPage> createState() => _BeneficiaryListPageState();
}

class _BeneficiaryListPageState extends State<BeneficiaryListPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  // Active filters — null means "no filter applied"
  String? _genderFilter; // 'Male' | 'Female'
  String? _communityFilter;
  String? _syncFilter; // 'pending' | 'synced' | 'failed'

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DummyBeneficiary> get _filtered {
    return beneficiariesForOfficer(kCurrentOfficer.id).where((b) {
      final q = _query.toLowerCase();
      final matchSearch =
          _query.isEmpty ||
          b.fullName.toLowerCase().contains(q) ||
          b.community.toLowerCase().contains(q) ||
          b.lga.toLowerCase().contains(q);
      final matchGender = _genderFilter == null || b.gender == _genderFilter;
      final matchCommunity =
          _communityFilter == null || b.community == _communityFilter;
      final matchSync = _syncFilter == null || b.syncStatus == _syncFilter;
      return matchSearch && matchGender && matchCommunity && matchSync;
    }).toList();
  }

  int get _pendingCount => beneficiariesForOfficer(
    kCurrentOfficer.id,
  ).where((b) => b.syncStatus == 'pending').length;

  bool get _hasActiveFilter =>
      _genderFilter != null || _communityFilter != null || _syncFilter != null;

  void _clearFilters() => setState(() {
    _genderFilter = null;
    _communityFilter = null;
    _syncFilter = null;
  });

  void _showFilterSheet() {
    final communities = communitiesForProject(
      kCurrentProject.id,
    ).map((c) => c.name).toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
              // Handle
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (_hasActiveFilter)
                    TextButton(
                      onPressed: () {
                        _clearFilters();
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Clear all',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Gender
              _SheetSection(
                label: 'Gender',
                chips: ['Male', 'Female'],
                selected: _genderFilter,
                onSelect: (v) {
                  setSheetState(() {});
                  setState(() => _genderFilter = _genderFilter == v ? null : v);
                },
              ),
              const SizedBox(height: 16),

              // Sync status
              _SheetSection(
                label: 'Sync Status',
                chips: ['pending', 'synced', 'failed'],
                chipLabels: const ['Pending', 'Synced', 'Failed'],
                selected: _syncFilter,
                onSelect: (v) {
                  setSheetState(() {});
                  setState(() => _syncFilter = _syncFilter == v ? null : v);
                },
              ),
              const SizedBox(height: 16),

              // Community
              _SheetSection(
                label: 'Community',
                chips: communities,
                selected: _communityFilter,
                onSelect: (v) {
                  setSheetState(() {});
                  setState(
                    () => _communityFilter = _communityFilter == v ? null : v,
                  );
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
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
                    'Apply Filters',
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

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final total = beneficiariesForOfficer(kCurrentOfficer.id).length;
    final pending = _pendingCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _Header(
            total: total,
            pending: pending,
            onFilterTap: _showFilterSheet,
            hasActiveFilter: _hasActiveFilter,
          ),

          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search name, community, LGA…',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ),

          // ── Active filter pills ──────────────────────────────────────────
          if (_hasActiveFilter)
            _ActiveFilterBar(
              genderFilter: _genderFilter,
              communityFilter: _communityFilter,
              syncFilter: _syncFilter,
              onRemoveGender: () => setState(() => _genderFilter = null),
              onRemoveCommunity: () => setState(() => _communityFilter = null),
              onRemoveSync: () => setState(() => _syncFilter = null),
            ),

          // ── Count ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Text(
                  '${list.length} of $total beneficiar${list.length == 1 ? 'y' : 'ies'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ? _EmptyState(hasFilter: _hasActiveFilter || _query.isNotEmpty)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _BeneficiaryCard(b: list[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () =>
            Navigator.pushNamed(context, AppRouter.beneficiaryRegister),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.total,
    required this.pending,
    required this.onFilterTap,
    required this.hasActiveFilter,
  });

  final int total;
  final int pending;
  final VoidCallback onFilterTap;
  final bool hasActiveFilter;

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
                  'Beneficiaries',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$total registered  ·  ${kCurrentProject.name}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          // Filter button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: hasActiveFilter
                    ? AppColors.warning
                    : Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasActiveFilter
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
          if (pending > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
// Active filter pills
// ---------------------------------------------------------------------------

class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({
    required this.genderFilter,
    required this.communityFilter,
    required this.syncFilter,
    required this.onRemoveGender,
    required this.onRemoveCommunity,
    required this.onRemoveSync,
  });

  final String? genderFilter;
  final String? communityFilter;
  final String? syncFilter;
  final VoidCallback onRemoveGender;
  final VoidCallback onRemoveCommunity;
  final VoidCallback onRemoveSync;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (genderFilter != null)
              _ActivePill(label: genderFilter!, onRemove: onRemoveGender),
            if (communityFilter != null)
              _ActivePill(label: communityFilter!, onRemove: onRemoveCommunity),
            if (syncFilter != null)
              _ActivePill(
                label: _capitalize(syncFilter!),
                onRemove: onRemoveSync,
              ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _ActivePill extends StatelessWidget {
  const _ActivePill({required this.label, required this.onRemove});
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Beneficiary card
// ---------------------------------------------------------------------------

class _BeneficiaryCard extends StatelessWidget {
  const _BeneficiaryCard({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BeneficiaryDetailPage(beneficiary: b),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                b.initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + sync dot
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          b.fullName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _SyncDot(status: b.syncStatus),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Gender · community
                  Row(
                    children: [
                      Icon(
                        b.gender == 'Female' ? Icons.female : Icons.male,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${b.gender}  ·  ${b.community}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Registration date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Registered: ${_fmtDate(b.registeredAt)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      // GPS / photo indicators
                      if (b.hasGps)
                        const Icon(
                          Icons.gps_fixed,
                          size: 12,
                          color: AppColors.success,
                        ),
                      if (b.hasPhoto) ...[
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.photo_camera_outlined,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
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
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

// ---------------------------------------------------------------------------
// Filter bottom sheet helpers
// ---------------------------------------------------------------------------

class _SheetSection extends StatelessWidget {
  const _SheetSection({
    required this.label,
    required this.chips,
    required this.selected,
    required this.onSelect,
    this.chipLabels,
  });

  final String label;
  final List<String> chips;
  final List<String>? chipLabels;
  final String? selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(chips.length, (i) {
            final value = chips[i];
            final displayLabel = chipLabels != null ? chipLabels![i] : value;
            final active = selected == value;
            return GestureDetector(
              onTap: () => onSelect(value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  displayLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

class _SyncDot extends StatelessWidget {
  const _SyncDot({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'synced' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.warning,
    };
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter});
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasFilter ? Icons.search_off : Icons.people_outline,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 14),
          Text(
            hasFilter
                ? 'No beneficiaries match your filters'
                : 'No beneficiaries registered yet',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
