import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../beneficiaries/presentation/screens/beneficiary_detail_page.dart';

// ── Responsive helpers ────────────────────────────────────────────────────────
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;

double _hPad(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return 32;
  if (w < 400) return 12;
  return 16;
}

/// Full beneficiary register across all field officers.
/// Filterable by officer, project, and sync status.
class AdminBeneficiariesPage extends StatefulWidget {
  const AdminBeneficiariesPage({super.key});

  @override
  State<AdminBeneficiariesPage> createState() => _AdminBeneficiariesPageState();
}

class _AdminBeneficiariesPageState extends State<AdminBeneficiariesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _officerFilter;
  String? _projectFilter;
  String? _syncFilter;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DummyBeneficiary> get _filtered {
    return kAllBeneficiaries.where((b) {
      final q = _query.toLowerCase();
      final matchSearch =
          _query.isEmpty ||
          b.fullName.toLowerCase().contains(q) ||
          b.community.toLowerCase().contains(q) ||
          b.lga.toLowerCase().contains(q) ||
          b.businessType.toLowerCase().contains(q);
      final matchOfficer =
          _officerFilter == null || b.fieldOfficerId == _officerFilter;
      final matchProject =
          _projectFilter == null || b.projectId == _projectFilter;
      final matchSync = _syncFilter == null || b.syncStatus == _syncFilter;
      return matchSearch && matchOfficer && matchProject && matchSync;
    }).toList()..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
  }

  bool get _hasFilter =>
      _officerFilter != null || _projectFilter != null || _syncFilter != null;

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final total = kAllBeneficiaries.length;
    final totalGrants = kAllBeneficiaries.fold<double>(
      0,
      (s, b) => s + b.grantAmount,
    );
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
                            'Beneficiaries',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: narrow ? 17 : 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'All officers · All projects',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
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
                          color: _hasFilter
                              ? AppColors.warning
                              : Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _hasFilter
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
                const SizedBox(height: 10),
                // Grants total chip — shortened on narrow
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        narrow
                            ? '₦${(totalGrants / 1000000).toStringAsFixed(1)}M grants'
                            : 'Total grants: ₦${(totalGrants / 1000000).toStringAsFixed(2)}M',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 12, hp, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: narrow
                    ? 'Search…'
                    : 'Search name, community, business…',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
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
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ── Count ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 2, hp, 6),
            child: Text(
              '${list.length} of $total beneficiar${total == 1 ? 'y' : 'ies'}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // ── List / grid ──────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ? const _EmptyState()
                : wide
                ? GridView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 0, hp, 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.6,
                        ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _AdminBeneficiaryTile(b: list[i]),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 0, hp, 40),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _AdminBeneficiaryTile(b: list[i]),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
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
                'Filter Beneficiaries',
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
              const SizedBox(height: 14),
              const Text(
                'Project',
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
                    selected: _projectFilter == null,
                    onTap: () =>
                        setSheet(() => setState(() => _projectFilter = null)),
                  ),
                  ...kProjects.map(
                    (p) => _FilterChip(
                      label: p.name.split(' ').first,
                      selected: _projectFilter == p.id,
                      onTap: () =>
                          setSheet(() => setState(() => _projectFilter = p.id)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Sync Status',
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
                    selected: _syncFilter == null,
                    onTap: () =>
                        setSheet(() => setState(() => _syncFilter = null)),
                  ),
                  for (final s in ['synced', 'pending', 'failed'])
                    _FilterChip(
                      label: _cap(s),
                      selected: _syncFilter == s,
                      onTap: () =>
                          setSheet(() => setState(() => _syncFilter = s)),
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

  static String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

// ---------------------------------------------------------------------------
// Beneficiary tile
// ---------------------------------------------------------------------------

class _AdminBeneficiaryTile extends StatelessWidget {
  const _AdminBeneficiaryTile({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    final narrow = _isNarrow(context);
    final dotColor = switch (b.syncStatus) {
      'synced' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.warning,
    };
    final officer = kAllOfficers.firstWhere(
      (o) => o.id == b.fieldOfficerId,
      orElse: () => kCurrentOfficer,
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BeneficiaryDetailPage(beneficiary: b),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: narrow ? 10 : 14,
          vertical: narrow ? 10 : 12,
        ),
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
          children: [
            // Avatar
            CircleAvatar(
              radius: narrow ? 19 : 22,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                b.initials,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: narrow ? 11 : 13,
                ),
              ),
            ),
            SizedBox(width: narrow ? 8 : 12),

            // Name + details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          b.fullName,
                          style: TextStyle(
                            fontSize: narrow ? 13 : 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
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
                  const SizedBox(height: 2),
                  Text(
                    '${b.community}  ·  ${b.lga}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.businessType.isEmpty
                        ? 'No business type'
                        : b.businessType,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        size: 10,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          officer.name,
                          style: const TextStyle(
                            fontSize: 10,
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

            // Grant + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (b.grantAmount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₦${(b.grantAmount / 1000).toStringAsFixed(0)}K',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  )
                else
                  const Text(
                    'No grant',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 17,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
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
        'No beneficiaries match the filters',
        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
