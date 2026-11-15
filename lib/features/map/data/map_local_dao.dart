import 'package:drift/drift.dart';

import '../../../core/storage/app_database.dart';

/// A map marker that can represent either a beneficiary or a field activity.
class MapMarkerData {
  const MapMarkerData({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.subtitle,
    required this.detail,
    this.registeredAt,
    this.fieldOfficerName,
  });

  /// `'beneficiary'` or `'activity'`
  final String type;
  final String id;
  final double latitude;
  final double longitude;

  /// Primary label shown on the detail sheet (name or activity type).
  final String title;

  /// Secondary label (community name).
  final String subtitle;

  /// Third line (project name).
  final String detail;

  final DateTime? registeredAt;
  final String? fieldOfficerName;
}

class MapLocalDao {
  MapLocalDao(this._db);

  final AppDatabase _db;

  /// Returns all beneficiaries that have a GPS fix, mapped to [MapMarkerData].
  Future<List<MapMarkerData>> getBeneficiaryMarkers() async {
    final rows = await (_db.select(
      _db.beneficiaries,
    )..where((t) => t.latitude.isNotNull() & t.longitude.isNotNull())).get();

    if (rows.isEmpty) return _demoBeneficiaryMarkers();

    final markers = <MapMarkerData>[];
    for (final b in rows) {
      // Resolve community & project names
      final community = await (_db.select(
        _db.communities,
      )..where((t) => t.id.equals(b.communityId))).getSingleOrNull();
      final project = await (_db.select(
        _db.projects,
      )..where((t) => t.id.equals(b.projectId))).getSingleOrNull();

      markers.add(
        MapMarkerData(
          id: b.id,
          type: 'beneficiary',
          latitude: b.latitude!,
          longitude: b.longitude!,
          title: '${b.firstName} ${b.lastName}',
          subtitle: community?.name ?? b.communityId,
          detail: project?.name ?? b.projectId,
          registeredAt: DateTime.fromMillisecondsSinceEpoch(b.createdAt),
          fieldOfficerName: b.fieldOfficerId,
        ),
      );
    }
    return markers;
  }

  /// Returns all field activities that have a GPS fix.
  Future<List<MapMarkerData>> getActivityMarkers() async {
    final rows = await (_db.select(
      _db.fieldActivities,
    )..where((t) => t.latitude.isNotNull() & t.longitude.isNotNull())).get();

    if (rows.isEmpty) return _demoActivityMarkers();

    final markers = <MapMarkerData>[];
    for (final a in rows) {
      final community = await (_db.select(
        _db.communities,
      )..where((t) => t.id.equals(a.communityId))).getSingleOrNull();
      final project = await (_db.select(
        _db.projects,
      )..where((t) => t.id.equals(a.projectId))).getSingleOrNull();

      markers.add(
        MapMarkerData(
          id: a.id,
          type: 'activity',
          latitude: a.latitude!,
          longitude: a.longitude!,
          title: a.activityType,
          subtitle: community?.name ?? a.communityId,
          detail: project?.name ?? a.projectId,
          registeredAt: DateTime.fromMillisecondsSinceEpoch(a.createdAt),
          fieldOfficerName: a.fieldOfficerId,
        ),
      );
    }
    return markers;
  }

  // ---------------------------------------------------------------------------
  // Demo data centred on Maiduguri, Borno State
  // ---------------------------------------------------------------------------

  static List<MapMarkerData> _demoBeneficiaryMarkers() => [
    const MapMarkerData(
      id: 'db1',
      type: 'beneficiary',
      latitude: 11.8311,
      longitude: 13.1510,
      title: 'Aisha Mohammed',
      subtitle: 'Custom Area',
      detail: 'Education Support',
      fieldOfficerName: 'Usman',
    ),
    const MapMarkerData(
      id: 'db2',
      type: 'beneficiary',
      latitude: 11.8452,
      longitude: 13.1623,
      title: 'Fatima Bello',
      subtitle: 'Gamboru',
      detail: 'WASH Programme',
      fieldOfficerName: 'Halima',
    ),
    const MapMarkerData(
      id: 'db3',
      type: 'beneficiary',
      latitude: 11.8189,
      longitude: 13.1378,
      title: 'Ibrahim Yusuf',
      subtitle: 'Bulumkutu',
      detail: 'Livelihood Training',
      fieldOfficerName: 'Bello',
    ),
    const MapMarkerData(
      id: 'db4',
      type: 'beneficiary',
      latitude: 11.8540,
      longitude: 13.1280,
      title: 'Khadija Mustapha',
      subtitle: 'Mafoni',
      detail: 'Protection Response',
      fieldOfficerName: 'Usman',
    ),
    const MapMarkerData(
      id: 'db5',
      type: 'beneficiary',
      latitude: 11.8090,
      longitude: 13.1700,
      title: 'Musa Adamu',
      subtitle: 'Jiddari Polo',
      detail: 'Education Support',
      fieldOfficerName: 'Halima',
    ),
  ];

  static List<MapMarkerData> _demoActivityMarkers() => [
    const MapMarkerData(
      id: 'da1',
      type: 'activity',
      latitude: 11.8375,
      longitude: 13.1555,
      title: 'Education Outreach',
      subtitle: 'Maiduguri',
      detail: 'Education Support',
    ),
    const MapMarkerData(
      id: 'da2',
      type: 'activity',
      latitude: 11.8230,
      longitude: 13.1460,
      title: 'Water Assessment',
      subtitle: 'Jere',
      detail: 'WASH Programme',
    ),
    const MapMarkerData(
      id: 'da3',
      type: 'activity',
      latitude: 11.8600,
      longitude: 13.1350,
      title: 'Livelihood Training',
      subtitle: 'Konduga',
      detail: 'Livelihood Training',
    ),
  ];
}
