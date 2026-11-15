// ignore_for_file: constant_identifier_names

/// Central source of all realistic demo data for Phase 1 (UI-first).
///
/// Organisation: Borno Startups Foundation (BSF)
/// Head office: Maiduguri, Borno State, Nigeria
///
/// Purpose: BSF is a non-profit, community-driven initiative empowering
/// women, low-income earners, widows, and youth through entrepreneurship
/// training, mentorship, and financial support.
///
/// Key programmes:
///   • ₦100,000 Starter Grant Programme for small-business start-up
///   • Practical Entrepreneurship Training (Hausa & Kanuri)
///   • Relief & Food Support (rice, cooking oil, spaghetti/macaroni)
///   • Monitoring & Evaluation (M&E) field visits
///
/// Field officers register beneficiaries, record grant disbursements,
/// distribute food support, and log daily field activities.
/// Supervisors assign tasks to officers and receive activity reports.
///
/// When Phase 3 (API connection) arrives, swap the static lists with real
/// repository calls — nothing else changes.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class DummyOfficer {
  const DummyOfficer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.projectId,
    required this.avatarInitials,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String projectId;
  final String avatarInitials;
}

class DummyProject {
  const DummyProject({
    required this.id,
    required this.name,
    required this.donor,
    required this.status,
    required this.lgaCount,
    required this.communityCount,
    required this.targetBeneficiaries,
    required this.registeredBeneficiaries,
    required this.activitiesLogged,
    required this.pendingSync,
    required this.startDate,
    required this.endDate,
    required this.color,
  });

  final String id;
  final String name;
  final String donor;
  final String status; // active | completed | suspended
  final int lgaCount;
  final int communityCount;
  final int targetBeneficiaries;
  final int registeredBeneficiaries;
  final int activitiesLogged;
  final int pendingSync;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;

  double get progressPercent =>
      (registeredBeneficiaries / targetBeneficiaries).clamp(0.0, 1.0);
}

class DummyBeneficiary {
  const DummyBeneficiary({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.age,
    required this.lga,
    required this.ward,
    required this.community,
    required this.projectId,
    required this.householdSize,
    required this.vulnerabilityCategory,
    required this.hasGps,
    required this.hasPhoto,
    required this.syncStatus,
    required this.registeredAt,
    required this.fieldOfficerId,
    // NGO-specific fields
    required this.grantAmount,
    required this.registeredBy,
    required this.businessType,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final int age;
  final String lga;
  final String ward;
  final String community;
  final String projectId;
  final int householdSize;
  final String vulnerabilityCategory;
  final bool hasGps;
  final bool hasPhoto;
  final String syncStatus; // pending | synced | failed
  final DateTime registeredAt;
  final String fieldOfficerId;

  /// Grant amount disbursed in Naira (e.g. 100000).
  /// 0 means no grant recorded yet.
  final double grantAmount;

  /// Full name of the field officer who registered this beneficiary.
  final String registeredBy;

  /// Business/livelihood type the grant supports.
  final String businessType;

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  /// Formatted grant amount in Naira.
  String get formattedGrant =>
      grantAmount == 0 ? 'Not recorded' : '₦${_fmt(grantAmount)}';

  static String _fmt(double n) {
    final s = n.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class DummyActivity {
  const DummyActivity({
    required this.id,
    required this.projectId,
    required this.activityType,
    required this.community,
    required this.lga,
    required this.date,
    required this.maleCount,
    required this.femaleCount,
    required this.childrenCount,
    required this.description,
    required this.hasGps,
    required this.photoCount,
    required this.syncStatus,
    required this.fieldOfficerId,
  });

  final String id;
  final String projectId;
  final String activityType;
  final String community;
  final String lga;
  final DateTime date;
  final int maleCount;
  final int femaleCount;
  final int childrenCount;
  final String description;
  final bool hasGps;
  final int photoCount;
  final String syncStatus;
  final String fieldOfficerId;

  int get totalParticipants => maleCount + femaleCount + childrenCount;
}

class DummyCommunity {
  const DummyCommunity({
    required this.id,
    required this.name,
    required this.ward,
    required this.lga,
    required this.state,
    required this.projectId,
    required this.beneficiaryCount,
    required this.activityCount,
    required this.householdCount,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String ward;
  final String lga;
  final String state;
  final String projectId;
  final int beneficiaryCount;
  final int activityCount;
  final int householdCount;
  final double latitude;
  final double longitude;
}

/// A task assigned by a Supervisor/Admin to a field officer.
class DummyTask {
  const DummyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedBy,
    required this.assignedTo,
    required this.projectId,
    required this.community,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.taskType,
  });

  final String id;
  final String title;
  final String description;

  /// Name of the Supervisor/Admin who created this task.
  final String assignedBy;

  /// ID of the field officer this task is assigned to.
  final String assignedTo;

  final String projectId;
  final String community;
  final DateTime dueDate;

  /// 'high' | 'medium' | 'low'
  final String priority;

  /// 'pending' | 'in_progress' | 'completed'
  final String status;

  /// Category: 'registration' | 'monitoring' | 'grant_disbursement' |
  ///           'education' | 'medical' | 'follow_up' | 'report'
  final String taskType;

  bool get isOverdue =>
      status != 'completed' && dueDate.isBefore(DateTime.now());
}

// ---------------------------------------------------------------------------
// The currently logged-in officer
// ---------------------------------------------------------------------------

const kCurrentOfficer = DummyOfficer(
  id: 'off-001',
  name: 'Fatima Usman',
  email: 'fatima.usman@bsf.org.ng',
  role: 'Field Officer',
  phone: '+234 803 456 7890',
  projectId: 'proj-001',
  avatarInitials: 'FU',
);

// ---------------------------------------------------------------------------
// Projects — aligned to BSF's actual programmes
// ---------------------------------------------------------------------------

final kProjects = <DummyProject>[
  DummyProject(
    id: 'proj-001',
    name: '₦100K Starter Grant — Cycle 3',
    donor: 'BSF Internal Fund',
    status: 'active',
    lgaCount: 3,
    communityCount: 12,
    targetBeneficiaries: 500,
    registeredBeneficiaries: 387,
    activitiesLogged: 47,
    pendingSync: 5,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 12, 31),
    color: const Color(0xFF1565C0),
  ),
  DummyProject(
    id: 'proj-002',
    name: 'Entrepreneurship Training 2026',
    donor: 'Dangote Foundation',
    status: 'active',
    lgaCount: 2,
    communityCount: 8,
    targetBeneficiaries: 300,
    registeredBeneficiaries: 241,
    activitiesLogged: 31,
    pendingSync: 2,
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 11, 30),
    color: const Color(0xFF00838F),
  ),
  DummyProject(
    id: 'proj-003',
    name: 'Relief & Food Support Q3',
    donor: 'UNICEF Nigeria',
    status: 'active',
    lgaCount: 2,
    communityCount: 7,
    targetBeneficiaries: 250,
    registeredBeneficiaries: 198,
    activitiesLogged: 22,
    pendingSync: 0,
    startDate: DateTime(2026, 2, 1),
    endDate: DateTime(2026, 10, 31),
    color: const Color(0xFF2E7D32),
  ),
  DummyProject(
    id: 'proj-004',
    name: 'Widows & Youth Empowerment',
    donor: 'EU / USAID',
    status: 'active',
    lgaCount: 3,
    communityCount: 10,
    targetBeneficiaries: 400,
    registeredBeneficiaries: 312,
    activitiesLogged: 38,
    pendingSync: 1,
    startDate: DateTime(2026, 1, 15),
    endDate: DateTime(2026, 12, 15),
    color: const Color(0xFF6A1B9A),
  ),
];

DummyProject get kCurrentProject =>
    kProjects.firstWhere((p) => p.id == kCurrentOfficer.projectId);

// ---------------------------------------------------------------------------
// Communities — actual BSF operational locations in Borno State
// ---------------------------------------------------------------------------

final kCommunities = <DummyCommunity>[
  // ── proj-001 : ₦100K Starter Grant — Cycle 3 ─────────────────────────
  const DummyCommunity(
    id: 'com-001',
    name: 'Muna Garage',
    ward: 'Muna  Ward',
    lga: 'Jere',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 68,
    activityCount: 9,
    householdCount: 28,
    latitude: 11.8700,
    longitude: 13.1900,
  ),
  const DummyCommunity(
    id: 'com-002',
    name: 'Dalori',
    ward: 'Dalori Ward',
    lga: 'Konduga',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 54,
    activityCount: 7,
    householdCount: 22,
    latitude: 11.8600,
    longitude: 13.2100,
  ),
  const DummyCommunity(
    id: 'com-003',
    name: 'Budum Market',
    ward: 'Shehuri Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 82,
    activityCount: 11,
    householdCount: 35,
    latitude: 11.8350,
    longitude: 13.1600,
  ),
  const DummyCommunity(
    id: 'com-004',
    name: 'Monday Market',
    ward: 'Bulaburin Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 95,
    activityCount: 13,
    householdCount: 40,
    latitude: 11.8480,
    longitude: 13.1520,
  ),
  const DummyCommunity(
    id: 'com-005',
    name: 'Mairi',
    ward: 'Mairi Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 48,
    activityCount: 5,
    householdCount: 19,
    latitude: 11.8550,
    longitude: 13.1750,
  ),
  const DummyCommunity(
    id: 'com-006',
    name: 'Dangote Housing Estate',
    ward: 'Mafoni Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-001',
    beneficiaryCount: 40,
    activityCount: 4,
    householdCount: 16,
    latitude: 11.8220,
    longitude: 13.1450,
  ),
  // ── proj-002 : Entrepreneurship Training 2026 ─────────────────────────
  const DummyCommunity(
    id: 'com-007',
    name: 'Tashan Bama',
    ward: 'Tashan Bama Ward',
    lga: 'Jere',
    state: 'Borno',
    projectId: 'proj-002',
    beneficiaryCount: 72,
    activityCount: 8,
    householdCount: 26,
    latitude: 11.8300,
    longitude: 13.1680,
  ),
  const DummyCommunity(
    id: 'com-008',
    name: 'Gwange',
    ward: 'Gwange 1 Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-002',
    beneficiaryCount: 88,
    activityCount: 10,
    householdCount: 31,
    latitude: 11.8450,
    longitude: 13.1550,
  ),
  const DummyCommunity(
    id: 'com-009',
    name: 'Jiddari Polo',
    ward: 'Maisandari Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-002',
    beneficiaryCount: 81,
    activityCount: 7,
    householdCount: 29,
    latitude: 11.8090,
    longitude: 13.1700,
  ),
  // ── proj-003 : Relief & Food Support Q3 ──────────────────────────────
  const DummyCommunity(
    id: 'com-010',
    name: 'Mafoni',
    ward: 'Mafoni Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-003',
    beneficiaryCount: 60,
    activityCount: 6,
    householdCount: 22,
    latitude: 11.8540,
    longitude: 13.1280,
  ),
  const DummyCommunity(
    id: 'com-011',
    name: 'Lamisula',
    ward: 'Lamisula Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-003',
    beneficiaryCount: 55,
    activityCount: 5,
    householdCount: 20,
    latitude: 11.8420,
    longitude: 13.1620,
  ),
  const DummyCommunity(
    id: 'com-012',
    name: 'Bulumkutu',
    ward: 'Bulumkutu Ward',
    lga: 'Konduga',
    state: 'Borno',
    projectId: 'proj-003',
    beneficiaryCount: 83,
    activityCount: 8,
    householdCount: 30,
    latitude: 11.8189,
    longitude: 13.1378,
  ),
  // ── proj-004 : Widows & Youth Empowerment ─────────────────────────────
  const DummyCommunity(
    id: 'com-013',
    name: 'Custom Area',
    ward: 'Custom Ward',
    lga: 'Jere',
    state: 'Borno',
    projectId: 'proj-004',
    beneficiaryCount: 97,
    activityCount: 11,
    householdCount: 36,
    latitude: 11.8311,
    longitude: 13.1510,
  ),
  const DummyCommunity(
    id: 'com-014',
    name: 'Hausari',
    ward: 'Hausari Ward',
    lga: 'Maiduguri',
    state: 'Borno',
    projectId: 'proj-004',
    beneficiaryCount: 78,
    activityCount: 9,
    householdCount: 27,
    latitude: 11.8360,
    longitude: 13.1480,
  ),
  const DummyCommunity(
    id: 'com-015',
    name: 'Konduga Town',
    ward: 'Konduga Ward',
    lga: 'Konduga',
    state: 'Borno',
    projectId: 'proj-004',
    beneficiaryCount: 137,
    activityCount: 12,
    householdCount: 48,
    latitude: 11.7800,
    longitude: 13.2500,
  ),
];

List<DummyCommunity> communitiesForProject(String projectId) =>
    kCommunities.where((c) => c.projectId == projectId).toList();

DummyCommunity? communityById(String id) =>
    kCommunities.where((c) => c.id == id).firstOrNull;

List<DummyBeneficiary> beneficiariesForCommunity(String communityName) =>
    kBeneficiaries.where((b) => b.community == communityName).toList();

List<DummyActivity> activitiesForCommunity(String communityName) =>
    kActivities.where((a) => a.community == communityName).toList();

// ---------------------------------------------------------------------------
// Beneficiaries — BSF target groups: women, widows, low-income earners, youth
// ---------------------------------------------------------------------------

final kBeneficiaries = <DummyBeneficiary>[
  DummyBeneficiary(
    id: 'ben-001',
    firstName: 'Aisha',
    lastName: 'Mohammed',
    gender: 'Female',
    age: 28,
    lga: 'Maiduguri',
    ward: 'Shehuri Ward',
    community: 'Budum Market',
    projectId: 'proj-001',
    householdSize: 6,
    vulnerabilityCategory: 'Widow',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 2, 9, 14),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Petty trading (foodstuffs)',
  ),
  DummyBeneficiary(
    id: 'ben-002',
    firstName: 'Maryam',
    lastName: 'Yusuf',
    gender: 'Female',
    age: 35,
    lga: 'Jere',
    ward: 'Muna Ward',
    community: 'Muna Garage',
    projectId: 'proj-001',
    householdSize: 9,
    vulnerabilityCategory: 'Low-income earner',
    hasGps: true,
    hasPhoto: false,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 3, 10, 30),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Tailoring / fashion design',
  ),
  DummyBeneficiary(
    id: 'ben-003',
    firstName: 'Fatima',
    lastName: 'Bello',
    gender: 'Female',
    age: 32,
    lga: 'Maiduguri',
    ward: 'Bulaburin',
    community: 'Monday Market',
    projectId: 'proj-001',
    householdSize: 4,
    vulnerabilityCategory: 'Widow',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 4, 8, 45),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Groundnut oil processing',
  ),
  DummyBeneficiary(
    id: 'ben-004',
    firstName: 'Khadija',
    lastName: 'Mustapha',
    gender: 'Female',
    age: 22,
    lga: 'Konduga',
    ward: 'Dalori Ward',
    community: 'Dalori',
    projectId: 'proj-001',
    householdSize: 3,
    vulnerabilityCategory: 'Youth (18–35)',
    hasGps: false,
    hasPhoto: true,
    syncStatus: 'pending',
    registeredAt: DateTime(2026, 10, 1, 14, 20),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Vegetable farming',
  ),
  DummyBeneficiary(
    id: 'ben-005',
    firstName: 'Hauwa',
    lastName: 'Adamu',
    gender: 'Female',
    age: 38,
    lga: 'Jere',
    ward: 'Mairi Ward',
    community: 'Mairi',
    projectId: 'proj-001',
    householdSize: 7,
    vulnerabilityCategory: 'Female-headed household',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'pending',
    registeredAt: DateTime(2026, 10, 2, 11, 5),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Food vending (miya / tuwon)',
  ),
  DummyBeneficiary(
    id: 'ben-006',
    firstName: 'Zulaiha',
    lastName: 'Garba',
    gender: 'Female',
    age: 19,
    lga: 'Maiduguri',
    ward: 'Mafoni Ward',
    community: 'Dangote Housing Estate',
    projectId: 'proj-001',
    householdSize: 5,
    vulnerabilityCategory: 'Youth (18–35)',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'pending',
    registeredAt: DateTime(2026, 10, 3, 9, 50),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Hair braiding / cosmetics',
  ),
  DummyBeneficiary(
    id: 'ben-007',
    firstName: 'Ramatu',
    lastName: 'Suleiman',
    gender: 'Female',
    age: 55,
    lga: 'Maiduguri',
    ward: 'Shehu North Ward',
    community: 'Budum Market',
    projectId: 'proj-001',
    householdSize: 8,
    vulnerabilityCategory: 'Widow',
    hasGps: false,
    hasPhoto: false,
    syncStatus: 'failed',
    registeredAt: DateTime(2026, 10, 3, 15, 30),
    fieldOfficerId: 'off-001',
    grantAmount: 0,
    registeredBy: 'Fatima Usman',
    businessType: 'Not yet assigned',
  ),
  DummyBeneficiary(
    id: 'ben-008',
    firstName: 'Zainab',
    lastName: 'Isa',
    gender: 'Female',
    age: 27,
    lga: 'Jere',
    ward: 'Muna Ward',
    community: 'Muna Garage',
    projectId: 'proj-001',
    householdSize: 6,
    vulnerabilityCategory: 'Female-headed household',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'pending',
    registeredAt: DateTime(2026, 10, 4, 8, 10),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Soap making',
  ),
  DummyBeneficiary(
    id: 'ben-009',
    firstName: 'Safiya',
    lastName: 'Hassan',
    gender: 'Female',
    age: 31,
    lga: 'Maiduguri',
    ward: 'Balaburin',
    community: 'Monday Market',
    projectId: 'proj-001',
    householdSize: 5,
    vulnerabilityCategory: 'Low-income earner',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 28, 10, 0),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Kuli-kuli / groundnut snacks',
  ),
  DummyBeneficiary(
    id: 'ben-010',
    firstName: 'Amina',
    lastName: 'Bukar',
    gender: 'Female',
    age: 24,
    lga: 'Konduga',
    ward: 'Dalori Ward',
    community: 'Dalori',
    projectId: 'proj-001',
    householdSize: 4,
    vulnerabilityCategory: 'Youth (18–35)',
    hasGps: true,
    hasPhoto: false,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 25, 13, 40),
    fieldOfficerId: 'off-001',
    grantAmount: 100000,
    registeredBy: 'Fatima Usman',
    businessType: 'Tie-dye / adire fabric',
  ),
];

List<DummyBeneficiary> beneficiariesForOfficer(String officerId) =>
    kBeneficiaries.where((b) => b.fieldOfficerId == officerId).toList();

// ---------------------------------------------------------------------------
// Activities — BSF field work
// ---------------------------------------------------------------------------

final kActivities = <DummyActivity>[
  DummyActivity(
    id: 'act-001',
    projectId: 'proj-001',
    activityType: 'Grant Disbursement',
    community: 'Budum Market',
    lga: 'Maiduguri',
    date: DateTime(2026, 10, 5, 10, 30),
    maleCount: 0,
    femaleCount: 22,
    childrenCount: 0,
    description:
        'Disbursed ₦100,000 BSF Starter Grants to 22 registered '
        'beneficiaries at Budum Market. Each recipient signed and '
        'thumbprinted. Funds transferred via PalmPay wallet. '
        'All beneficiaries received briefing on record-keeping and '
        'separating personal funds from business capital.',
    hasGps: true,
    photoCount: 5,
    syncStatus: 'pending',
    fieldOfficerId: 'off-001',
  ),
  DummyActivity(
    id: 'act-002',
    projectId: 'proj-001',
    activityType: 'Beneficiary Registration',
    community: 'Monday Market',
    lga: 'Maiduguri',
    date: DateTime(2026, 10, 4, 9, 0),
    maleCount: 0,
    femaleCount: 15,
    childrenCount: 0,
    description:
        'Registered 15 eligible women at Monday Market area. '
        'Assessed vulnerability status (widows, female-headed households). '
        'GPS and photos captured for 12 of 15. Remaining 3 to be '
        'completed on follow-up visit.',
    hasGps: true,
    photoCount: 5,
    syncStatus: 'pending',
    fieldOfficerId: 'off-001',
  ),
  DummyActivity(
    id: 'act-003',
    projectId: 'proj-001',
    activityType: 'M&E Business Monitoring',
    community: 'Muna Garage',
    lga: 'Jere',
    date: DateTime(2026, 10, 3, 14, 0),
    maleCount: 0,
    femaleCount: 18,
    childrenCount: 0,
    description:
        'Monitoring & Evaluation visit to 18 BSF grantees at Muna Garage. '
        'Photographed business stalls and kiosks. 14 of 18 businesses '
        'are operational and growing. 4 flagged for additional mentorship '
        'on reinvesting profits.',
    hasGps: true,
    photoCount: 8,
    syncStatus: 'synced',
    fieldOfficerId: 'off-001',
  ),
  DummyActivity(
    id: 'act-004',
    projectId: 'proj-001',
    activityType: 'Entrepreneurship Training',
    community: 'Dalori',
    lga: 'Jere',
    date: DateTime(2026, 10, 1, 10, 0),
    maleCount: 5,
    femaleCount: 28,
    childrenCount: 0,
    description:
        'Practical training session delivered in Hausa and Kanuri. '
        'Topics covered: record-keeping, financial discipline, '
        'separating personal and business funds, reinvesting profits, '
        'and customer service. Trainer: BSF programme officer.',
    hasGps: false,
    photoCount: 3,
    syncStatus: 'synced',
    fieldOfficerId: 'off-001',
  ),
  DummyActivity(
    id: 'act-005',
    projectId: 'proj-003',
    activityType: 'Food & Relief Distribution',
    community: 'Mairi',
    lga: 'Maiduguri',
    date: DateTime(2026, 9, 29, 8, 30),
    maleCount: 0,
    femaleCount: 20,
    childrenCount: 12,
    description:
        'Distributed BSF food support packages to 20 beneficiary families '
        'at Mairi: 10 kg rice, 1 litre cooking oil, and spaghetti/macaroni '
        'per household. Packages help families protect business capital '
        'by covering household food needs.',
    hasGps: true,
    photoCount: 4,
    syncStatus: 'synced',
    fieldOfficerId: 'off-001',
  ),
  DummyActivity(
    id: 'act-006',
    projectId: 'proj-002',
    activityType: 'Skills Training',
    community: 'Dangote Housing Estate',
    lga: 'Maiduguri',
    date: DateTime(2026, 9, 27, 15, 0),
    maleCount: 3,
    femaleCount: 27,
    childrenCount: 0,
    description:
        'Two-day soap-making and packaging workshop for 30 BSF trainees '
        'at Dangote Housing Estate. Supplied caustic soda, palm oil, '
        'moulds, and labelling materials. Trainer: Hajiya Binta '
        '(SMEDAN-certified). All participants received starter kits.',
    hasGps: true,
    photoCount: 6,
    syncStatus: 'synced',
    fieldOfficerId: 'off-001',
  ),
];

List<DummyActivity> activitiesForOfficer(String officerId) =>
    kActivities.where((a) => a.fieldOfficerId == officerId).toList();

// ---------------------------------------------------------------------------
// Tasks — assigned by BSF Supervisor to field officer
// ---------------------------------------------------------------------------

final kTasks = <DummyTask>[
  DummyTask(
    id: 'task-001',
    title: 'Register 10 new beneficiaries — Muna Garage',
    description:
        'Visit Muna Garage and register at least 10 eligible women and widows '
        'for the BSF ₦100K Starter Grant Cycle 3. Priority: widows and '
        'female-headed households. Capture GPS and photo for each. '
        'Submit completed forms by end of day.',
    assignedBy: 'Supervisor Halima Baba',
    assignedTo: 'off-001',
    projectId: 'proj-001',
    community: 'Muna Garage',
    dueDate: DateTime(2026, 10, 10),
    priority: 'high',
    status: 'pending',
    taskType: 'registration',
  ),
  DummyTask(
    id: 'task-002',
    title: 'M&E visit — Dalori grantees',
    description:
        'Conduct M&E monitoring visit for all BSF grantees at Dalori. '
        'Photograph their business stalls/kiosks, record current stock '
        'and revenue, and assess whether they are reinvesting profits. '
        'Flag anyone needing additional mentorship.',
    assignedBy: 'Supervisor Halima Baba',
    assignedTo: 'off-001',
    projectId: 'proj-001',
    community: 'Dalori',
    dueDate: DateTime(2026, 10, 8),
    priority: 'high',
    status: 'in_progress',
    taskType: 'monitoring',
  ),
  DummyTask(
    id: 'task-003',
    title: 'Disburse grants — Monday Market cohort',
    description:
        'Process ₦100,000 BSF Starter Grant disbursement for 8 verified '
        'beneficiaries at Monday Market. Confirm PalmPay wallet numbers, '
        'complete disbursement forms, collect signed receipts. '
        'Brief each recipient on record-keeping and separating '
        'business from personal funds.',
    assignedBy: 'Programme Manager Amina Gana',
    assignedTo: 'off-001',
    projectId: 'proj-001',
    community: 'Monday Market',
    dueDate: DateTime(2026, 10, 12),
    priority: 'high',
    status: 'pending',
    taskType: 'grant_disbursement',
  ),
  DummyTask(
    id: 'task-004',
    title: 'Food relief distribution — Mairi',
    description:
        'Distribute BSF food support packages to 15 beneficiary families '
        'at Mairi: 10 kg rice, 1 litre cooking oil, and spaghetti/macaroni '
        'per household. Confirm receipt by signature. Photograph distribution. '
        'Ensure families understand the food is to protect their business capital.',
    assignedBy: 'Supervisor Halima Baba',
    assignedTo: 'off-001',
    projectId: 'proj-003',
    community: 'Mairi',
    dueDate: DateTime(2026, 10, 15),
    priority: 'medium',
    status: 'pending',
    taskType: 'grant_disbursement',
  ),
  DummyTask(
    id: 'task-005',
    title: 'Weekly field report — Week 40',
    description:
        'Submit BSF weekly activity report for Week 40 (29 Sep – 5 Oct 2026). '
        'Include: number of beneficiaries registered, grants disbursed, '
        'training sessions held, food packages distributed, '
        'challenges encountered, and photos.',
    assignedBy: 'Programme Manager Amina Gana',
    assignedTo: 'off-001',
    projectId: 'proj-001',
    community: 'All communities',
    dueDate: DateTime(2026, 10, 7),
    priority: 'medium',
    status: 'completed',
    taskType: 'report',
  ),
  DummyTask(
    id: 'task-006',
    title: 'Training prep — Budum Market cohort',
    description:
        'Arrange venue and training materials for upcoming BSF '
        'Entrepreneurship Training at Budum Market for 25 beneficiaries. '
        'Session to be delivered in Hausa. Confirm attendance list and '
        'coordinate with BSF trainer on topics: record-keeping, '
        'financial discipline, customer service.',
    assignedBy: 'Supervisor Halima Baba',
    assignedTo: 'off-001',
    projectId: 'proj-002',
    community: 'Budum Market',
    dueDate: DateTime(2026, 10, 20),
    priority: 'low',
    status: 'pending',
    taskType: 'education',
  ),
];

List<DummyTask> tasksForOfficer(String officerId) =>
    kTasks.where((t) => t.assignedTo == officerId).toList();

List<DummyTask> pendingTasksForOfficer(String officerId) => kTasks
    .where((t) => t.assignedTo == officerId && t.status != 'completed')
    .toList();

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns the greeting based on current hour.
String get currentGreeting {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

/// Human-readable relative date.
String relativeDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(d.year, d.month, d.day);
  final diff = today.difference(date).inDays;
  if (diff == 0) return 'Today, ${_timeStr(d)}';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '${diff}d ago';
  return '${d.day} ${_months[d.month - 1]}';
}

/// Due-date label for tasks.
String dueDateLabel(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(d.year, d.month, d.day);
  final diff = due.difference(today).inDays;
  if (diff < 0) return 'Overdue by ${-diff}d';
  if (diff == 0) return 'Due today';
  if (diff == 1) return 'Due tomorrow';
  if (diff < 7) return 'Due in ${diff}d';
  return 'Due ${d.day} ${_months[d.month - 1]}';
}

String _timeStr(DateTime d) {
  final h = d.hour;
  final m = d.minute.toString().padLeft(2, '0');
  final period = h >= 12 ? 'PM' : 'AM';
  final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$hour12:$m $period';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

// ---------------------------------------------------------------------------
// Admin / Supervisor model & data
// ---------------------------------------------------------------------------

class DummyAdmin {
  const DummyAdmin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.avatarInitials,
  });

  final String id;
  final String name;
  final String email;

  /// 'Supervisor' | 'Programme Manager' | 'Administrator'
  final String role;
  final String phone;
  final String avatarInitials;
}

const kCurrentAdmin = DummyAdmin(
  id: 'adm-001',
  name: 'Halima Baba',
  email: 'admin@bsf.org.ng',
  role: 'Supervisor',
  phone: '+234 805 123 4567',
  avatarInitials: 'HB',
);

/// All field officers visible to the admin.
final kAllOfficers = <DummyOfficer>[
  kCurrentOfficer, // Fatima Usman — off-001
  const DummyOfficer(
    id: 'off-002',
    name: 'Musa Ibrahim',
    email: 'musa.ibrahim@bsf.org.ng',
    role: 'Field Officer',
    phone: '+234 806 234 5678',
    projectId: 'proj-002',
    avatarInitials: 'MI',
  ),
  const DummyOfficer(
    id: 'off-003',
    name: 'Aisha Kabiru',
    email: 'aisha.kabiru@bsf.org.ng',
    role: 'Field Officer',
    phone: '+234 807 345 6789',
    projectId: 'proj-003',
    avatarInitials: 'AK',
  ),
  const DummyOfficer(
    id: 'off-004',
    name: 'Yusuf Bello',
    email: 'yusuf.bello@bsf.org.ng',
    role: 'Field Officer',
    phone: '+234 808 456 7890',
    projectId: 'proj-004',
    avatarInitials: 'YB',
  ),
];

/// Extra beneficiaries registered by officers 2, 3, 4 so the admin
/// sees data beyond the current officer's records.
final kExtraBeneficiaries = <DummyBeneficiary>[
  DummyBeneficiary(
    id: 'ben-011',
    firstName: 'Bilkisu',
    lastName: 'Ahmed',
    gender: 'Female',
    age: 26,
    lga: 'Maiduguri',
    ward: 'Tashan Bama Ward',
    community: 'Tashan Bama',
    projectId: 'proj-002',
    householdSize: 4,
    vulnerabilityCategory: 'Youth (18–35)',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 10, 9, 0),
    fieldOfficerId: 'off-002',
    grantAmount: 100000,
    registeredBy: 'Musa Ibrahim',
    businessType: 'Petty trading (foodstuffs)',
  ),
  DummyBeneficiary(
    id: 'ben-012',
    firstName: 'Hadiza',
    lastName: 'Musa',
    gender: 'Female',
    age: 30,
    lga: 'Maiduguri',
    ward: 'Gwange Ward',
    community: 'Gwange',
    projectId: 'proj-002',
    householdSize: 6,
    vulnerabilityCategory: 'Widow',
    hasGps: true,
    hasPhoto: false,
    syncStatus: 'pending',
    registeredAt: DateTime(2026, 9, 12, 11, 0),
    fieldOfficerId: 'off-002',
    grantAmount: 100000,
    registeredBy: 'Musa Ibrahim',
    businessType: 'Food vending (miya / tuwon)',
  ),
  DummyBeneficiary(
    id: 'ben-013',
    firstName: 'Mariam',
    lastName: 'Lawan',
    gender: 'Female',
    age: 23,
    lga: 'Jere',
    ward: 'Mafoni Ward',
    community: 'Mafoni',
    projectId: 'proj-003',
    householdSize: 3,
    vulnerabilityCategory: 'Youth (18–35)',
    hasGps: false,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 15, 8, 30),
    fieldOfficerId: 'off-003',
    grantAmount: 100000,
    registeredBy: 'Aisha Kabiru',
    businessType: 'Tailoring / fashion design',
  ),
  DummyBeneficiary(
    id: 'ben-014',
    firstName: 'Rukayya',
    lastName: 'Goni',
    gender: 'Female',
    age: 29,
    lga: 'Maiduguri',
    ward: 'Hausari Ward',
    community: 'Hausari',
    projectId: 'proj-004',
    householdSize: 7,
    vulnerabilityCategory: 'Widow',
    hasGps: true,
    hasPhoto: true,
    syncStatus: 'synced',
    registeredAt: DateTime(2026, 9, 18, 10, 0),
    fieldOfficerId: 'off-004',
    grantAmount: 100000,
    registeredBy: 'Yusuf Bello',
    businessType: 'Groundnut oil processing',
  ),


];

/// Extra activities from officers 2, 3, 4.
final kExtraActivities = <DummyActivity>[
  DummyActivity(
    id: 'act-007',
    projectId: 'proj-002',
    activityType: 'Entrepreneurship Training',
    community: 'Tashan Bama',
    lga: 'Maiduguri',
    date: DateTime(2026, 10, 4, 10, 0),
    maleCount: 3,
    femaleCount: 18,
    childrenCount: 0,
    description:
        'BSF Entrepreneurship Training delivered in Hausa at Tashan Bama. '
        'Covered: record-keeping, customer service, reinvesting profits. '
        '21 participants completed practical exercises.',
    hasGps: true,
    photoCount: 4,
    syncStatus: 'synced',
    fieldOfficerId: 'off-002',
  ),
  DummyActivity(
    id: 'act-008',
    projectId: 'proj-003',
    activityType: 'Food & Relief Distribution',
    community: 'Lamisula',
    lga: 'Jere',
    date: DateTime(2026, 10, 2, 9, 0),
    maleCount: 0,
    femaleCount: 18,
    childrenCount: 10,
    description:
        'BSF food support distributed to 18 families at Lamisula: rice, '
        'cooking oil, spaghetti. Beneficiaries briefed on protecting '
        'business capital from household expenses.',
    hasGps: true,
    photoCount: 5,
    syncStatus: 'pending',
    fieldOfficerId: 'off-003',
  ),
  DummyActivity(
    id: 'act-009',
    projectId: 'proj-004',
    activityType: 'Grant Disbursement',
    community: 'Konduga Town',
    lga: 'Konduga',
    date: DateTime(2026, 10, 1, 8, 0),
    maleCount: 0,
    femaleCount: 14,
    childrenCount: 0,
    description:
        'Disbursed ₦100,000 BSF Starter Grants to 14 widows and '
        'low-income earners at Konduga Town. Funds transferred via '
        'PalmPay. All recipients trained on separating personal '
        'and business funds.',
    hasGps: true,
    photoCount: 3,
    syncStatus: 'synced',
    fieldOfficerId: 'off-004',
  ),
];

/// All beneficiaries across all officers.
List<DummyBeneficiary> get kAllBeneficiaries => [
  ...kBeneficiaries,
  ...kExtraBeneficiaries,
];

/// All activities across all officers.
List<DummyActivity> get kAllActivities => [...kActivities, ...kExtraActivities];

/// Tasks assigned by a specific admin.
List<DummyTask> tasksAssignedBy(String adminId) => kTasks
    .where(
      (t) => t.assignedBy.contains('Halima') || t.assignedBy.contains('Amina'),
    )
    .toList();

/// Summary stats per officer for the admin overview.
class OfficerSummary {
  OfficerSummary({
    required this.officer,
    required this.beneficiariesCount,
    required this.activitiesCount,
    required this.pendingTasksCount,
    required this.grantsTotal,
    required this.lastActiveDate,
  });

  final DummyOfficer officer;
  final int beneficiariesCount;
  final int activitiesCount;
  final int pendingTasksCount;
  final double grantsTotal;
  final DateTime? lastActiveDate;

  String get lastActiveSummary {
    if (lastActiveDate == null) return 'No activity';
    return relativeDate(lastActiveDate!);
  }
}

List<OfficerSummary> get kOfficerSummaries => kAllOfficers.map((o) {
  final benefs = kAllBeneficiaries
      .where((b) => b.fieldOfficerId == o.id)
      .toList();
  final acts = kAllActivities.where((a) => a.fieldOfficerId == o.id).toList();
  final tasks = kTasks
      .where((t) => t.assignedTo == o.id && t.status != 'completed')
      .toList();
  final grants = benefs.fold<double>(0, (sum, b) => sum + b.grantAmount);
  final lastDate = acts.isEmpty
      ? null
      : acts.map((a) => a.date).reduce((a, b) => a.isAfter(b) ? a : b);
  return OfficerSummary(
    officer: o,
    beneficiariesCount: benefs.length,
    activitiesCount: acts.length,
    pendingTasksCount: tasks.length,
    grantsTotal: grants,
    lastActiveDate: lastDate,
  );
}).toList();
