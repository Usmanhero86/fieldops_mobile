// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// region Users

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String fullName;
  final String role;
  final String? sessionToken;
  final int syncedAt;

  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.sessionToken,
    required this.syncedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['full_name'] = Variable<String>(fullName);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || sessionToken != null) {
      map['session_token'] = Variable<String>(sessionToken);
    }
    map['synced_at'] = Variable<int>(syncedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      fullName: Value(fullName),
      role: Value(role),
      sessionToken: sessionToken == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionToken),
      syncedAt: Value(syncedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      fullName: serializer.fromJson<String>(json['full_name']),
      role: serializer.fromJson<String>(json['role']),
      sessionToken: serializer.fromJson<String?>(json['session_token']),
      syncedAt: serializer.fromJson<int>(json['synced_at']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'full_name': serializer.toJson<String>(fullName),
      'role': serializer.toJson<String>(role),
      'session_token': serializer.toJson<String?>(sessionToken),
      'synced_at': serializer.toJson<int>(syncedAt),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    String? role,
    Value<String?> sessionToken = const Value.absent(),
    int? syncedAt,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    sessionToken: sessionToken.present ? sessionToken.value : this.sessionToken,
    syncedAt: syncedAt ?? this.syncedAt,
  );

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, fullName, role, sessionToken, syncedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == id &&
          other.username == username &&
          other.fullName == fullName &&
          other.role == role &&
          other.sessionToken == sessionToken &&
          other.syncedAt == syncedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> fullName;
  final Value<String> role;
  final Value<String?> sessionToken;
  final Value<int> syncedAt;

  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });

  UsersCompanion.insert({
    required String id,
    required String username,
    required String fullName,
    required String role,
    this.sessionToken = const Value.absent(),
    required int syncedAt,
  }) : id = Value(id),
       username = Value(username),
       fullName = Value(fullName),
       role = Value(role),
       syncedAt = Value(syncedAt);

  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<String>? role,
    Expression<String>? sessionToken,
    Expression<int>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
      if (sessionToken != null) 'session_token': sessionToken,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String>? fullName,
    Value<String>? role,
    Value<String?>? sessionToken,
    Value<int>? syncedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      sessionToken: sessionToken ?? this.sessionToken,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (username.present) map['username'] = Variable<String>(username.value);
    if (fullName.present) map['full_name'] = Variable<String>(fullName.value);
    if (role.present) map['role'] = Variable<String>(role.value);
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (syncedAt.present) map['synced_at'] = Variable<int>(syncedAt.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

// region Projects

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String status;
  final String fieldOfficerId;
  final int communityCount;
  final int syncedAt;

  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.fieldOfficerId,
    required this.communityCount,
    required this.syncedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['field_officer_id'] = Variable<String>(fieldOfficerId);
    map['community_count'] = Variable<int>(communityCount);
    map['synced_at'] = Variable<int>(syncedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      fieldOfficerId: Value(fieldOfficerId),
      communityCount: Value(communityCount),
      syncedAt: Value(syncedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      fieldOfficerId: serializer.fromJson<String>(json['field_officer_id']),
      communityCount: serializer.fromJson<int>(json['community_count']),
      syncedAt: serializer.fromJson<int>(json['synced_at']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'field_officer_id': serializer.toJson<String>(fieldOfficerId),
      'community_count': serializer.toJson<int>(communityCount),
      'synced_at': serializer.toJson<int>(syncedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? status,
    String? fieldOfficerId,
    int? communityCount,
    int? syncedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
    communityCount: communityCount ?? this.communityCount,
    syncedAt: syncedAt ?? this.syncedAt,
  );

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('communityCount: $communityCount, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, status, fieldOfficerId, communityCount, syncedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == id &&
          other.name == name &&
          other.status == status &&
          other.fieldOfficerId == fieldOfficerId &&
          other.communityCount == communityCount &&
          other.syncedAt == syncedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> fieldOfficerId;
  final Value<int> communityCount;
  final Value<int> syncedAt;

  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.fieldOfficerId = const Value.absent(),
    this.communityCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });

  ProjectsCompanion.insert({
    required String id,
    required String name,
    required String status,
    required String fieldOfficerId,
    required int communityCount,
    required int syncedAt,
  }) : id = Value(id),
       name = Value(name),
       status = Value(status),
       fieldOfficerId = Value(fieldOfficerId),
       communityCount = Value(communityCount),
       syncedAt = Value(syncedAt);

  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? fieldOfficerId,
    Expression<int>? communityCount,
    Expression<int>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (fieldOfficerId != null) 'field_officer_id': fieldOfficerId,
      if (communityCount != null) 'community_count': communityCount,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? fieldOfficerId,
    Value<int>? communityCount,
    Value<int>? syncedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
      communityCount: communityCount ?? this.communityCount,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (status.present) map['status'] = Variable<String>(status.value);
    if (fieldOfficerId.present) {
      map['field_officer_id'] = Variable<String>(fieldOfficerId.value);
    }
    if (communityCount.present) {
      map['community_count'] = Variable<int>(communityCount.value);
    }
    if (syncedAt.present) map['synced_at'] = Variable<int>(syncedAt.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('communityCount: $communityCount, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

// region Communities

class Community extends DataClass implements Insertable<Community> {
  final String id;
  final String name;
  final String ward;
  final String lga;
  final String projectId;
  final int syncedAt;

  const Community({
    required this.id,
    required this.name,
    required this.ward,
    required this.lga,
    required this.projectId,
    required this.syncedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['ward'] = Variable<String>(ward);
    map['lga'] = Variable<String>(lga);
    map['project_id'] = Variable<String>(projectId);
    map['synced_at'] = Variable<int>(syncedAt);
    return map;
  }

  CommunitiesCompanion toCompanion(bool nullToAbsent) {
    return CommunitiesCompanion(
      id: Value(id),
      name: Value(name),
      ward: Value(ward),
      lga: Value(lga),
      projectId: Value(projectId),
      syncedAt: Value(syncedAt),
    );
  }

  factory Community.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Community(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ward: serializer.fromJson<String>(json['ward']),
      lga: serializer.fromJson<String>(json['lga']),
      projectId: serializer.fromJson<String>(json['project_id']),
      syncedAt: serializer.fromJson<int>(json['synced_at']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'ward': serializer.toJson<String>(ward),
      'lga': serializer.toJson<String>(lga),
      'project_id': serializer.toJson<String>(projectId),
      'synced_at': serializer.toJson<int>(syncedAt),
    };
  }

  Community copyWith({
    String? id,
    String? name,
    String? ward,
    String? lga,
    String? projectId,
    int? syncedAt,
  }) => Community(
    id: id ?? this.id,
    name: name ?? this.name,
    ward: ward ?? this.ward,
    lga: lga ?? this.lga,
    projectId: projectId ?? this.projectId,
    syncedAt: syncedAt ?? this.syncedAt,
  );

  @override
  String toString() {
    return (StringBuffer('Community(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ward: $ward, ')
          ..write('lga: $lga, ')
          ..write('projectId: $projectId, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ward, lga, projectId, syncedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Community &&
          other.id == id &&
          other.name == name &&
          other.ward == ward &&
          other.lga == lga &&
          other.projectId == projectId &&
          other.syncedAt == syncedAt);
}

class CommunitiesCompanion extends UpdateCompanion<Community> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> ward;
  final Value<String> lga;
  final Value<String> projectId;
  final Value<int> syncedAt;

  const CommunitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ward = const Value.absent(),
    this.lga = const Value.absent(),
    this.projectId = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });

  CommunitiesCompanion.insert({
    required String id,
    required String name,
    required String ward,
    required String lga,
    required String projectId,
    required int syncedAt,
  }) : id = Value(id),
       name = Value(name),
       ward = Value(ward),
       lga = Value(lga),
       projectId = Value(projectId),
       syncedAt = Value(syncedAt);

  static Insertable<Community> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? ward,
    Expression<String>? lga,
    Expression<String>? projectId,
    Expression<int>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ward != null) 'ward': ward,
      if (lga != null) 'lga': lga,
      if (projectId != null) 'project_id': projectId,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CommunitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? ward,
    Value<String>? lga,
    Value<String>? projectId,
    Value<int>? syncedAt,
  }) {
    return CommunitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ward: ward ?? this.ward,
      lga: lga ?? this.lga,
      projectId: projectId ?? this.projectId,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (ward.present) map['ward'] = Variable<String>(ward.value);
    if (lga.present) map['lga'] = Variable<String>(lga.value);
    if (projectId.present)
      map['project_id'] = Variable<String>(projectId.value);
    if (syncedAt.present) map['synced_at'] = Variable<int>(syncedAt.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ward: $ward, ')
          ..write('lga: $lga, ')
          ..write('projectId: $projectId, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

// region Beneficiaries

class Beneficiary extends DataClass implements Insertable<Beneficiary> {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final int dateOfBirth;
  final String? phoneNumber;
  final String lga;
  final String ward;
  final String communityId;
  final String projectId;
  final int? householdSize;
  final String? vulnerabilityCategory;
  final double? latitude;
  final double? longitude;
  final int? gpsTimestamp;
  final String fieldOfficerId;
  final String? photoPath;
  final String syncStatus;
  final int createdAt;
  final int updatedAt;

  const Beneficiary({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    this.phoneNumber,
    required this.lga,
    required this.ward,
    required this.communityId,
    required this.projectId,
    this.householdSize,
    this.vulnerabilityCategory,
    this.latitude,
    this.longitude,
    this.gpsTimestamp,
    required this.fieldOfficerId,
    this.photoPath,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['gender'] = Variable<String>(gender);
    map['date_of_birth'] = Variable<int>(dateOfBirth);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['lga'] = Variable<String>(lga);
    map['ward'] = Variable<String>(ward);
    map['community_id'] = Variable<String>(communityId);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || householdSize != null) {
      map['household_size'] = Variable<int>(householdSize);
    }
    if (!nullToAbsent || vulnerabilityCategory != null) {
      map['vulnerability_category'] = Variable<String>(vulnerabilityCategory);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || gpsTimestamp != null) {
      map['gps_timestamp'] = Variable<int>(gpsTimestamp);
    }
    map['field_officer_id'] = Variable<String>(fieldOfficerId);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BeneficiariesCompanion toCompanion(bool nullToAbsent) {
    return BeneficiariesCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      gender: Value(gender),
      dateOfBirth: Value(dateOfBirth),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      lga: Value(lga),
      ward: Value(ward),
      communityId: Value(communityId),
      projectId: Value(projectId),
      householdSize: householdSize == null && nullToAbsent
          ? const Value.absent()
          : Value(householdSize),
      vulnerabilityCategory: vulnerabilityCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(vulnerabilityCategory),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      gpsTimestamp: gpsTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsTimestamp),
      fieldOfficerId: Value(fieldOfficerId),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Beneficiary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beneficiary(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['first_name']),
      lastName: serializer.fromJson<String>(json['last_name']),
      gender: serializer.fromJson<String>(json['gender']),
      dateOfBirth: serializer.fromJson<int>(json['date_of_birth']),
      phoneNumber: serializer.fromJson<String?>(json['phone_number']),
      lga: serializer.fromJson<String>(json['lga']),
      ward: serializer.fromJson<String>(json['ward']),
      communityId: serializer.fromJson<String>(json['community_id']),
      projectId: serializer.fromJson<String>(json['project_id']),
      householdSize: serializer.fromJson<int?>(json['household_size']),
      vulnerabilityCategory: serializer.fromJson<String?>(
        json['vulnerability_category'],
      ),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      gpsTimestamp: serializer.fromJson<int?>(json['gps_timestamp']),
      fieldOfficerId: serializer.fromJson<String>(json['field_officer_id']),
      photoPath: serializer.fromJson<String?>(json['photo_path']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String>(lastName),
      'gender': serializer.toJson<String>(gender),
      'date_of_birth': serializer.toJson<int>(dateOfBirth),
      'phone_number': serializer.toJson<String?>(phoneNumber),
      'lga': serializer.toJson<String>(lga),
      'ward': serializer.toJson<String>(ward),
      'community_id': serializer.toJson<String>(communityId),
      'project_id': serializer.toJson<String>(projectId),
      'household_size': serializer.toJson<int?>(householdSize),
      'vulnerability_category': serializer.toJson<String?>(
        vulnerabilityCategory,
      ),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'gps_timestamp': serializer.toJson<int?>(gpsTimestamp),
      'field_officer_id': serializer.toJson<String>(fieldOfficerId),
      'photo_path': serializer.toJson<String?>(photoPath),
      'sync_status': serializer.toJson<String>(syncStatus),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
    };
  }

  Beneficiary copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? gender,
    int? dateOfBirth,
    Value<String?> phoneNumber = const Value.absent(),
    String? lga,
    String? ward,
    String? communityId,
    String? projectId,
    Value<int?> householdSize = const Value.absent(),
    Value<String?> vulnerabilityCategory = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<int?> gpsTimestamp = const Value.absent(),
    String? fieldOfficerId,
    Value<String?> photoPath = const Value.absent(),
    String? syncStatus,
    int? createdAt,
    int? updatedAt,
  }) => Beneficiary(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    gender: gender ?? this.gender,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    lga: lga ?? this.lga,
    ward: ward ?? this.ward,
    communityId: communityId ?? this.communityId,
    projectId: projectId ?? this.projectId,
    householdSize: householdSize.present
        ? householdSize.value
        : this.householdSize,
    vulnerabilityCategory: vulnerabilityCategory.present
        ? vulnerabilityCategory.value
        : this.vulnerabilityCategory,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    gpsTimestamp: gpsTimestamp.present ? gpsTimestamp.value : this.gpsTimestamp,
    fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  String toString() {
    return (StringBuffer('Beneficiary(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('lga: $lga, ')
          ..write('ward: $ward, ')
          ..write('communityId: $communityId, ')
          ..write('projectId: $projectId, ')
          ..write('householdSize: $householdSize, ')
          ..write('vulnerabilityCategory: $vulnerabilityCategory, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('gpsTimestamp: $gpsTimestamp, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('photoPath: $photoPath, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    firstName,
    lastName,
    gender,
    dateOfBirth,
    phoneNumber,
    lga,
    ward,
    communityId,
    projectId,
    householdSize,
    vulnerabilityCategory,
    latitude,
    longitude,
    gpsTimestamp,
    fieldOfficerId,
    photoPath,
    syncStatus,
    createdAt,
    updatedAt,
  ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beneficiary &&
          other.id == id &&
          other.firstName == firstName &&
          other.lastName == lastName &&
          other.gender == gender &&
          other.dateOfBirth == dateOfBirth &&
          other.phoneNumber == phoneNumber &&
          other.lga == lga &&
          other.ward == ward &&
          other.communityId == communityId &&
          other.projectId == projectId &&
          other.householdSize == householdSize &&
          other.vulnerabilityCategory == vulnerabilityCategory &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.gpsTimestamp == gpsTimestamp &&
          other.fieldOfficerId == fieldOfficerId &&
          other.photoPath == photoPath &&
          other.syncStatus == syncStatus &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt);
}

class BeneficiariesCompanion extends UpdateCompanion<Beneficiary> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> gender;
  final Value<int> dateOfBirth;
  final Value<String?> phoneNumber;
  final Value<String> lga;
  final Value<String> ward;
  final Value<String> communityId;
  final Value<String> projectId;
  final Value<int?> householdSize;
  final Value<String?> vulnerabilityCategory;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int?> gpsTimestamp;
  final Value<String> fieldOfficerId;
  final Value<String?> photoPath;
  final Value<String> syncStatus;
  final Value<int> createdAt;
  final Value<int> updatedAt;

  const BeneficiariesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.lga = const Value.absent(),
    this.ward = const Value.absent(),
    this.communityId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.householdSize = const Value.absent(),
    this.vulnerabilityCategory = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.gpsTimestamp = const Value.absent(),
    this.fieldOfficerId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  BeneficiariesCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    required String gender,
    required int dateOfBirth,
    this.phoneNumber = const Value.absent(),
    required String lga,
    required String ward,
    required String communityId,
    required String projectId,
    this.householdSize = const Value.absent(),
    this.vulnerabilityCategory = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.gpsTimestamp = const Value.absent(),
    required String fieldOfficerId,
    this.photoPath = const Value.absent(),
    this.syncStatus = const Value(r'pending'),
    required int createdAt,
    required int updatedAt,
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName),
       gender = Value(gender),
       dateOfBirth = Value(dateOfBirth),
       lga = Value(lga),
       ward = Value(ward),
       communityId = Value(communityId),
       projectId = Value(projectId),
       fieldOfficerId = Value(fieldOfficerId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);

  static Insertable<Beneficiary> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? gender,
    Expression<int>? dateOfBirth,
    Expression<String>? phoneNumber,
    Expression<String>? lga,
    Expression<String>? ward,
    Expression<String>? communityId,
    Expression<String>? projectId,
    Expression<int>? householdSize,
    Expression<String>? vulnerabilityCategory,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? gpsTimestamp,
    Expression<String>? fieldOfficerId,
    Expression<String>? photoPath,
    Expression<String>? syncStatus,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (lga != null) 'lga': lga,
      if (ward != null) 'ward': ward,
      if (communityId != null) 'community_id': communityId,
      if (projectId != null) 'project_id': projectId,
      if (householdSize != null) 'household_size': householdSize,
      if (vulnerabilityCategory != null)
        'vulnerability_category': vulnerabilityCategory,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (gpsTimestamp != null) 'gps_timestamp': gpsTimestamp,
      if (fieldOfficerId != null) 'field_officer_id': fieldOfficerId,
      if (photoPath != null) 'photo_path': photoPath,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BeneficiariesCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? gender,
    Value<int>? dateOfBirth,
    Value<String?>? phoneNumber,
    Value<String>? lga,
    Value<String>? ward,
    Value<String>? communityId,
    Value<String>? projectId,
    Value<int?>? householdSize,
    Value<String?>? vulnerabilityCategory,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int?>? gpsTimestamp,
    Value<String>? fieldOfficerId,
    Value<String?>? photoPath,
    Value<String>? syncStatus,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return BeneficiariesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lga: lga ?? this.lga,
      ward: ward ?? this.ward,
      communityId: communityId ?? this.communityId,
      projectId: projectId ?? this.projectId,
      householdSize: householdSize ?? this.householdSize,
      vulnerabilityCategory:
          vulnerabilityCategory ?? this.vulnerabilityCategory,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gpsTimestamp: gpsTimestamp ?? this.gpsTimestamp,
      fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
      photoPath: photoPath ?? this.photoPath,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (firstName.present)
      map['first_name'] = Variable<String>(firstName.value);
    if (lastName.present) map['last_name'] = Variable<String>(lastName.value);
    if (gender.present) map['gender'] = Variable<String>(gender.value);
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<int>(dateOfBirth.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (lga.present) map['lga'] = Variable<String>(lga.value);
    if (ward.present) map['ward'] = Variable<String>(ward.value);
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (householdSize.present) {
      map['household_size'] = Variable<int>(householdSize.value);
    }
    if (vulnerabilityCategory.present) {
      map['vulnerability_category'] = Variable<String>(
        vulnerabilityCategory.value,
      );
    }
    if (latitude.present) map['latitude'] = Variable<double>(latitude.value);
    if (longitude.present) map['longitude'] = Variable<double>(longitude.value);
    if (gpsTimestamp.present) {
      map['gps_timestamp'] = Variable<int>(gpsTimestamp.value);
    }
    if (fieldOfficerId.present) {
      map['field_officer_id'] = Variable<String>(fieldOfficerId.value);
    }
    if (photoPath.present)
      map['photo_path'] = Variable<String>(photoPath.value);
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) map['created_at'] = Variable<int>(createdAt.value);
    if (updatedAt.present) map['updated_at'] = Variable<int>(updatedAt.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiariesCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('lga: $lga, ')
          ..write('ward: $ward, ')
          ..write('communityId: $communityId, ')
          ..write('projectId: $projectId, ')
          ..write('householdSize: $householdSize, ')
          ..write('vulnerabilityCategory: $vulnerabilityCategory, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('gpsTimestamp: $gpsTimestamp, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('photoPath: $photoPath, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

// region FieldActivities

class FieldActivity extends DataClass implements Insertable<FieldActivity> {
  final String id;
  final String projectId;
  final String communityId;
  final String activityType;
  final int date;
  final int maleCount;
  final int femaleCount;
  final int childrenCount;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String fieldOfficerId;
  final String syncStatus;
  final int createdAt;
  final int updatedAt;

  const FieldActivity({
    required this.id,
    required this.projectId,
    required this.communityId,
    required this.activityType,
    required this.date,
    required this.maleCount,
    required this.femaleCount,
    required this.childrenCount,
    this.description,
    this.latitude,
    this.longitude,
    required this.fieldOfficerId,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['community_id'] = Variable<String>(communityId);
    map['activity_type'] = Variable<String>(activityType);
    map['date'] = Variable<int>(date);
    map['male_count'] = Variable<int>(maleCount);
    map['female_count'] = Variable<int>(femaleCount);
    map['children_count'] = Variable<int>(childrenCount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['field_officer_id'] = Variable<String>(fieldOfficerId);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  FieldActivitiesCompanion toCompanion(bool nullToAbsent) {
    return FieldActivitiesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      communityId: Value(communityId),
      activityType: Value(activityType),
      date: Value(date),
      maleCount: Value(maleCount),
      femaleCount: Value(femaleCount),
      childrenCount: Value(childrenCount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      fieldOfficerId: Value(fieldOfficerId),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FieldActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldActivity(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['project_id']),
      communityId: serializer.fromJson<String>(json['community_id']),
      activityType: serializer.fromJson<String>(json['activity_type']),
      date: serializer.fromJson<int>(json['date']),
      maleCount: serializer.fromJson<int>(json['male_count']),
      femaleCount: serializer.fromJson<int>(json['female_count']),
      childrenCount: serializer.fromJson<int>(json['children_count']),
      description: serializer.fromJson<String?>(json['description']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      fieldOfficerId: serializer.fromJson<String>(json['field_officer_id']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'project_id': serializer.toJson<String>(projectId),
      'community_id': serializer.toJson<String>(communityId),
      'activity_type': serializer.toJson<String>(activityType),
      'date': serializer.toJson<int>(date),
      'male_count': serializer.toJson<int>(maleCount),
      'female_count': serializer.toJson<int>(femaleCount),
      'children_count': serializer.toJson<int>(childrenCount),
      'description': serializer.toJson<String?>(description),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'field_officer_id': serializer.toJson<String>(fieldOfficerId),
      'sync_status': serializer.toJson<String>(syncStatus),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
    };
  }

  FieldActivity copyWith({
    String? id,
    String? projectId,
    String? communityId,
    String? activityType,
    int? date,
    int? maleCount,
    int? femaleCount,
    int? childrenCount,
    Value<String?> description = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    String? fieldOfficerId,
    String? syncStatus,
    int? createdAt,
    int? updatedAt,
  }) => FieldActivity(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    communityId: communityId ?? this.communityId,
    activityType: activityType ?? this.activityType,
    date: date ?? this.date,
    maleCount: maleCount ?? this.maleCount,
    femaleCount: femaleCount ?? this.femaleCount,
    childrenCount: childrenCount ?? this.childrenCount,
    description: description.present ? description.value : this.description,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  String toString() {
    return (StringBuffer('FieldActivity(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('communityId: $communityId, ')
          ..write('activityType: $activityType, ')
          ..write('date: $date, ')
          ..write('maleCount: $maleCount, ')
          ..write('femaleCount: $femaleCount, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    projectId,
    communityId,
    activityType,
    date,
    maleCount,
    femaleCount,
    childrenCount,
    description,
    latitude,
    longitude,
    fieldOfficerId,
    syncStatus,
    createdAt,
    updatedAt,
  ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldActivity &&
          other.id == id &&
          other.projectId == projectId &&
          other.communityId == communityId &&
          other.activityType == activityType &&
          other.date == date &&
          other.maleCount == maleCount &&
          other.femaleCount == femaleCount &&
          other.childrenCount == childrenCount &&
          other.description == description &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.fieldOfficerId == fieldOfficerId &&
          other.syncStatus == syncStatus &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt);
}

class FieldActivitiesCompanion extends UpdateCompanion<FieldActivity> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> communityId;
  final Value<String> activityType;
  final Value<int> date;
  final Value<int> maleCount;
  final Value<int> femaleCount;
  final Value<int> childrenCount;
  final Value<String?> description;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> fieldOfficerId;
  final Value<String> syncStatus;
  final Value<int> createdAt;
  final Value<int> updatedAt;

  const FieldActivitiesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.communityId = const Value.absent(),
    this.activityType = const Value.absent(),
    this.date = const Value.absent(),
    this.maleCount = const Value.absent(),
    this.femaleCount = const Value.absent(),
    this.childrenCount = const Value.absent(),
    this.description = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.fieldOfficerId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  FieldActivitiesCompanion.insert({
    required String id,
    required String projectId,
    required String communityId,
    required String activityType,
    required int date,
    required int maleCount,
    required int femaleCount,
    required int childrenCount,
    this.description = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String fieldOfficerId,
    this.syncStatus = const Value(r'pending'),
    required int createdAt,
    required int updatedAt,
  }) : id = Value(id),
       projectId = Value(projectId),
       communityId = Value(communityId),
       activityType = Value(activityType),
       date = Value(date),
       maleCount = Value(maleCount),
       femaleCount = Value(femaleCount),
       childrenCount = Value(childrenCount),
       fieldOfficerId = Value(fieldOfficerId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);

  static Insertable<FieldActivity> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? communityId,
    Expression<String>? activityType,
    Expression<int>? date,
    Expression<int>? maleCount,
    Expression<int>? femaleCount,
    Expression<int>? childrenCount,
    Expression<String>? description,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? fieldOfficerId,
    Expression<String>? syncStatus,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (communityId != null) 'community_id': communityId,
      if (activityType != null) 'activity_type': activityType,
      if (date != null) 'date': date,
      if (maleCount != null) 'male_count': maleCount,
      if (femaleCount != null) 'female_count': femaleCount,
      if (childrenCount != null) 'children_count': childrenCount,
      if (description != null) 'description': description,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (fieldOfficerId != null) 'field_officer_id': fieldOfficerId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FieldActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? communityId,
    Value<String>? activityType,
    Value<int>? date,
    Value<int>? maleCount,
    Value<int>? femaleCount,
    Value<int>? childrenCount,
    Value<String?>? description,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String>? fieldOfficerId,
    Value<String>? syncStatus,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return FieldActivitiesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      communityId: communityId ?? this.communityId,
      activityType: activityType ?? this.activityType,
      date: date ?? this.date,
      maleCount: maleCount ?? this.maleCount,
      femaleCount: femaleCount ?? this.femaleCount,
      childrenCount: childrenCount ?? this.childrenCount,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fieldOfficerId: fieldOfficerId ?? this.fieldOfficerId,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (projectId.present)
      map['project_id'] = Variable<String>(projectId.value);
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (date.present) map['date'] = Variable<int>(date.value);
    if (maleCount.present) map['male_count'] = Variable<int>(maleCount.value);
    if (femaleCount.present) {
      map['female_count'] = Variable<int>(femaleCount.value);
    }
    if (childrenCount.present) {
      map['children_count'] = Variable<int>(childrenCount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (latitude.present) map['latitude'] = Variable<double>(latitude.value);
    if (longitude.present) map['longitude'] = Variable<double>(longitude.value);
    if (fieldOfficerId.present) {
      map['field_officer_id'] = Variable<String>(fieldOfficerId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) map['created_at'] = Variable<int>(createdAt.value);
    if (updatedAt.present) map['updated_at'] = Variable<int>(updatedAt.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('communityId: $communityId, ')
          ..write('activityType: $activityType, ')
          ..write('date: $date, ')
          ..write('maleCount: $maleCount, ')
          ..write('femaleCount: $femaleCount, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('fieldOfficerId: $fieldOfficerId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

// region ActivityPhotos

class ActivityPhoto extends DataClass implements Insertable<ActivityPhoto> {
  final String id;
  final String activityId;
  final String filePath;
  final String syncStatus;

  const ActivityPhoto({
    required this.id,
    required this.activityId,
    required this.filePath,
    required this.syncStatus,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['file_path'] = Variable<String>(filePath);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ActivityPhotosCompanion toCompanion(bool nullToAbsent) {
    return ActivityPhotosCompanion(
      id: Value(id),
      activityId: Value(activityId),
      filePath: Value(filePath),
      syncStatus: Value(syncStatus),
    );
  }

  factory ActivityPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityPhoto(
      id: serializer.fromJson<String>(json['id']),
      activityId: serializer.fromJson<String>(json['activity_id']),
      filePath: serializer.fromJson<String>(json['file_path']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activity_id': serializer.toJson<String>(activityId),
      'file_path': serializer.toJson<String>(filePath),
      'sync_status': serializer.toJson<String>(syncStatus),
    };
  }

  ActivityPhoto copyWith({
    String? id,
    String? activityId,
    String? filePath,
    String? syncStatus,
  }) => ActivityPhoto(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    filePath: filePath ?? this.filePath,
    syncStatus: syncStatus ?? this.syncStatus,
  );

  @override
  String toString() {
    return (StringBuffer('ActivityPhoto(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('filePath: $filePath, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, activityId, filePath, syncStatus);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityPhoto &&
          other.id == id &&
          other.activityId == activityId &&
          other.filePath == filePath &&
          other.syncStatus == syncStatus);
}

class ActivityPhotosCompanion extends UpdateCompanion<ActivityPhoto> {
  final Value<String> id;
  final Value<String> activityId;
  final Value<String> filePath;
  final Value<String> syncStatus;

  const ActivityPhotosCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.syncStatus = const Value.absent(),
  });

  ActivityPhotosCompanion.insert({
    required String id,
    required String activityId,
    required String filePath,
    this.syncStatus = const Value(r'pending'),
  }) : id = Value(id),
       activityId = Value(activityId),
       filePath = Value(filePath);

  static Insertable<ActivityPhoto> custom({
    Expression<String>? id,
    Expression<String>? activityId,
    Expression<String>? filePath,
    Expression<String>? syncStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (filePath != null) 'file_path': filePath,
      if (syncStatus != null) 'sync_status': syncStatus,
    });
  }

  ActivityPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? activityId,
    Value<String>? filePath,
    Value<String>? syncStatus,
  }) {
    return ActivityPhotosCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      filePath: filePath ?? this.filePath,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<String>(id.value);
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (filePath.present) map['file_path'] = Variable<String>(filePath.value);
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPhotosCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('filePath: $filePath, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }
}

// region Table accessors

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _sessionTokenMeta = const VerificationMeta(
    'sessionToken',
  );
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
    'session_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );

  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    fullName,
    role,
    sessionToken,
    syncedAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'users';

  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('session_token')) {
      context.handle(
        _sessionTokenMeta,
        sessionToken.isAcceptableOrUnknown(
          data['session_token']!,
          _sessionTokenMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      sessionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_token'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) => $UsersTable(attachedDatabase, alias);
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _fieldOfficerIdMeta = const VerificationMeta(
    'fieldOfficerId',
  );
  @override
  late final GeneratedColumn<String> fieldOfficerId = GeneratedColumn<String>(
    'field_officer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _communityCountMeta = const VerificationMeta(
    'communityCount',
  );
  @override
  late final GeneratedColumn<int> communityCount = GeneratedColumn<int>(
    'community_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    fieldOfficerId,
    communityCount,
    syncedAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'projects';

  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('field_officer_id')) {
      context.handle(
        _fieldOfficerIdMeta,
        fieldOfficerId.isAcceptableOrUnknown(
          data['field_officer_id']!,
          _fieldOfficerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldOfficerIdMeta);
    }
    if (data.containsKey('community_count')) {
      context.handle(
        _communityCountMeta,
        communityCount.isAcceptableOrUnknown(
          data['community_count']!,
          _communityCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_communityCountMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      fieldOfficerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_officer_id'],
      )!,
      communityCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}community_count'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) =>
      $ProjectsTable(attachedDatabase, alias);
}

class $CommunitiesTable extends Communities
    with TableInfo<$CommunitiesTable, Community> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunitiesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _wardMeta = const VerificationMeta('ward');
  @override
  late final GeneratedColumn<String> ward = GeneratedColumn<String>(
    'ward',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _lgaMeta = const VerificationMeta('lga');
  @override
  late final GeneratedColumn<String> lga = GeneratedColumn<String>(
    'lga',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    ward,
    lga,
    projectId,
    syncedAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'communities';

  @override
  VerificationContext validateIntegrity(
    Insertable<Community> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ward')) {
      context.handle(
        _wardMeta,
        ward.isAcceptableOrUnknown(data['ward']!, _wardMeta),
      );
    } else if (isInserting) {
      context.missing(_wardMeta);
    }
    if (data.containsKey('lga')) {
      context.handle(
        _lgaMeta,
        lga.isAcceptableOrUnknown(data['lga']!, _lgaMeta),
      );
    } else if (isInserting) {
      context.missing(_lgaMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Community map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Community(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ward: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ward'],
      )!,
      lga: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lga'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $CommunitiesTable createAlias(String alias) =>
      $CommunitiesTable(attachedDatabase, alias);
}

class $BeneficiariesTable extends Beneficiaries
    with TableInfo<$BeneficiariesTable, Beneficiary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeneficiariesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<int> dateOfBirth = GeneratedColumn<int>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lgaMeta = const VerificationMeta('lga');
  @override
  late final GeneratedColumn<String> lga = GeneratedColumn<String>(
    'lga',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wardMeta = const VerificationMeta('ward');
  @override
  late final GeneratedColumn<String> ward = GeneratedColumn<String>(
    'ward',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _communityIdMeta = const VerificationMeta(
    'communityId',
  );
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
    'community_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdSizeMeta = const VerificationMeta(
    'householdSize',
  );
  @override
  late final GeneratedColumn<int> householdSize = GeneratedColumn<int>(
    'household_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vulnerabilityCategoryMeta =
      const VerificationMeta('vulnerabilityCategory');
  @override
  late final GeneratedColumn<String> vulnerabilityCategory =
      GeneratedColumn<String>(
        'vulnerability_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsTimestampMeta = const VerificationMeta(
    'gpsTimestamp',
  );
  @override
  late final GeneratedColumn<int> gpsTimestamp = GeneratedColumn<int>(
    'gps_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldOfficerIdMeta = const VerificationMeta(
    'fieldOfficerId',
  );
  @override
  late final GeneratedColumn<String> fieldOfficerId = GeneratedColumn<String>(
    'field_officer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    gender,
    dateOfBirth,
    phoneNumber,
    lga,
    ward,
    communityId,
    projectId,
    householdSize,
    vulnerabilityCategory,
    latitude,
    longitude,
    gpsTimestamp,
    fieldOfficerId,
    photoPath,
    syncStatus,
    createdAt,
    updatedAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'beneficiaries';

  @override
  VerificationContext validateIntegrity(
    Insertable<Beneficiary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('lga')) {
      context.handle(
        _lgaMeta,
        lga.isAcceptableOrUnknown(data['lga']!, _lgaMeta),
      );
    } else if (isInserting) {
      context.missing(_lgaMeta);
    }
    if (data.containsKey('ward')) {
      context.handle(
        _wardMeta,
        ward.isAcceptableOrUnknown(data['ward']!, _wardMeta),
      );
    } else if (isInserting) {
      context.missing(_wardMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
        _communityIdMeta,
        communityId.isAcceptableOrUnknown(
          data['community_id']!,
          _communityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_communityIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('household_size')) {
      context.handle(
        _householdSizeMeta,
        householdSize.isAcceptableOrUnknown(
          data['household_size']!,
          _householdSizeMeta,
        ),
      );
    }
    if (data.containsKey('vulnerability_category')) {
      context.handle(
        _vulnerabilityCategoryMeta,
        vulnerabilityCategory.isAcceptableOrUnknown(
          data['vulnerability_category']!,
          _vulnerabilityCategoryMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('gps_timestamp')) {
      context.handle(
        _gpsTimestampMeta,
        gpsTimestamp.isAcceptableOrUnknown(
          data['gps_timestamp']!,
          _gpsTimestampMeta,
        ),
      );
    }
    if (data.containsKey('field_officer_id')) {
      context.handle(
        _fieldOfficerIdMeta,
        fieldOfficerId.isAcceptableOrUnknown(
          data['field_officer_id']!,
          _fieldOfficerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldOfficerIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Beneficiary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beneficiary(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_of_birth'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      lga: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lga'],
      )!,
      ward: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ward'],
      )!,
      communityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}community_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      householdSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_size'],
      ),
      vulnerabilityCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vulnerability_category'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      gpsTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gps_timestamp'],
      ),
      fieldOfficerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_officer_id'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BeneficiariesTable createAlias(String alias) =>
      $BeneficiariesTable(attachedDatabase, alias);
}

class $FieldActivitiesTable extends FieldActivities
    with TableInfo<$FieldActivitiesTable, FieldActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldActivitiesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _communityIdMeta = const VerificationMeta(
    'communityId',
  );
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
    'community_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maleCountMeta = const VerificationMeta(
    'maleCount',
  );
  @override
  late final GeneratedColumn<int> maleCount = GeneratedColumn<int>(
    'male_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _femaleCountMeta = const VerificationMeta(
    'femaleCount',
  );
  @override
  late final GeneratedColumn<int> femaleCount = GeneratedColumn<int>(
    'female_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childrenCountMeta = const VerificationMeta(
    'childrenCount',
  );
  @override
  late final GeneratedColumn<int> childrenCount = GeneratedColumn<int>(
    'children_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldOfficerIdMeta = const VerificationMeta(
    'fieldOfficerId',
  );
  @override
  late final GeneratedColumn<String> fieldOfficerId = GeneratedColumn<String>(
    'field_officer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    communityId,
    activityType,
    date,
    maleCount,
    femaleCount,
    childrenCount,
    description,
    latitude,
    longitude,
    fieldOfficerId,
    syncStatus,
    createdAt,
    updatedAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'field_activities';

  @override
  VerificationContext validateIntegrity(
    Insertable<FieldActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
        _communityIdMeta,
        communityId.isAcceptableOrUnknown(
          data['community_id']!,
          _communityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_communityIdMeta);
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityTypeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('male_count')) {
      context.handle(
        _maleCountMeta,
        maleCount.isAcceptableOrUnknown(data['male_count']!, _maleCountMeta),
      );
    } else if (isInserting) {
      context.missing(_maleCountMeta);
    }
    if (data.containsKey('female_count')) {
      context.handle(
        _femaleCountMeta,
        femaleCount.isAcceptableOrUnknown(
          data['female_count']!,
          _femaleCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_femaleCountMeta);
    }
    if (data.containsKey('children_count')) {
      context.handle(
        _childrenCountMeta,
        childrenCount.isAcceptableOrUnknown(
          data['children_count']!,
          _childrenCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_childrenCountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('field_officer_id')) {
      context.handle(
        _fieldOfficerIdMeta,
        fieldOfficerId.isAcceptableOrUnknown(
          data['field_officer_id']!,
          _fieldOfficerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldOfficerIdMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  FieldActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      communityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}community_id'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      maleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}male_count'],
      )!,
      femaleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}female_count'],
      )!,
      childrenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}children_count'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      fieldOfficerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_officer_id'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FieldActivitiesTable createAlias(String alias) =>
      $FieldActivitiesTable(attachedDatabase, alias);
}

class $ActivityPhotosTable extends ActivityPhotos
    with TableInfo<$ActivityPhotosTable, ActivityPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityPhotosTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );

  @override
  List<GeneratedColumn> get $columns => [id, activityId, filePath, syncStatus];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'activity_photos';

  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  ActivityPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ActivityPhotosTable createAlias(String alias) =>
      $ActivityPhotosTable(attachedDatabase, alias);
}

// region _$AppDatabase

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(super.e);

  $UsersTable get users => attachedTables[0] as $UsersTable;
  $ProjectsTable get projects => attachedTables[1] as $ProjectsTable;
  $CommunitiesTable get communities => attachedTables[2] as $CommunitiesTable;
  $BeneficiariesTable get beneficiaries =>
      attachedTables[3] as $BeneficiariesTable;
  $FieldActivitiesTable get fieldActivities =>
      attachedTables[4] as $FieldActivitiesTable;
  $ActivityPhotosTable get activityPhotos =>
      attachedTables[5] as $ActivityPhotosTable;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    projects,
    communities,
    beneficiaries,
    fieldActivities,
    activityPhotos,
  ];

  late final List<TableInfo> attachedTables = [
    $UsersTable(this),
    $ProjectsTable(this),
    $CommunitiesTable(this),
    $BeneficiariesTable(this),
    $FieldActivitiesTable(this),
    $ActivityPhotosTable(this),
  ];
}
