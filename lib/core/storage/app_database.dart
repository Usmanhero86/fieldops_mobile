import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Table definitions
// ---------------------------------------------------------------------------

/// Authenticated field officers stored locally.
class Users extends Table {
  /// Server-assigned or locally generated UUID.
  TextColumn get id => text()();

  TextColumn get username => text()();

  TextColumn get fullName => text().named('full_name')();

  TextColumn get role => text()();

  /// JWT / session credential; may be null when the user is logged out.
  TextColumn get sessionToken => text().named('session_token').nullable()();

  /// Epoch milliseconds of the last successful sync.
  IntColumn get syncedAt => integer().named('synced_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Humanitarian projects assigned to a field officer.
class Projects extends Table {
  /// Server-assigned UUID.
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get status => text()();

  TextColumn get fieldOfficerId => text().named('field_officer_id')();

  /// Denormalised count kept for fast display.
  IntColumn get communityCount => integer().named('community_count')();

  /// Epoch milliseconds of the last successful sync.
  IntColumn get syncedAt => integer().named('synced_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Geographic sub-units under a project.
class Communities extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get ward => text()();

  TextColumn get lga => text()();

  /// Foreign key → projects.id
  TextColumn get projectId => text().named('project_id')();

  /// Epoch milliseconds of the last successful sync.
  IntColumn get syncedAt => integer().named('synced_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Beneficiary records created by field officers.
class Beneficiaries extends Table {
  /// Locally generated UUID (created before backend sync).
  TextColumn get id => text()();

  TextColumn get firstName => text().named('first_name')();

  TextColumn get lastName => text().named('last_name')();

  TextColumn get gender => text()();

  /// Epoch milliseconds.
  IntColumn get dateOfBirth => integer().named('date_of_birth')();

  TextColumn get phoneNumber => text().named('phone_number').nullable()();

  TextColumn get lga => text()();

  TextColumn get ward => text()();

  /// Foreign key → communities.id
  TextColumn get communityId => text().named('community_id')();

  /// Foreign key → projects.id
  TextColumn get projectId => text().named('project_id')();

  IntColumn get householdSize => integer().named('household_size').nullable()();

  TextColumn get vulnerabilityCategory =>
      text().named('vulnerability_category').nullable()();

  RealColumn get latitude => real().nullable()();

  RealColumn get longitude => real().nullable()();

  /// Epoch milliseconds; nullable until GPS is captured.
  IntColumn get gpsTimestamp => integer().named('gps_timestamp').nullable()();

  TextColumn get fieldOfficerId => text().named('field_officer_id')();

  /// Absolute path on the device filesystem; nullable until photo is captured.
  TextColumn get photoPath => text().named('photo_path').nullable()();

  /// One of: pending | syncing | synced | failed
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();

  /// Epoch milliseconds.
  IntColumn get createdAt => integer().named('created_at')();

  /// Epoch milliseconds.
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Field activities logged by officers in the field.
class FieldActivities extends Table {
  /// Locally generated UUID.
  TextColumn get id => text()();

  /// Foreign key → projects.id
  TextColumn get projectId => text().named('project_id')();

  /// Foreign key → communities.id
  TextColumn get communityId => text().named('community_id')();

  TextColumn get activityType => text().named('activity_type')();

  /// Epoch milliseconds representing the date of the activity.
  IntColumn get date => integer()();

  /// Must be ≥ 0 (enforced at the use-case layer).
  IntColumn get maleCount => integer().named('male_count')();

  /// Must be ≥ 0.
  IntColumn get femaleCount => integer().named('female_count')();

  /// Must be ≥ 0.
  IntColumn get childrenCount => integer().named('children_count')();

  TextColumn get description => text().nullable()();

  RealColumn get latitude => real().nullable()();

  RealColumn get longitude => real().nullable()();

  TextColumn get fieldOfficerId => text().named('field_officer_id')();

  /// One of: pending | syncing | synced | failed
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();

  /// Epoch milliseconds.
  IntColumn get createdAt => integer().named('created_at')();

  /// Epoch milliseconds.
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Photos attached to a [FieldActivity].
class ActivityPhotos extends Table {
  /// Locally generated UUID.
  TextColumn get id => text()();

  /// Foreign key → field_activities.id
  TextColumn get activityId => text().named('activity_id')();

  /// Absolute path on the device filesystem.
  TextColumn get filePath => text().named('file_path')();

  /// One of: pending | synced | failed
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

/// The application's single Drift/SQLite database.
///
/// All reads and writes go through this database first.  The Sync Engine
/// pushes pending records to the backend whenever connectivity is available.
///
/// WAL (Write-Ahead Logging) journal mode is enabled for improved concurrency
/// and crash safety — a mid-write crash leaves the database consistent.
@DriftDatabase(
  tables: [
    Users,
    Projects,
    Communities,
    Beneficiaries,
    FieldActivities,
    ActivityPhotos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Constructor used by tests — accepts an in-memory executor.
  AppDatabase.forTesting(QueryExecutor executor)
    : super(DatabaseConnection(executor));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Future migrations go here.
    },
    beforeOpen: (OpeningDetails details) async {
      // Enable WAL journal mode for better concurrency and crash-safety.
      await customStatement('PRAGMA journal_mode=WAL;');
    },
  );
}

/// Opens (or creates) the SQLite database file in the application documents
/// directory, with WAL journal mode enabled.
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'fieldops.db'));
    return NativeDatabase.createInBackground(file);
  });
}
