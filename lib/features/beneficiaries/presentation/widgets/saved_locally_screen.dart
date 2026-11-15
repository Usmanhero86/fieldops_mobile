import 'package:fieldops_mobile/features/beneficiaries/presentation/widgets/success_chip.dart';
import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';

class SavedLocallyScreen extends StatelessWidget {
  const SavedLocallyScreen({super.key,
    required this.name,
    required this.grantAmount,
    required this.businessType,
    required this.onDone,
    required this.onRegisterAnother,
  });

  final String name;
  final String grantAmount;
  final String businessType;
  final VoidCallback onDone;
  final VoidCallback onRegisterAnother;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Beneficiary Saved',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              if (name.trim().isNotEmpty)
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 8),

              // Grant summary chips
              if (grantAmount.isNotEmpty || businessType.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    if (grantAmount.isNotEmpty)
                      SuccessChip(
                        icon: Icons.payments_outlined,
                        label: '₦$grantAmount grant',
                        color: AppColors.success,
                      ),
                    if (businessType.isNotEmpty)
                      SuccessChip(
                        icon: Icons.storefront_outlined,
                        label: businessType,
                        color: AppColors.primary,
                      ),
                    SuccessChip(
                      icon: Icons.badge_outlined,
                      label: 'By ${kCurrentOfficer.name}',
                      color: const Color(0xFF00838F),
                    ),
                  ],
                ),
              const SizedBox(height: 28),

              // Offline sync notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.warning,
                      size: 24,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🟠  Pending Sync',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Saved to your device. Will sync automatically when you have internet access.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Register another
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRegisterAnother,
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text(
                    'Register Another',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Done
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: onDone,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Back to Beneficiaries',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

