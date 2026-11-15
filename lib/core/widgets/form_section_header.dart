import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// A labelled section divider used inside scrollable forms.
///
/// Example:
/// ```dart
/// FormSectionHeader(title: 'Personal Information')
/// ```
class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }
}
