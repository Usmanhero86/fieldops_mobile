import 'package:flutter/material.dart';
import '../../../../core/dummy/dummy_data.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/form_section_header.dart';
import '../widgets/report_activity_summary.dart';
import '../widgets/report_beneficiary_breakdown.dart';
import '../widgets/report_community_table.dart';
import '../widgets/report_export_card.dart';
import '../widgets/report_note_banner.dart';
import '../widgets/report_project_selector.dart';
import '../widgets/report_project_summary_card.dart';
import '../widgets/report_screen_size.dart';
import '../widgets/report_sync_status.dart';
import '../widgets/report_vulnerability_breakdown.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedProjectId = kCurrentOfficer.projectId;

  DummyProject get _project =>
      kProjects.firstWhere((p) => p.id == _selectedProjectId);

  List<DummyBeneficiary> get _beneficiaries =>
      kBeneficiaries.where((b) => b.projectId == _selectedProjectId).toList();

  List<DummyActivity> get _activities =>
      kActivities.where((a) => a.projectId == _selectedProjectId).toList();

  List<DummyCommunity> get _communities =>
      communitiesForProject(_selectedProjectId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screen = reportScreenSize(constraints.maxWidth);
          final hPad = screen == ReportScreenSize.wide ? 32.0 : 16.0;

          return ListView(
            padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 40),
            children: [
              const ReportNoteBanner(),
              const SizedBox(height: 16),

              ReportProjectSelector(
                selectedId: _selectedProjectId,
                onChanged: (id) => setState(() => _selectedProjectId = id),
              ),
              const SizedBox(height: 20),

              ReportProjectSummaryCard(project: _project, screen: screen),
              const SizedBox(height: 20),

              const FormSectionHeader(title: 'Beneficiary Breakdown'),
              ReportBeneficiaryBreakdown(
                beneficiaries: _beneficiaries,
                screen: screen,
              ),
              const SizedBox(height: 20),

              const FormSectionHeader(title: 'Vulnerability Categories'),
              ReportVulnerabilityBreakdown(beneficiaries: _beneficiaries),
              const SizedBox(height: 20),

              const FormSectionHeader(title: 'Activity Summary'),
              ReportActivitySummary(activities: _activities, screen: screen),
              const SizedBox(height: 20),

              const FormSectionHeader(title: 'Community Reach'),
              ReportCommunityTable(communities: _communities, screen: screen),
              const SizedBox(height: 20),

              const FormSectionHeader(title: 'Data Sync Status'),
              ReportSyncStatus(
                beneficiaries: _beneficiaries,
                activities: _activities,
              ),
              const SizedBox(height: 24),

              const FormSectionHeader(title: 'Generate Report'),
              // Wide screens: export cards side by side
              screen == ReportScreenSize.wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _pdfCard),
                        const SizedBox(width: 16),
                        Expanded(child: _csvCard),
                      ],
                    )
                  : Column(
                      children: [
                        _pdfCard,
                        const SizedBox(height: 12),
                        _csvCard,
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }

  // ── Export cards ────────────────────────────────────────────────────────
  //
  // TO WIRE UP THE BACKEND:
  // Add  onTap: () => context.read<ReportsCubit>().generatePdf()
  // (or the equivalent cubit/repository call) to each card once the
  // API endpoints are live. The badge on the card will automatically
  // switch from "Pending backend" → "Ready" when onTap is non-null.

  Widget get _pdfCard => const ReportExportCard(
    icon: Icons.picture_as_pdf,
    iconColor: AppColors.error,
    title: 'PDF Report',
    description:
        'Monthly project summary with beneficiary stats, '
        'activities, communities, and progress.',
    buttonLabel: 'Generate PDF',
    note: 'Connects to /api/reports/pdf when backend is live',
    // onTap: () => context.read<ReportsCubit>().generatePdf(),
  );

  Widget get _csvCard => const ReportExportCard(
    icon: Icons.table_chart_outlined,
    iconColor: AppColors.success,
    title: 'CSV Export',
    description:
        'Full beneficiary register with all fields — '
        'ready for Excel and donor reporting.',
    buttonLabel: 'Export CSV',
    note: 'Connects to /api/reports/export/csv when backend is live',
    // onTap: () => context.read<ReportsCubit>().generateCsv(),
  );
}
