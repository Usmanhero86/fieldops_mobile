import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/storage/app_database.dart';

/// Drift DAO for all local beneficiary read/write operations.
///
/// All inserts generate a client-side UUID and stamp [createdAt]/[updatedAt]
/// with the current epoch-millisecond time.  The [syncStatus] starts as
/// `'pending'` so the sync engine can pick it up later.
class BeneficiaryLocalDao {
  BeneficiaryLocalDao(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  /// Inserts a new beneficiary row and returns the generated id.
  Future<String> insertBeneficiary({
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    String? phoneNumber,
    required String lga,
    required String ward,
    required String communityId,
    required String projectId,
    int? householdSize,
    String? vulnerabilityCategory,
    double? latitude,
    double? longitude,
    int? gpsTimestamp,
    required String fieldOfficerId,
    String? photoPath,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.into(_db.beneficiaries).insert(
          BeneficiariesCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            dateOfBirth: dateOfBirth.millisecondsSinceEpoch,
            phoneNumber: Value(phoneNumber),
            lga: lga,
            ward: ward,
            communityId: communityId,
            projectId: projectId,
            householdSize: Value(householdSize),
            vulnerabilityCategory: Value(vulnerabilityCategory),
            latitude: Value(latitude),
            longitude: Value(longitude),
            gpsTimestamp: Value(gpsTimestamp),
            fieldOfficerId: fieldOfficerId,
            photoPath: Value(photoPath),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  /// Returns all beneficiaries for a given project, ordered newest-first.
  Future<List<Beneficiary>> getBeneficiariesForProject(
    String projectId,
  ) {
    return (_db.select(_db.beneficiaries)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Returns all beneficiaries with [syncStatus] == `'pending'`.
  Future<List<Beneficiary>> getPendingBeneficiaries() {
    return (_db.select(_db.beneficiaries)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
  }

  /// Watches the count of beneficiaries in a project as a live stream.
  Stream<int> watchBeneficiaryCount(String projectId) {
    final countExpr = _db.beneficiaries.id.count();
    final query = _db.selectOnly(_db.beneficiaries)
      ..addColumns([countExpr])
      ..where(_db.beneficiaries.projectId.equals(projectId));
    return query
        .map((row) => row.read(countExpr) ?? 0)
        .watchSingle();
  }
}
