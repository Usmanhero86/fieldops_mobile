import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';

// ---------------------------------------------------------------------------
// Data models returned by the DAO
// ---------------------------------------------------------------------------

/// Top-level summary counts shown on the dashboard header.
class DashboardStats {
  const DashboardStats({
    required this.projectCount,
    required this.fieldOfficerCount,
    required this.beneficiaryCount,
    required this.communityCount,
  });

  final int projectCount;
  final int fieldOfficerCount;
  final int beneficiaryCount;
  final int communityCount;
}

/// Per-project progress row for the performance section.
class ProjectPerformanceRow {
  const ProjectPerformanceRow({
    required this.projectId,
    required this.projectName,
    required this.beneficiaryCount,
    required this.activityCount,
    required this.progressPercent,
  });

  final String projectId;
  final String projectName;
  final int beneficiaryCount;
  final int activityCount;

  /// 0.0 – 1.0 value derived from beneficiaries / communityCount * 10 cap.
  final double progressPercent;
}

/// A single row in the Recent Activities list.
class RecentActivityRow {
  const RecentActivityRow({
    required this.activityId,
    required this.activityType,
    required this.communityName,
    required this.date,
  });

  final String activityId;
  final String activityType;
  final String communityName;
  final DateTime date;
}

// ---------------------------------------------------------------------------
// DAO
// ---------------------------------------------------------------------------

/// Provides all data the dashboard needs in a single class.
///
/// Because there is no remote layer yet, everything is computed from the
/// local Drift database.  When the sync engine is added these queries will
/// be supplemented by synced remote data.
class DashboardLocalDao {
  DashboardLocalDao(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  Future<DashboardStats> getStats() async {
    // Count projects
    final projectCountExpr = _db.projects.id.count();
    final projectQuery = _db.selectOnly(_db.projects)
      ..addColumns([projectCountExpr]);
    final projectCount =
        await projectQuery.map((r) => r.read(projectCountExpr) ?? 0).getSingle();

    // Count distinct field officers from beneficiaries + activities combined
    // (using users table when populated; fall back to distinct officer ids)
    final officerCountExpr = _db.users.id.count();
    final officerQuery = _db.selectOnly(_db.users)
      ..addColumns([officerCountExpr]);
    final officerCount =
        await officerQuery.map((r) => r.read(officerCountExpr) ?? 0).getSingle();

    // Count beneficiaries
    final benCountExpr = _db.beneficiaries.id.count();
    final benQuery = _db.selectOnly(_db.beneficiaries)
      ..addColumns([benCountExpr]);
    final benCount =
        await benQuery.map((r) => r.read(benCountExpr) ?? 0).getSingle();

    // Count communities
    final commCountExpr = _db.communities.id.count();
    final commQuery = _db.selectOnly(_db.communities)
      ..addColumns([commCountExpr]);
    final commCount =
        await commQuery.map((r) => r.read(commCountExpr) ?? 0).getSingle();

    return DashboardStats(
      projectCount: projectCount,
      fieldOfficerCount: officerCount,
      beneficiaryCount: benCount,
      communityCount: commCount,
    );
  }

  // ---------------------------------------------------------------------------
  // Project performance
  // ---------------------------------------------------------------------------

  Future<List<ProjectPerformanceRow>> getProjectPerformance() async {
    final projects = await _db.select(_db.projects).get();
    if (projects.isEmpty) return _demoProjectPerformance();

    final rows = <ProjectPerformanceRow>[];

    for (final project in projects) {
      // Beneficiary count for this project
      final benExpr = _db.beneficiaries.id.count();
      final benQ = _db.selectOnly(_db.beneficiaries)
        ..addColumns([benExpr])
        ..where(_db.beneficiaries.projectId.equals(project.id));
      final bens = await benQ.map((r) => r.read(benExpr) ?? 0).getSingle();

      // Activity count for this project
      final actExpr = _db.fieldActivities.id.count();
      final actQ = _db.selectOnly(_db.fieldActivities)
        ..addColumns([actExpr])
        ..where(_db.fieldActivities.projectId.equals(project.id));
      final acts = await actQ.map((r) => r.read(actExpr) ?? 0).getSingle();

      // Simple progress heuristic: (beneficiaries / (communityCount * 10))
      // capped at 1.0.  Replace with a real target field when available.
      final target = (project.communityCount * 10).clamp(1, 99999);
      final progress = (bens / target).clamp(0.0, 1.0);

      rows.add(
        ProjectPerformanceRow(
          projectId: project.id,
          projectName: project.name,
          beneficiaryCount: bens,
          activityCount: acts,
          progressPercent: progress,
        ),
      );
    }

    // Sort by progress descending so the best-performing project leads
    rows.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
    return rows;
  }

  // ---------------------------------------------------------------------------
  // Recent activities
  // ---------------------------------------------------------------------------

  Future<List<RecentActivityRow>> getRecentActivities({int limit = 10}) async {
    final activities = await (_db.select(_db.fieldActivities)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();

    if (activities.isEmpty) return _demoRecentActivities();

    final rows = <RecentActivityRow>[];
    for (final a in activities) {
      // Resolve community name
      final community = await (_db.select(_db.communities)
            ..where((t) => t.id.equals(a.communityId)))
          .getSingleOrNull();

      rows.add(
        RecentActivityRow(
          activityId: a.id,
          activityType: a.activityType,
          communityName: community?.name ?? 'Unknown community',
          date: DateTime.fromMillisecondsSinceEpoch(a.date),
        ),
      );
    }
    return rows;
  }

  // ---------------------------------------------------------------------------
  // Demo data — shown when the DB is empty (great for prototype demos)
  // ---------------------------------------------------------------------------

  static List<ProjectPerformanceRow> _demoProjectPerformance() => [
        const ProjectPerformanceRow(
          projectId: 'demo-1',
          projectName: 'Education Support',
          beneficiaryCount: 1420,
          activityCount: 47,
          progressPercent: 0.89,
        ),
        const ProjectPerformanceRow(
          projectId: 'demo-2',
          projectName: 'WASH Programme',
          beneficiaryCount: 980,
          activityCount: 31,
          progressPercent: 0.78,
        ),
        const ProjectPerformanceRow(
          projectId: 'demo-3',
          projectName: 'Livelihood Training',
          beneficiaryCount: 760,
          activityCount: 22,
          progressPercent: 0.71,
        ),
        const ProjectPerformanceRow(
          projectId: 'demo-4',
          projectName: 'Protection Response',
          beneficiaryCount: 1261,
          activityCount: 38,
          progressPercent: 0.86,
        ),
      ];

  static List<RecentActivityRow> _demoRecentActivities() {
    final now = DateTime.now();
    return [
      RecentActivityRow(
        activityId: 'demo-a1',
        activityType: 'Education Outreach',
        communityName: 'Maiduguri',
        date: now,
      ),
      RecentActivityRow(
        activityId: 'demo-a2',
        activityType: 'Water Assessment',
        communityName: 'Jere',
        date: now.subtract(const Duration(days: 1)),
      ),
      RecentActivityRow(
        activityId: 'demo-a3',
        activityType: 'Livelihood Training',
        communityName: 'Konduga',
        date: now.subtract(const Duration(days: 1)),
      ),
      RecentActivityRow(
        activityId: 'demo-a4',
        activityType: 'Health Screening',
        communityName: 'Gwoza',
        date: now.subtract(const Duration(days: 2)),
      ),
      RecentActivityRow(
        activityId: 'demo-a5',
        activityType: 'Food Distribution',
        communityName: 'Bama',
        date: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
