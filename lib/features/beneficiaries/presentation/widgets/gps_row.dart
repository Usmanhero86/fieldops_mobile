import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class GpsRow extends StatelessWidget {
  const GpsRow({super.key, required this.onViewMap});
  final VoidCallback onViewMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.gps_fixed, size: 17, color: AppColors.success),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'GPS captured ✓',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewMap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Map',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



