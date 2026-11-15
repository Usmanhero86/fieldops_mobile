import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import 'report_screen_size.dart';

// ---------------------------------------------------------------------------
// White card container used by every section
// ---------------------------------------------------------------------------

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Coloured tile showing a count + percentage (gender / age groups)
// ---------------------------------------------------------------------------

class ReportBreakdownTile extends StatelessWidget {
  const ReportBreakdownTile({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    required this.icon,
    required this.screen,
  });

  final String label;
  final int count;
  final int total;
  final Color color;
  final IconData icon;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    final valueFontSize = screen == ReportScreenSize.narrow ? 15.0 : 18.0;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(
              '$count',
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small stat box (icon + value + label)
// ---------------------------------------------------------------------------

class ReportStatBox extends StatelessWidget {
  const ReportStatBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Labelled horizontal divider used inside cards
// ---------------------------------------------------------------------------

class ReportRowDivider extends StatelessWidget {
  const ReportRowDivider({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state shown when a section has no data
// ---------------------------------------------------------------------------

class ReportEmptySection extends StatelessWidget {
  const ReportEmptySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportCard(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'No data for this project',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
