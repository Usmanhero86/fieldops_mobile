import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';

/// Yellow info banner shown at the top of the reports page explaining
/// that the data is demo data until the backend is connected.
class ReportNoteBanner extends StatelessWidget {
  const ReportNoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warning, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Showing demo data — this is how reports will look '
              'once the backend is connected.',
              style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
