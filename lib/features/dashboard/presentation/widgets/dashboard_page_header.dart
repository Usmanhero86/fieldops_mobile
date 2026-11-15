
import 'package:flutter/material.dart';

class DashboardPageHeader extends StatelessWidget {
  const DashboardPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFF00838F),
    this.showBackButton = true,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final narrow = width < 400;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(
        width < 400 ? 6 : width >= 600 ? 16 : 8,
        MediaQuery.of(context).padding.top + 14,
        width < 400 ? 6 : width >= 600 ? 16 : 8,
        18,
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: narrow ? 17 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
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
    );
  }
}
