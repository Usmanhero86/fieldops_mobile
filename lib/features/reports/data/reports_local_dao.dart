import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';

/// Aggregated data used to build a project monthly report.
class ProjectReportData {
  const ProjectReportData({
    required this.projectName,
    required this.periodStart,
    required this.periodEnd,
    required this.beneficiaries,
    required this.male,
    required this.female,
    required this.communities,
    required this.activities,
    required this.progressPercent,
  });

  final String projectName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int beneficiaries;
  final int male;
  final int female;
  final int communities;
  final int activities;

  /// 0.0 – 1.0
  final double progressPercent;

  int get other => (beneficiaries - male - female).clamp(0, beneficiaries);
}

/// A single row in the CSV export.
class BeneficiaryCsvRow {
  const BeneficiaryCsvRow({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.lga,
    required this.ward,
    required this.communityName,
    required this.projectName,
    required this.dateRegistered,
    required this.latitude,
    required this.longitude,
    required this.fieldOfficerId,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String lga;
  final String ward;
  final String communityName;
  final String projectName;
  final DateTime dateRegistered;
  final double? latitude;
  final double? longitude;
  final String fieldOfficerId;
}

class ReportsLocalDao {
  ReportsLocalDao(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------------

  /// Returns all projects for the filter dropdown.
  Future<List<Project>> getProjects() => _db.select(_db.projects).get();

  /// Returns distinct LGA values from the beneficiaries table.
  Future<List<String>> getLgas() async {
    final rows = await _db.select(_db.beneficiaries).get();
    return rows.map((r) => r.lga).toSet().toList()..sort();
  }

  // ---------------------------------------------------------------------------
  // Report aggregation
  // ---------------------------------------------------------------------------

  Future<ProjectReportData?> getProjectReport({
    required String projectId,
    required DateTime from,
    required DateTime to,
    String? lga,
  }) async {
    final project = await (_db.select(
      _db.projects,
    )..where((t) => t.id.equals(projectId))).getSingleOrNull();

    if (project == null) return null;

    final fromMs = from.millisecondsSinceEpoch;
    final toMs = to.millisecondsSinceEpoch;

    // Beneficiaries in range
    var benQuery = _db.select(_db.beneficiaries)
      ..where(
        (t) =>
            t.projectId.equals(projectId) &
            t.createdAt.isBiggerOrEqualValue(fromMs) &
            t.createdAt.isSmallerOrEqualValue(toMs),
      );

    if (lga != null && lga.isNotEmpty) {
      benQuery = benQuery..where((t) => t.lga.equals(lga));
    }

    final bens = await benQuery.get();

    final male = bens.where((b) => b.gender == 'male').length;
    final female = bens.where((b) => b.gender == 'female').length;

    // Activities in range
    final acts =
        await (_db.select(_db.fieldActivities)..where(
              (t) =>
                  t.projectId.equals(projectId) &
                  t.createdAt.isBiggerOrEqualValue(fromMs) &
                  t.createdAt.isSmallerOrEqualValue(toMs),
            ))
            .get();

    // Distinct communities touched by activities
    final communityIds = acts.map((a) => a.communityId).toSet().length;

    final target = (project.communityCount * 10).clamp(1, 99999);
    final progress = (bens.length / target).clamp(0.0, 1.0);

    return ProjectReportData(
      projectName: project.name,
      periodStart: from,
      periodEnd: to,
      beneficiaries: bens.length,
      male: male,
      female: female,
      communities: communityIds,
      activities: acts.length,
      progressPercent: progress,
    );
  }

  // ---------------------------------------------------------------------------
  // CSV export
  // ---------------------------------------------------------------------------

  Future<List<BeneficiaryCsvRow>> getBeneficiariesForCsv({
    required String projectId,
    required DateTime from,
    required DateTime to,
    String? lga,
  }) async {
    final fromMs = from.millisecondsSinceEpoch;
    final toMs = to.millisecondsSinceEpoch;

    var query = _db.select(_db.beneficiaries)
      ..where(
        (t) =>
            t.projectId.equals(projectId) &
            t.createdAt.isBiggerOrEqualValue(fromMs) &
            t.createdAt.isSmallerOrEqualValue(toMs),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

    if (lga != null && lga.isNotEmpty) {
      query = query..where((t) => t.lga.equals(lga));
    }

    final bens = await query.get();
    final rows = <BeneficiaryCsvRow>[];

    for (final b in bens) {
      final community = await (_db.select(
        _db.communities,
      )..where((t) => t.id.equals(b.communityId))).getSingleOrNull();
      final project = await (_db.select(
        _db.projects,
      )..where((t) => t.id.equals(b.projectId))).getSingleOrNull();

      rows.add(
        BeneficiaryCsvRow(
          id: b.id,
          firstName: b.firstName,
          lastName: b.lastName,
          gender: b.gender,
          lga: b.lga,
          ward: b.ward,
          communityName: community?.name ?? b.communityId,
          projectName: project?.name ?? b.projectId,
          dateRegistered: DateTime.fromMillisecondsSinceEpoch(b.createdAt),
          latitude: b.latitude,
          longitude: b.longitude,
          fieldOfficerId: b.fieldOfficerId,
        ),
      );
    }
    return rows;
  }
}
