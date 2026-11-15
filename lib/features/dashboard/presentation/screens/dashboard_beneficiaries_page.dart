import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../features/beneficiaries/presentation/screens/beneficiary_detail_page.dart';
import '../widgets/dashboard_beneficiary_tile.dart';
import '../widgets/dashboard_empty_state.dart';

// Responsive helpers
// narrow < 400 dp · normal 400–599 dp · wide ≥ 600 dp
bool _isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;
bool _isWide(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 600;

/// Horizontal content padding that scales with screen width.
EdgeInsets _rp(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
  if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
  return const EdgeInsets.symmetric(horizontal: 16);
}

/// List of beneficiaries registered by the current officer.
/// Tapping a tile opens [BeneficiaryDetailPage].
class DashboardBeneficiariesPage extends StatefulWidget {
  const DashboardBeneficiariesPage({super.key});

  @override
  State<DashboardBeneficiariesPage> createState() =>
      _DashboardBeneficiariesPageState();
}

class _DashboardBeneficiariesPageState
    extends State<DashboardBeneficiariesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DummyBeneficiary> get _list {
    final all = beneficiariesForOfficer(kCurrentOfficer.id);
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all.where((b) {
      return b.fullName.toLowerCase().contains(q) ||
          b.community.toLowerCase().contains(q) ||
          b.lga.toLowerCase().contains(q) ||
          b.vulnerabilityCategory.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _list;
    final total = beneficiariesForOfficer(kCurrentOfficer.id).length;
    final pending = beneficiariesForOfficer(
      kCurrentOfficer.id,
    ).where((b) => b.syncStatus == 'pending').length;
    final rp = _rp(context);
    final narrow = _isNarrow(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.primary,
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
                        'Beneficiaries',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: narrow ? 17 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$total registered  ·  ${kCurrentProject.name}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (pending > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: narrow ? 7 : 10,
                      vertical: 6,
                    ),
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
                          narrow ? '$pending' : '$pending pending',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ── Search bar ────────────────────────────────────────────────
          Padding(
            padding: rp.copyWith(top: 12, bottom: 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: narrow
                    ? 'Search…'
                    : 'Search by name, community, LGA…',
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

          // ── Count ─────────────────────────────────────────────────────
          Padding(
            padding: rp.copyWith(top: 4, bottom: 6),
            child: Text(
              '${list.length} of $total '
              'beneficiar${list.length == 1 ? 'y' : 'ies'}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // ── List ──────────────────────────────────────────────────────
          Expanded(
            child: list.isEmpty
                ?  DashboardEmptyState()
                : _isWide(context)
                // Wide: 2-column grid
                ? GridView.builder(
                    padding: rp.copyWith(bottom: 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.8,
                        ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => DashboardBeneficiaryTile(b: list[i]),
                  )
                : ListView.builder(
                    padding: rp.copyWith(bottom: 40),
                    itemCount: list.length,
                    itemBuilder: (_, i) => DashboardBeneficiaryTile(b: list[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(
          narrow ? 'Register' : 'Register Beneficiary',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, AppRouter.beneficiaryRegister);
          setState(() {});
        },
      ),
    );
  }
}

