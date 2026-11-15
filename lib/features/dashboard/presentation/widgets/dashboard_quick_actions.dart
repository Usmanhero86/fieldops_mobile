import 'package:flutter/material.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/themes/app_colors.dart';

/// "QUICK ACTIONS" section with four tappable shortcut buttons.
class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK ACTIONS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            DashboardActionButton(
              icon: Icons.person_add_outlined,
              label: 'Register\nBeneficiary',
              color: AppColors.primary,
              onTap: () =>
                  Navigator.pushNamed(context, AppRouter.beneficiaryRegister),
            ),
            const SizedBox(width: 10),
            DashboardActionButton(
              icon: Icons.add_chart_outlined,
              label: 'Log\nActivity',
              color: AppColors.success,
              onTap: () => Navigator.pushNamed(context, AppRouter.activityLog),
            ),
            const SizedBox(width: 10),
            DashboardActionButton(
              icon: Icons.map_outlined,
              label: 'View\nMap',
              color: const Color(0xFF00838F),
              onTap: () => Navigator.pushNamed(context, AppRouter.mapRoute),
            ),
            const SizedBox(width: 10),
            DashboardActionButton(
              icon: Icons.assessment_outlined,
              label: 'Reports',
              color: const Color(0xFF6A1B9A),
              onTap: () => Navigator.pushNamed(context, AppRouter.reports),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual tappable button used inside [DashboardQuickActions].
class DashboardActionButton extends StatelessWidget {
  const DashboardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
