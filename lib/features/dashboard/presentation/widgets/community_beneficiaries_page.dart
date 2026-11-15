import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import 'beneficiaries_list_tile.dart';

class CommunityBeneficiariesPage extends StatelessWidget {
  const CommunityBeneficiariesPage({
    required this.community,
    required this.beneficiaries,
    super.key
  });

  final DummyCommunity community;
  final List<DummyBeneficiary> beneficiaries;

  @override
  Widget build(BuildContext context) {
    bool isNarrow(BuildContext ctx) => MediaQuery.of(ctx).size.width < 400;

    EdgeInsets _rp(BuildContext ctx) {
      final w = MediaQuery.of(ctx).size.width;
      if (w >= 600) return const EdgeInsets.symmetric(horizontal: 32);
      if (w < 400) return const EdgeInsets.symmetric(horizontal: 12);
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    final narrow = isNarrow(context);
    final rp = _rp(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
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
                        '${beneficiaries.length} registered  ·  '
                            '${community.name}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── List ────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: rp.copyWith(top: 16, bottom: 40),
              itemCount: beneficiaries.length,
              itemBuilder: (_, i) => BeneficiaryListTile(b: beneficiaries[i]),
            ),
          ),
        ],
      ),
    );
  }
}
