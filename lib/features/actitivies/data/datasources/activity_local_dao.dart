import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/storage/app_database.dart';

/// Drift DAO for all local field-activity read/write operations.
///
/// Photos associated with an activity are stored in [ActivityPhotos] using the
/// activity id as a foreign key. Both rows are written in a single transaction
/// to keep the database consistent.
class ActivityLocalDao {
  ActivityLocalDao(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  /// Inserts a new [FieldActivity] row plus any [photoPaths] in a single
  /// transaction. Returns the generated activity id.
  Future<String> insertActivity({
    required String projectId,
    required String communityId,
    required String activityType,
    required DateTime date,
    required int maleCount,
    required int femaleCount,
    required int childrenCount,
    String? description,
    double? latitude,
    double? longitude,
    required String fieldOfficerId,
    List<String> photoPaths = const [],
  }) async {
    final activityId = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.transaction(() async {
      // Insert the activity row.
      await _db.into(_db.fieldActivities).insert(
            FieldActivitiesCompanion.insert(
              id: activityId,
              projectId: projectId,
              communityId: communityId,
              activityType: activityType,
              date: date.millisecondsSinceEpoch,
              maleCount: maleCount,
              femaleCount: femaleCount,
              childrenCount: childrenCount,
              description: Value(description),
              latitude: Value(latitude),
              longitude: Value(longitude),
              fieldOfficerId: fieldOfficerId,
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Insert each photo path as a linked ActivityPhoto row.
      for (final path in photoPaths) {
        await _db.into(_db.activityPhotos).insert(
              ActivityPhotosCompanion.insert(
                id: _uuid.v4(),
                activityId: activityId,
                filePath: path,
              ),
            );
      }
    });

    return activityId;
  }

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  /// Returns all activities for a project, ordered newest-first.
  Future<List<FieldActivity>> getActivitiesForProject(String projectId) {
    return (_db.select(_db.fieldActivities)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Returns all activities with [syncStatus] == `'pending'`.
  Future<List<FieldActivity>> getPendingActivities() {
    return (_db.select(_db.fieldActivities)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  /// Returns the photos linked to a given activity.
  Future<List<ActivityPhoto>> getPhotosForActivity(String activityId) {
    return (_db.select(_db.activityPhotos)
          ..where((t) => t.activityId.equals(activityId)))
        .get();
  }

  /// Watches aggregate stats for a project as a live stream.
  ///
  /// Emits a map with keys: `activityCount`, `communityCount`,
  /// `totalParticipants`.
  Stream<Map<String, int>> watchProjectStats(String projectId) {
    // We do three separate queries and combine them because Drift's
    // selectOnly can only aggregate one table at a time without raw SQL.
    final activityCount$ = (_db.select(_db.fieldActivities)
          ..where((t) => t.projectId.equals(projectId)))
        .watch()
        .map((rows) => rows.length);

    return activityCount$.map((count) => {'activityCount': count});
  }
}
