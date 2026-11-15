part of 'reports_cubit.dart';

sealed class ReportsState {
  const ReportsState();
}

final class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

final class ReportsFilterLoading extends ReportsState {
  const ReportsFilterLoading();
}

/// Filter options have been loaded and the form is ready.
final class ReportsReady extends ReportsState {
  const ReportsReady({
    required this.projects,
    required this.lgas,
    this.selectedProjectId,
    this.selectedLga,
    this.fromDate,
    this.toDate,
  });

  final List<Project> projects;
  final List<String> lgas;
  final String? selectedProjectId;
  final String? selectedLga;
  final DateTime? fromDate;
  final DateTime? toDate;

  ReportsReady copyWith({
    String? selectedProjectId,
    String? selectedLga,
    DateTime? fromDate,
    DateTime? toDate,
  }) => ReportsReady(
    projects: projects,
    lgas: lgas,
    selectedProjectId: selectedProjectId ?? this.selectedProjectId,
    selectedLga: selectedLga ?? this.selectedLga,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
  );
}

final class ReportsGenerating extends ReportsState {
  const ReportsGenerating({required this.type});
  final String type; // 'pdf' | 'csv'
}

final class ReportsPdfReady extends ReportsState {
  const ReportsPdfReady({required this.pdfBytes, required this.data});
  final Uint8List pdfBytes;
  final ProjectReportData data;
}

final class ReportsCsvReady extends ReportsState {
  const ReportsCsvReady({required this.filePath});
  final String filePath;
}

final class ReportsError extends ReportsState {
  const ReportsError({required this.message});
  final String message;
}
