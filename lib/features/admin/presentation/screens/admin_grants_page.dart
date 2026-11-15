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

/// Admin view: all grant disbursements across all officers.
/// Each tile shows the beneficiary, officer, business type, and grant amount.
class AdminGrantsPage extends StatefulWidget {
  const AdminGrantsPage({super.key});

  @override
  State<AdminGrantsPage> createState() => _AdminGrantsPageState();
}

class _AdminGrantsPageState extends State<AdminGrantsPage> {
  String? _officerFilter;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DummyBeneficiary> get _list {
    return kAllBeneficiaries.where((b) {
      if (b.grantAmount <= 0) return false;
      final matchOfficer =
          _officerFilter == null || b.fieldOfficerId == _officerFilter;
      if (!matchOfficer) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return b.fullName.toLowerCase().contains(q) ||
          b.businessType.toLowerCase().contains(q) ||
          b.community.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
  }

  @override
  Widget build(BuildContext context) {
    final list = _list;
    final total =
        list.fold<double>(0, (s, b) => s + b.grantAmount);
    final hp = _hPad(context);
    final narrow = _isNarrow(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.success,
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
                            'Grants Disbursed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: narrow ? 17 : 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${list.length} beneficiar${list.length == 1 ? 'y' : 'ies'}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Total badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₦${(total / 1000000).toStringAsFixed(2)}M',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Filter chips ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 10, hp, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _OfficerChip(
                    label: 'All Officers',
                    selected: _officerFilter == null,
                    onTap: () =>
                        setState(() => _officerFilter = null),
                  ),
                  ...kAllOfficers.map((o) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _OfficerChip(
                          label: o.name.split(' ').first,
                          selected: _officerFilter == o.id,
                          onTap: () =>
                              setState(() => _officerFilter = o.id),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // ── Search ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 10, hp, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'Search name, business, community…',
                hintStyle: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textSecondary, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(Icons.close,
                            size: 18,
                            color: AppColors.textSecondary),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.success, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Count ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hp, 2, hp, 6),
            child: Text(
              '${list.length} grant${list.length == 1 ? '' : 's'} · total ₦${(total / 1000000).toStringAsFixed(2)}M',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),

          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(hp, 0, hp, 40),
                    itemCount: list.length,
                    itemBuilder: (_, i) =>
                        _GrantTile(b: list[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grant tile
// ---------------------------------------------------------------------------

class _GrantTile extends StatelessWidget {
  const _GrantTile({required this.b});
  final DummyBeneficiary b;

  @override
  Widget build(BuildContext context) {
    final officer = kAllOfficers.firstWhere(
      (o) => o.id == b.fieldOfficerId,
      orElse: () => kCurrentOfficer,
    );
    final dotColor = switch (b.syncStatus) {
      'synced' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.warning,
    };

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BeneficiaryDetailPage(beneficiary: b)),
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
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  AppColors.success.withValues(alpha: 0.12),
              child: const Icon(Icons.payments_outlined,
                  color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 12),
            // Details
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: dotColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.businessType,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 9,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          officer.avatarInitials,
                          style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          officer.name,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Grant amount + date + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            AppColors.success.withValues(alpha: 0.30)),
                  ),
                  child: Text(
                    b.formattedGrant,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  relativeDate(b.registeredAt),
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.textSecondary),
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

class _OfficerChip extends StatelessWidget {
  const _OfficerChip({
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.success : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.success : AppColors.border,
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
  Widget build(BuildContext context) => const Center(
        child: Text(
          'No grant records found',
          style: TextStyle(
              fontSize: 14, color: AppColors.textSecondary),
        ),
      );
}
