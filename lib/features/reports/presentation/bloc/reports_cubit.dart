import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/app_database.dart';
import '../../data/csv_report_builder.dart';
import '../../data/pdf_report_builder.dart';
import '../../data/reports_local_dao.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({required ReportsLocalDao dao})
    : _dao = dao,
      super(const ReportsInitial());

  final ReportsLocalDao _dao;

  // ---------------------------------------------------------------------------
  // Load filter options
  // ---------------------------------------------------------------------------

  Future<void> loadFilters() async {
    emit(const ReportsFilterLoading());
    try {
      final results = await Future.wait([_dao.getProjects(), _dao.getLgas()]);
      final projects = results[0] as List<Project>;
      final lgas = results[1] as List<String>;

      // Default: current month
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, 1);
      final to = now;

      emit(
        ReportsReady(
          projects: projects,
          lgas: lgas,
          fromDate: from,
          toDate: to,
          selectedProjectId: projects.isNotEmpty ? projects.first.id : null,
        ),
      );
    } catch (e) {
      emit(ReportsError(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Filter updates
  // ---------------------------------------------------------------------------

  void selectProject(String? id) {
    if (state is! ReportsReady) return;
    emit((state as ReportsReady).copyWith(selectedProjectId: id));
  }

  void selectLga(String? lga) {
    if (state is! ReportsReady) return;
    emit((state as ReportsReady).copyWith(selectedLga: lga));
  }

  void setDateRange(DateTime from, DateTime to) {
    if (state is! ReportsReady) return;
    emit((state as ReportsReady).copyWith(fromDate: from, toDate: to));
  }

  // ---------------------------------------------------------------------------
  // PDF generation
  // ---------------------------------------------------------------------------

  Future<void> generatePdf() async {
    if (state is! ReportsReady) return;
    final ready = state as ReportsReady;
    if (ready.selectedProjectId == null ||
        ready.fromDate == null ||
        ready.toDate == null) {
      emit(const ReportsError(message: 'Please complete all filters.'));
      return;
    }

    emit(const ReportsGenerating(type: 'pdf'));
    try {
      final data = await _dao.getProjectReport(
        projectId: ready.selectedProjectId!,
        from: ready.fromDate!,
        to: ready.toDate!,
        lga: ready.selectedLga,
      );

      if (data == null) {
        emit(
          const ReportsError(message: 'No data found for selected filters.'),
        );
        _reEmitReady(ready);
        return;
      }

      final bytes = await PdfReportBuilder.build(data);
      emit(ReportsPdfReady(pdfBytes: bytes, data: data));
    } catch (e) {
      emit(ReportsError(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // CSV generation
  // ---------------------------------------------------------------------------

  Future<void> generateCsv() async {
    if (state is! ReportsReady) return;
    final ready = state as ReportsReady;
    if (ready.selectedProjectId == null ||
        ready.fromDate == null ||
        ready.toDate == null) {
      emit(const ReportsError(message: 'Please complete all filters.'));
      return;
    }

    emit(const ReportsGenerating(type: 'csv'));
    try {
      final rows = await _dao.getBeneficiariesForCsv(
        projectId: ready.selectedProjectId!,
        from: ready.fromDate!,
        to: ready.toDate!,
        lga: ready.selectedLga,
      );

      final projectName = ready.projects
          .firstWhere(
            (p) => p.id == ready.selectedProjectId,
            orElse: () => throw Exception('Project not found'),
          )
          .name;

      final path = await CsvReportBuilder.build(rows, projectName: projectName);
      emit(ReportsCsvReady(filePath: path));
    } catch (e) {
      emit(ReportsError(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Reset to ready state after consuming a result
  // ---------------------------------------------------------------------------

  void backToFilters() {
    if (state is ReportsReady) return;
    // Reload clean
    loadFilters();
  }

  void _reEmitReady(ReportsReady ready) => emit(ready);
}
