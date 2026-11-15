import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';

/// Card with an icon, description, a backend-endpoint note, and a
/// full-width action button.
///
/// ## Wiring up the backend
/// Pass an [onTap] callback when the endpoint is ready:
///
/// ```dart
/// ReportExportCard(
///   ...
///   onTap: () => context.read<ReportsCubit>().generatePdf(),
/// )
/// ```
///
/// Until [onTap] is provided the button renders an amber "Pending backend"
/// badge and shows an informational snackbar when tapped, so the UI is fully
/// interactive without crashing.
class ReportExportCard extends StatelessWidget {
  const ReportExportCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.note,
    // Provide this once the backend endpoint is live.
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonLabel;

  /// The API endpoint note shown beneath the description.
  /// e.g. 'Connects to /api/reports/pdf when backend is live'
  final String note;

  /// Called when the button is tapped.
  ///
  /// Leave [null] while the backend is not yet ready — the button will
  /// remain tappable and show an informational snackbar instead.
  final VoidCallback? onTap;

  bool get _isReady => onTap != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isReady
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row: icon + title + status badge ──────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Status badge
                    _StatusBadge(isReady: _isReady),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Description ──────────────────────────────────────────────
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // ── Backend endpoint note ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.api_outlined,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  note,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Action button ────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              // Always tappable — shows snackbar when backend not yet wired
              onPressed: _isReady ? onTap : () => _showPendingSnackbar(context),
              icon: Icon(icon, size: 18),
              label: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isReady
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.65),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.hourglass_top_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title is ready — waiting for the backend API to be connected.',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

// ---------------------------------------------------------------------------
// Status badge shown in the card header
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isReady});
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final color = isReady ? AppColors.success : AppColors.warning;
    final label = isReady ? 'Ready' : 'Pending backend';
    final icon = isReady
        ? Icons.check_circle_outline
        : Icons.hourglass_top_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
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
    );
  }
}
