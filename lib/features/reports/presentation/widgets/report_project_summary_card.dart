import 'package:flutter/material.dart';
import '../../../../../core/dummy/dummy_data.dart';
import 'report_screen_size.dart';

/// Gradient card showing key project stats, progress bar, and date range.
class ReportProjectSummaryCard extends StatelessWidget {
  const ReportProjectSummaryCard({
    super.key,
    required this.project,
    required this.screen,
  });

  final DummyProject project;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    final pct = (project.progressPercent * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [project.color, project.color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: project.color.withValues(alpha: 0.30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + progress badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screen == ReportScreenSize.narrow ? 14 : 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Donor: ${project.donor}  ·  ${project.status.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.progressPercent,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${project.registeredBeneficiaries} of '
            '${project.targetBeneficiaries} target beneficiaries',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Stat chips — Wrap so they can spill to a second line on narrow screens
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ReportSummaryChip(
                icon: Icons.people_outline,
                value: '${project.registeredBeneficiaries}',
                label: 'Beneficiaries',
                screen: screen,
              ),
              ReportSummaryChip(
                icon: Icons.location_city_outlined,
                value: '${project.communityCount}',
                label: 'Communities',
                screen: screen,
              ),
              ReportSummaryChip(
                icon: Icons.assignment_outlined,
                value: '${project.activitiesLogged}',
                label: 'Activities',
                screen: screen,
              ),
              ReportSummaryChip(
                icon: Icons.map_outlined,
                value: '${project.lgaCount}',
                label: 'LGAs',
                screen: screen,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Date range
          Row(
            children: [
              const Icon(Icons.date_range, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '${_fmtDate(project.startDate)} → ${_fmtDate(project.endDate)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}

// ---------------------------------------------------------------------------
// Small chip used inside the project summary card
// ---------------------------------------------------------------------------

class ReportSummaryChip extends StatelessWidget {
  const ReportSummaryChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.screen,
  });

  final IconData icon;
  final String value;
  final String label;
  final ReportScreenSize screen;

  @override
  Widget build(BuildContext context) {
    final minW = screen == ReportScreenSize.narrow ? 72.0 : 80.0;
    return Container(
      constraints: BoxConstraints(minWidth: minW),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: screen == ReportScreenSize.narrow ? 12 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
