// ignore_for_file: lines_longer_than_80_chars

/// Property 28: Local_DB Integrity After Restart
///
/// For any set of records successfully committed to the Local_DB before an
/// application restart, all those records should be queryable and return
/// equivalent data after the application restarts and the DB connection is
/// re-established.
///
/// **Validates: Requirements 13.4**
///
/// Simulation strategy:
///   1. Open a file-based Drift DB pointing at a temp-dir file.
///   2. Write records across every table.
///   3. Close the DB (simulates app shutdown / crash-safe WAL flush).
///   4. Re-open a new [AppDatabase] instance against the same file (simulates
///      restart).
///   5. Query every table and assert the data is identical to what was written.
///
/// A file-based DB (not in-memory) is required so that data survives the
/// connection close, matching real device behaviour.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:fieldops_mobile/core/storage/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Opens a file-based [AppDatabase] backed by [file].
AppDatabase _openDb(File file) {
  return AppDatabase.forTesting(NativeDatabase(file));
}

/// Fixtures ─ one row per table (all fields non-nullable ones required).
final _now = DateTime(2024, 6, 1).millisecondsSinceEpoch;

UsersCompanion _userRow() => UsersCompanion.insert(
      id: 'user-001',
      username: 'jane.doe',
      fullName: 'Jane Doe',
      role: 'field_officer',
      syncedAt: _now,
    );

ProjectsCompanion _projectRow() => ProjectsCompanion.insert(
      id: 'proj-001',
      name: 'Health Survey 2024',
      status: 'active',
      fieldOfficerId: 'user-001',
      communityCount: 3,
      syncedAt: _now,
    );

CommunitiesCompanion _communityRow() => CommunitiesCompanion.insert(
      id: 'comm-001',
      name: 'Maiduguri Central',
      ward: 'Ward 5',
      lga: 'Maiduguri',
      projectId: 'proj-001',
      syncedAt: _now,
    );

BeneficiariesCompanion _beneficiaryRow() => BeneficiariesCompanion.insert(
      id: 'ben-001',
      firstName: 'Aisha',
      lastName: 'Musa',
      gender: 'female',
      dateOfBirth: DateTime(1990, 3, 15).millisecondsSinceEpoch,
      lga: 'Maiduguri',
      ward: 'Ward 5',
      communityId: 'comm-001',
      projectId: 'proj-001',
      fieldOfficerId: 'user-001',
      createdAt: _now,
      updatedAt: _now,
    );

FieldActivitiesCompanion _activityRow() => FieldActivitiesCompanion.insert(
      id: 'act-001',
      projectId: 'proj-001',
      communityId: 'comm-001',
      activityType: 'sensitization',
      date: _now,
      maleCount: 10,
      femaleCount: 12,
      childrenCount: 5,
      fieldOfficerId: 'user-001',
      createdAt: _now,
      updatedAt: _now,
    );

ActivityPhotosCompanion _photoRow() => ActivityPhotosCompanion.insert(
      id: 'photo-001',
      activityId: 'act-001',
      filePath: '/device/photos/act001.jpg',
    );

// ---------------------------------------------------------------------------
// Test body
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('fieldops_db_restart_');
  });

  tearDown(() async {
    // Clean up temp directory after each test.
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  /// Writes [records] to [db] and returns the inserted companion data for later
  /// comparison.  The caller is responsible for closing [db] afterwards.
  Future<void> _seedDatabase(AppDatabase db) async {
    await db.into(db.users).insert(_userRow());
    await db.into(db.projects).insert(_projectRow());
    await db.into(db.communities).insert(_communityRow());
    await db.into(db.beneficiaries).insert(_beneficiaryRow());
    await db.into(db.fieldActivities).insert(_activityRow());
    await db.into(db.activityPhotos).insert(_photoRow());
  }

  // ── Property 28 ───────────────────────────────────────────────────────────

  test(
    'Property 28 – users table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      // Phase 1: write and close.
      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      // Phase 2: re-open (simulates restart) and query.
      final db2 = _openDb(dbFile);
      final users = await db2.select(db2.users).get();
      await db2.close();

      expect(users, hasLength(1));
      final u = users.first;
      expect(u.id, 'user-001');
      expect(u.username, 'jane.doe');
      expect(u.fullName, 'Jane Doe');
      expect(u.role, 'field_officer');
      expect(u.syncedAt, _now);
    },
  );

  test(
    'Property 28 – projects table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      final db2 = _openDb(dbFile);
      final projects = await db2.select(db2.projects).get();
      await db2.close();

      expect(projects, hasLength(1));
      final proj = projects.first;
      expect(proj.id, 'proj-001');
      expect(proj.name, 'Health Survey 2024');
      expect(proj.status, 'active');
      expect(proj.fieldOfficerId, 'user-001');
      expect(proj.communityCount, 3);
    },
  );

  test(
    'Property 28 – communities table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      final db2 = _openDb(dbFile);
      final communities = await db2.select(db2.communities).get();
      await db2.close();

      expect(communities, hasLength(1));
      final c = communities.first;
      expect(c.id, 'comm-001');
      expect(c.name, 'Maiduguri Central');
      expect(c.ward, 'Ward 5');
      expect(c.lga, 'Maiduguri');
      expect(c.projectId, 'proj-001');
    },
  );

  test(
    'Property 28 – beneficiaries table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      final db2 = _openDb(dbFile);
      final beneficiaries = await db2.select(db2.beneficiaries).get();
      await db2.close();

      expect(beneficiaries, hasLength(1));
      final b = beneficiaries.first;
      expect(b.id, 'ben-001');
      expect(b.firstName, 'Aisha');
      expect(b.lastName, 'Musa');
      expect(b.gender, 'female');
      expect(b.lga, 'Maiduguri');
      expect(b.ward, 'Ward 5');
      expect(b.communityId, 'comm-001');
      expect(b.projectId, 'proj-001');
      expect(b.fieldOfficerId, 'user-001');
      expect(b.syncStatus, 'pending');
    },
  );

  test(
    'Property 28 – field_activities table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      final db2 = _openDb(dbFile);
      final activities = await db2.select(db2.fieldActivities).get();
      await db2.close();

      expect(activities, hasLength(1));
      final a = activities.first;
      expect(a.id, 'act-001');
      expect(a.projectId, 'proj-001');
      expect(a.communityId, 'comm-001');
      expect(a.activityType, 'sensitization');
      expect(a.maleCount, 10);
      expect(a.femaleCount, 12);
      expect(a.childrenCount, 5);
      expect(a.fieldOfficerId, 'user-001');
      expect(a.syncStatus, 'pending');
    },
  );

  test(
    'Property 28 – activity_photos table survives DB restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);
      await db1.close();

      final db2 = _openDb(dbFile);
      final photos = await db2.select(db2.activityPhotos).get();
      await db2.close();

      expect(photos, hasLength(1));
      final ph = photos.first;
      expect(ph.id, 'photo-001');
      expect(ph.activityId, 'act-001');
      expect(ph.filePath, '/device/photos/act001.jpg');
      expect(ph.syncStatus, 'pending');
    },
  );

  test(
    'Property 28 – multiple records across all tables all survive restart',
    () async {
      final dbFile = File(p.join(tempDir.path, 'fieldops.db'));

      // Write a second set of records with different IDs.
      final db1 = _openDb(dbFile);
      await _seedDatabase(db1);

      // Second project + community + beneficiary to verify count > 1.
      await db1.into(db1.projects).insert(
            ProjectsCompanion.insert(
              id: 'proj-002',
              name: 'WASH Programme',
              status: 'planning',
              fieldOfficerId: 'user-001',
              communityCount: 1,
              syncedAt: _now,
            ),
          );
      await db1.into(db1.communities).insert(
            CommunitiesCompanion.insert(
              id: 'comm-002',
              name: 'Borno South',
              ward: 'Ward 2',
              lga: 'Jere',
              projectId: 'proj-002',
              syncedAt: _now,
            ),
          );
      await db1.into(db1.beneficiaries).insert(
            BeneficiariesCompanion.insert(
              id: 'ben-002',
              firstName: 'Ibrahim',
              lastName: 'Yusuf',
              gender: 'male',
              dateOfBirth: DateTime(1985, 7, 20).millisecondsSinceEpoch,
              lga: 'Jere',
              ward: 'Ward 2',
              communityId: 'comm-002',
              projectId: 'proj-002',
              fieldOfficerId: 'user-001',
              createdAt: _now,
              updatedAt: _now,
            ),
          );
      await db1.close();

      // Re-open and verify all rows present.
      final db2 = _openDb(dbFile);
      final projects = await db2.select(db2.projects).get();
      final communities = await db2.select(db2.communities).get();
      final beneficiaries = await db2.select(db2.beneficiaries).get();
      await db2.close();

      expect(projects, hasLength(2),
          reason: 'Both projects must be present after restart');
      expect(communities, hasLength(2),
          reason: 'Both communities must be present after restart');
      expect(beneficiaries, hasLength(2),
          reason: 'Both beneficiaries must be present after restart');

      // Spot-check the second records are intact.
      final proj2 = projects.firstWhere((p) => p.id == 'proj-002');
      expect(proj2.name, 'WASH Programme');
      expect(proj2.status, 'planning');

      final ben2 = beneficiaries.firstWhere((b) => b.id == 'ben-002');
      expect(ben2.firstName, 'Ibrahim');
      expect(ben2.lastName, 'Yusuf');
    },
  );
}
