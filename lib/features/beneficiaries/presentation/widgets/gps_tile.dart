import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class GpsTile extends StatelessWidget {
  const GpsTile({super.key,
    required this.captured,
    required this.loading,
    required this.lat,
    required this.lon,
    required this.onCapture,
  });

  final bool captured;
  final bool loading;
  final double? lat;
  final double? lon;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (captured && lat != null) ...[
            // Captured state — show coordinates
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.gps_fixed,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Location captured',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onCapture,
                        child: const Icon(
                          Icons.refresh,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lat: ${lat!.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'Lon: ${lon!.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: loading ? null : onCapture,
                icon: loading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
                    : const Icon(Icons.gps_not_fixed, color: AppColors.primary),
                label: Text(
                  loading ? 'Acquiring GPS fix…' : '  Capture Location',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

