import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class DashboardDivider extends StatelessWidget {
  const DashboardDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, indent: 44, color: AppColors.border);
}
