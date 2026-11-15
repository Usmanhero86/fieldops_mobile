# Design Document — FieldOps Platform

## Overview

FieldOps is a Flutter mobile application built for humanitarian field officers. It follows a **Clean Architecture** pattern layered as Presentation → Domain → Data, with BLoC as the state management layer throughout. The device's Drift/SQLite database is the single source of truth; all reads and writes go through the local DB first, and a background Sync Engine pushes pending records to the REST backend whenever connectivity is restored.

---

## Architecture

### Layer Diagram

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                 │
│         (Screens, Widgets, BLoC/Cubit)              │
├─────────────────────────────────────────────────────┤
│                   Domain Layer                      │
│         (Entities, Use Cases, Repository Interfaces)│
├─────────────────────────────────────────────────────┤
│                    Data Layer                       │
│  (Repository Impls, Remote DataSources, Local DB)   │
├─────────────────────────────────────────────────────┤
│                    Core                             │
│  (DioClient, AppRouter, GetIt DI, Error, Utils)     │
└─────────────────────────────────────────────────────┘
```

### Feature Modules

Each feature lives under `lib/features/{feature}/` and owns its own data, domain, and presentation sub-directories.

| Feature | Purpose |
|---|---|
| `auth` | Login, logout, session persistence |
| `beneficiaries` | Registration, listing, duplicate detection |
| `activities` | Field activity logging |
| `projects` | Project listing and context selection |
| `communities` | Community listing, project-based filtering |
| `dashboard` | Summary counts, navigation shortcuts |
| `sync` | Background sync engine, pending screen |
| `profile` | Profile display, logout action |

Shared screens that do not belong to a single feature (splash, login shell) live under `lib/features/presentation/`.

### Dependency Injection

All dependencies are registered with **GetIt** in `lib/injection_container/injection_container.dart`, initialised before `runApp`. The registration order is:

1. `AppDatabase` (Drift singleton)
2. `DioClient` (singleton, interceptors attached after token store is ready)
3. `SecureTokenStore`
4. Remote data sources
5. Local data sources (DAO wrappers)
6. Repositories
7. Use cases
8. BLoCs / Cubits (factory registrations)

---

## Core Components

### DioClient

Located at `lib/core/network/dio_client.dart`. Extended from the existing stub:

```dart
class DioClient {
  DioClient({required SecureTokenStore tokenStore}) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ));
    dio.interceptors.addAll([
      AuthInterceptor(tokenStore),   // attaches Bearer token
      RetryInterceptor(),            // retries on 5xx / timeout
      ErrorInterceptor(),            // maps DioException → AppFailure
    ]);
  }

  late final Dio dio;
}
```

`AuthInterceptor` reads the current token from `SecureTokenStore` and injects `Authorization: Bearer <token>` on every outgoing request before the request is dispatched. If the token is absent, requests are sent without the header (unauthenticated routes such as `/auth/login`).

### SecureTokenStore

Wraps `flutter_secure_storage` (to be added as a dependency). Exposes:

```dart
abstract class SecureTokenStore {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();
}
```

### AppRouter

`lib/core/routes/app_router.dart` defines all named routes:

| Route | Screen |
|---|---|
| `/` | `SplashScreen` |
| `/login` | `LoginScreen` |
| `/dashboard` | `DashboardScreen` |
| `/projects` | `ProjectsScreen` |
| `/communities` | `CommunitiesScreen` |
| `/beneficiaries` | `BeneficiariesScreen` |
| `/beneficiaries/register` | `BeneficiaryRegistrationScreen` |
| `/activities` | `ActivitiesScreen` |
| `/activities/log` | `ActivityLogScreen` |
| `/pending-sync` | `PendingSyncScreen` |
| `/profile` | `ProfileScreen` |

Navigation state (scroll position, filter) is maintained by keeping BLoC state alive using `BlocProvider` mounted above the navigator root.

### Error Handling

`lib/core/error/` defines:

```dart
abstract class Failure extends Equatable {}

class NetworkFailure extends Failure { final String message; ... }
class ServerFailure extends Failure { final int statusCode; final String message; ... }
class LocalDbFailure extends Failure { final String message; ... }
class ValidationFailure extends Failure { final Map<String, String> fieldErrors; ... }
class PermissionFailure extends Failure { final String permissionName; ... }
```

Use cases return `Either<Failure, T>` (using the `dartz` pattern or a simple `Result<T, Failure>` sealed class). BLoCs map failures to typed error states that the UI renders as field-level or snackbar errors.

---

## Data Models

### Drift Database (`AppDatabase`)

Located at `lib/core/storage/app_database.dart`. Tables:

#### `users` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | UUID |
| `username` | TEXT | |
| `full_name` | TEXT | |
| `role` | TEXT | |
| `session_token` | TEXT | nullable |
| `synced_at` | INTEGER | epoch ms |

#### `projects` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | server-assigned UUID |
| `name` | TEXT | |
| `status` | TEXT | |
| `field_officer_id` | TEXT | FK users.id |
| `community_count` | INTEGER | denormalised |
| `synced_at` | INTEGER | epoch ms |

#### `communities` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | |
| `name` | TEXT | |
| `ward` | TEXT | |
| `lga` | TEXT | |
| `project_id` | TEXT | FK projects.id |
| `synced_at` | INTEGER | epoch ms |

#### `beneficiaries` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | UUID (locally generated) |
| `first_name` | TEXT | |
| `last_name` | TEXT | |
| `gender` | TEXT | |
| `date_of_birth` | INTEGER | epoch ms |
| `phone_number` | TEXT | nullable |
| `lga` | TEXT | |
| `ward` | TEXT | |
| `community_id` | TEXT | FK communities.id |
| `project_id` | TEXT | FK projects.id |
| `household_size` | INTEGER | nullable |
| `vulnerability_category` | TEXT | nullable |
| `latitude` | REAL | nullable |
| `longitude` | REAL | nullable |
| `gps_timestamp` | INTEGER | nullable, epoch ms |
| `field_officer_id` | TEXT | |
| `photo_path` | TEXT | nullable, device filesystem path |
| `sync_status` | TEXT | `pending` / `syncing` / `synced` / `failed` |
| `created_at` | INTEGER | epoch ms |
| `updated_at` | INTEGER | epoch ms |

#### `field_activities` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | UUID (locally generated) |
| `project_id` | TEXT | FK projects.id |
| `community_id` | TEXT | FK communities.id |
| `activity_type` | TEXT | |
| `date` | INTEGER | epoch ms |
| `male_count` | INTEGER | ≥ 0 |
| `female_count` | INTEGER | ≥ 0 |
| `children_count` | INTEGER | ≥ 0 |
| `description` | TEXT | nullable |
| `latitude` | REAL | nullable |
| `longitude` | REAL | nullable |
| `field_officer_id` | TEXT | |
| `sync_status` | TEXT | `pending` / `syncing` / `synced` / `failed` |
| `created_at` | INTEGER | epoch ms |
| `updated_at` | INTEGER | epoch ms |

#### `activity_photos` table

| Column | Type | Notes |
|---|---|---|
| `id` | TEXT PK | UUID |
| `activity_id` | TEXT | FK field_activities.id |
| `file_path` | TEXT | absolute device path |
| `sync_status` | TEXT | `pending` / `synced` / `failed` |

### Domain Entities

Domain entities are pure Dart objects with no framework dependencies, defined in each feature's `domain/entities/` directory:

```dart
// features/auth/domain/entities/auth_user.dart
class AuthUser extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String role;
  final String sessionToken;
  ...
}

// features/beneficiaries/domain/entities/beneficiary.dart
class Beneficiary extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String lga;
  final String ward;
  final String communityId;
  final String projectId;
  final int? householdSize;
  final String? vulnerabilityCategory;
  final double? latitude;
  final double? longitude;
  final DateTime? gpsTimestamp;
  final String fieldOfficerId;
  final String? photoPath;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  ...
}

// Shared enum
enum SyncStatus { pending, syncing, synced, failed }
```

---

## Feature Designs

### Authentication Feature

**Flow:**

```
SplashScreen
  → checks SecureTokenStore
    → token present → navigate /dashboard
    → no token      → navigate /login

LoginScreen
  → Field_Officer enters username + password
  → dispatches LoginSubmitted event to AuthBloc
  → AuthBloc calls LoginUseCase
    → LoginUseCase calls AuthRepository.login(username, password)
      → AuthRemoteDataSource: POST /auth/login
      → on success: AuthLocalDataSource.saveToken(token)
    → returns Either<Failure, AuthUser>
  → AuthBloc emits AuthLoading → AuthSuccess | AuthFailure
  → on AuthSuccess: navigate /dashboard
  → on AuthFailure: show error, preserve username field
```

**AuthBloc States:**

```dart
sealed class AuthState extends Equatable {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState { final AuthUser user; }
class AuthFailure extends AuthState { final String message; final String preservedUsername; }
class AuthUnauthenticated extends AuthState {}
```

**Logout:** `LogoutEvent` → `AuthRepository.logout()` → delete token → emit `AuthUnauthenticated` → navigate `/login`.

### Beneficiary Registration Feature

**Multi-step form** split across logical steps:

1. Personal details (first/last name, gender, DOB, phone)
2. Location (LGA, ward, community — cascaded dropdowns seeded from Local_DB)
3. Programme (project, household size, vulnerability category)
4. Field capture (GPS location, photo)

**BeneficiaryBloc** events and states:

```dart
// Events
class LoadFormMetadata extends BeneficiaryEvent {}  // loads projects/communities from DB
class CaptureGpsRequested extends BeneficiaryEvent {}
class CapturePhotoRequested extends BeneficiaryEvent { final PhotoSource source; }
class SubmitRegistrationForm extends BeneficiaryEvent { final BeneficiaryFormData form; }

// States
sealed class BeneficiaryState {}
class BeneficiaryInitial extends BeneficiaryState {}
class FormMetadataLoaded extends BeneficiaryState { final List<Project> projects; final List<Community> communities; }
class CapturingGps extends BeneficiaryState {}
class GpsCaptured extends BeneficiaryState { final double lat; final double lng; }
class SavingBeneficiary extends BeneficiaryState {}
class BeneficiarySaved extends BeneficiaryState { final Beneficiary beneficiary; }
class BeneficiaryValidationError extends BeneficiaryState { final Map<String, String> fieldErrors; }
class DuplicateDetected extends BeneficiaryState { final Beneficiary existingRecord; }
class BeneficiaryError extends BeneficiaryState { final String message; }
```

**Duplicate detection:** Before saving, `BeneficiaryLocalDataSource.findDuplicate(firstName, lastName, dob, projectId)` queries the DB. If a match is found, the BLoC emits `DuplicateDetected`; the UI shows a confirmation dialog. On explicit confirmation a `ConfirmDuplicateSave` event re-triggers the save.

**GPS capture:** Delegates to `LocationService` (wraps `geolocator`). If permission is denied, `PermissionFailure` is returned and the BLoC emits `BeneficiaryError` with a descriptive message and a deep-link to Settings.

### Field Activity Logging Feature

Mirrors the Beneficiary pattern. `ActivityBloc` handles form submission, GPS capture, and multi-photo attachment. Photos are each stored on the device filesystem via `PhotoStorageService` and their paths recorded in `activity_photos`.

**Participant count validation** is performed in the use case before any DB write:

```dart
class ValidateActivityForm {
  Either<ValidationFailure, void> call(ActivityFormData form) {
    final errors = <String, String>{};
    if (form.maleCount < 0) errors['maleCount'] = 'Must be 0 or greater';
    if (form.femaleCount < 0) errors['femaleCount'] = 'Must be 0 or greater';
    if (form.childrenCount < 0) errors['childrenCount'] = 'Must be 0 or greater';
    if (form.project == null) errors['project'] = 'Required';
    if (form.community == null) errors['community'] = 'Required';
    if (form.activityType.isEmpty) errors['activityType'] = 'Required';
    if (form.date == null) errors['date'] = 'Required';
    return errors.isEmpty ? Right(null) : Left(ValidationFailure(errors));
  }
}
```

### Sync Engine

Located at `lib/features/sync/`. This is the most complex component.

**SyncEngine** class (registered as a singleton with GetIt):

```dart
class SyncEngine {
  SyncEngine({
    required AppDatabase db,
    required DioClient dioClient,
    required ConnectivityService connectivity,
  });

  StreamSubscription<ConnectivityResult>? _subscription;

  void start() {
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _runSyncCycle();
      }
    });
  }

  Future<void> _runSyncCycle() async {
    final pending = await db.getPendingRecordsOldestFirst();
    for (final record in pending) {
      await _uploadRecord(record);
    }
  }

  Future<void> _uploadRecord(PendingRecord record) async {
    try {
      await db.updateSyncStatus(record.id, SyncStatus.syncing);
      final response = await _dispatchUpload(record);
      await db.updateSyncStatus(record.id, SyncStatus.synced);
    } on DioException catch (e) {
      if (_isNonRetryable(e)) {
        await db.updateSyncStatus(record.id, SyncStatus.failed);
      }
      // retryable: status stays pending; next cycle picks it up
    }
  }

  bool _isNonRetryable(DioException e) =>
      e.response?.statusCode == 400 || e.response?.statusCode == 422;
}
```

**Photo uploads** are dispatched as `FormData` multipart requests after the parent record is accepted by the backend. If a photo file is unreadable, the error is logged to the local log file and the individual photo sync status is set to `failed`; the parent record and remaining photos continue.

**SyncStatusCubit** exposes a stream of `SyncStatusState` (pendingCount, isSyncing) derived from a Drift watch query. The `SyncStatusBanner` widget listens to this cubit and rebuilds whenever the count changes.

### Dashboard

`DashboardCubit` issues four parallel watch queries against the Local_DB:

```dart
Stream<DashboardStats> watchStats() => Rx.combineLatest4(
  db.watchBeneficiaryCount(),
  db.watchActivityCount(),
  db.watchPendingCount(),
  db.watchProjectCount(),
  (b, a, p, pr) => DashboardStats(
    beneficiaryCount: b,
    activityCount: a,
    pendingCount: p,
    projectCount: pr,
  ),
);
```

The UI rebuilds reactively as any count changes. Navigation shortcuts are `InkWell` tiles that push `/beneficiaries/register` and `/activities/log`.

### Projects & Communities

`ProjectsCubit` and `CommunitiesCubit` each load from the Local_DB on mount. When a project is selected, `CommunitiesCubit.filterByProject(projectId)` issues a filtered query against `communities` where `project_id = ?`.

### Permissions

`PermissionService` wraps `permission_handler`. All permission requests go through this service, which:

1. Checks whether rationale should be shown (`shouldShowRequestRationale`).
2. If yes, shows a rationale dialog before calling `permission.request()`.
3. If `isPermanentlyDenied`, returns `PermissionFailure` and the UI shows the Settings deep-link dialog.

Only the permission required for the active operation is requested — GPS is requested on GPS capture, camera/gallery on photo capture.

---

## Connectivity Monitoring

`ConnectivityService` wraps `connectivity_plus`:

```dart
class ConnectivityService {
  Stream<ConnectivityResult> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.distinct();

  Future<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

An `OfflineBannerWidget` mounted in the root `Scaffold` listens to `ConnectivityCubit` and shows/hides a banner indicating offline status.

---

## Error Resilience

- All form state is held in BLoC state (not just widget local state), so a network timeout or DB error does not clear user-entered data.
- `FlutterError.onError` and `PlatformDispatcher.instance.onError` are overridden in `main.dart` to catch unhandled exceptions, write them to a local log file (via `LocalLogService`), and emit a `GlobalErrorCubit` event that shows a generic snackbar.
- Stack traces are never surfaced in the UI; only a generic "Something went wrong" message is shown.
- Drift uses WAL journal mode; all writes are transactional so a mid-write crash leaves the DB consistent.

---

## API Contract

Base URL: `http://10.0.2.2:3000/api`

| Endpoint | Method | Purpose |
|---|---|---|
| `/auth/login` | POST | Authenticate; returns `{ token, user }` |
| `/auth/logout` | POST | Server-side invalidation |
| `/projects` | GET | Returns projects assigned to the authenticated officer |
| `/communities` | GET | Returns communities (filterable by `?projectId=`) |
| `/beneficiaries` | POST | Creates a beneficiary; photo as multipart |
| `/activities` | POST | Creates an activity; photos as multipart |
| `/sync` | POST | Bulk sync endpoint (alternative to individual endpoints) |
| `/profile` | GET | Returns the authenticated officer's profile |

All requests except `/auth/login` require `Authorization: Bearer <token>`.

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Session Token Round-Trip

*For any* valid Session_Token returned by the Backend on successful login, storing the token via `SecureTokenStore.saveToken` and immediately reading it back via `SecureTokenStore.readToken` should return the identical token string.

**Validates: Requirements 1.1**

---

### Property 2: Bearer Token on Every Authenticated Request

*For any* outgoing HTTP request made through `DioClient` while a Session_Token is present in `SecureTokenStore`, the request's `Authorization` header should equal `"Bearer <token>"`.

**Validates: Requirements 1.7**

---

### Property 3: Auto-Login on Valid Stored Token

*For any* valid Session_Token already persisted in `SecureTokenStore` at app launch, the `SplashScreen` should navigate to the Dashboard screen without presenting the login screen.

**Validates: Requirements 1.5**

---

### Property 4: Offline Round-Trip Data Access

*For any* list of entities (Projects, Communities, Beneficiaries, or FieldActivities) written to the Local_DB, querying the Local_DB for the same entity type should return a collection containing all those entities with equivalent field values, regardless of network availability.

**Validates: Requirements 3.1**

---

### Property 5: Offline Record Persisted as Pending

*For any* valid Beneficiary or FieldActivity record created while the device has no internet connectivity, the record should be present in the Local_DB with `sync_status = pending` immediately after the save operation completes.

**Validates: Requirements 3.3, 4.5, 6.3**

---

### Property 6: Mandatory Field Validation

*For any* Beneficiary or FieldActivity form submission that has at least one mandatory field empty or null, the validation layer should return a `ValidationFailure` containing an error entry for each empty mandatory field, and no record should be written to the Local_DB.

**Validates: Requirements 4.4, 6.2**

---

### Property 7: Registration Metadata Auto-Capture

*For any* valid Beneficiary registration form submission, the record persisted to the Local_DB should contain non-null values for `latitude`, `longitude`, `gps_timestamp`, `field_officer_id`, and `project_id`.

**Validates: Requirements 4.3**

---

### Property 8: Duplicate Beneficiary Detection

*For any* Beneficiary record already present in the Local_DB, attempting to save a second Beneficiary with the same `(first_name, last_name, date_of_birth, project_id)` tuple should cause the use case to return a `DuplicateDetected` result before any new record is written.

**Validates: Requirements 4.8**

---

### Property 9: Newly Saved Record Appears in List Immediately

*For any* Beneficiary or FieldActivity successfully saved to the Local_DB, a subsequent query of the corresponding list (without navigating away and back) should return a collection that contains that record.

**Validates: Requirements 4.6, 6.5**

---

### Property 10: Photo Path Persistence

*For any* photo captured or selected and associated with a Beneficiary or FieldActivity, the file path stored in the Local_DB should correspond to a file that exists and is readable on the device filesystem at the time of storage.

**Validates: Requirements 5.2**

---

### Property 11: Multiple Photos Per Activity

*For any* FieldActivity that has N photos attached (N ≥ 1), querying `activity_photos` for that activity's id should return exactly N photo records.

**Validates: Requirements 5.3**

---

### Property 12: Photo Sync Failure Does Not Block Record Sync

*For any* photo record whose file path is unreadable at sync time, the Sync Engine should mark that photo's `sync_status` as `failed`, log the error, and continue processing all remaining pending records without aborting the sync cycle.

**Validates: Requirements 5.7**

---

### Property 13: Non-Negative Participant Counts Enforced

*For any* FieldActivity form where any of `male_count`, `female_count`, or `children_count` is a negative integer, the validation layer should return a `ValidationFailure` for that field and prevent the record from being saved.

**Validates: Requirements 6.6**

---

### Property 14: Community Filter by Project

*For any* selected `projectId` and the Communities list returned for that selection, every Community in the list should have its `project_id` equal to the selected `projectId`, and no Community with a different `project_id` should appear.

**Validates: Requirements 7.3**

---

### Property 15: Project List Tile Render Completeness

*For any* Project entity retrieved from the Local_DB, the widget rendered for its list tile should include the project's name, status, and community count.

**Validates: Requirements 7.5**

---

### Property 16: Community List Tile Render Completeness

*For any* Community entity retrieved from the Local_DB, the widget rendered for its list tile should include the community's name, ward, and LGA.

**Validates: Requirements 7.6**

---

### Property 17: Dashboard Counts Reflect Local_DB State

*For any* known DB state with B beneficiaries, A activities, P pending records, and PR projects, the `DashboardStats` emitted by `DashboardCubit` should satisfy `stats.beneficiaryCount == B`, `stats.activityCount == A`, `stats.pendingCount == P`, and `stats.projectCount == PR`.

**Validates: Requirements 8.1, 8.3**

---

### Property 18: Sync Ordering — Oldest First

*For any* set of pending records with distinct `created_at` timestamps, the Sync Engine should dispatch upload requests in ascending `created_at` order, such that no record with a later timestamp is uploaded before a record with an earlier timestamp.

**Validates: Requirements 9.2**

---

### Property 19: Successful Upload Marks Record as Synced

*For any* pending record that receives a 2xx HTTP response from the Backend upload endpoint, the Sync Engine should update that record's `sync_status` to `synced` in the Local_DB.

**Validates: Requirements 9.3**

---

### Property 20: Non-Retryable Error Marks Record as Failed

*For any* pending record that receives an HTTP 400 or HTTP 422 response from the Backend, the Sync Engine should update that record's `sync_status` to `failed` in the Local_DB and continue processing the next pending record without halting the sync cycle.

**Validates: Requirements 9.4**

---

### Property 21: Retryable Error Preserves Pending Status

*For any* pending record that receives an HTTP 5xx response or a network timeout from the Backend, the Sync Engine should leave that record's `sync_status` as `pending` in the Local_DB so it is retried in the next sync cycle.

**Validates: Requirements 9.5**

---

### Property 22: Sync Status Banner Reflects Pending Count

*For any* sync state where N records have `sync_status = pending` or `syncing`, the `SyncStatusBanner` widget should render displaying the value N.

**Validates: Requirements 9.7**

---

### Property 23: Pending Screen Display Completeness

*For any* set of pending records of mixed types present in the Local_DB, the Pending Sync screen should display every record grouped by type (Beneficiary, FieldActivity), and each rendered tile should include the record's type label, display name/identifier, creation timestamp, and current sync status.

**Validates: Requirements 10.1, 10.2, 10.3**

---

### Property 24: Failed Record Shows Retry Action

*For any* record with `sync_status = failed`, its rendered tile on the Pending Sync screen should include a visible retry action control (button or icon).

**Validates: Requirements 10.4**

---

### Property 25: Profile Screen Render Completeness

*For any* `UserProfile` entity loaded from the Local_DB, the Profile screen should render the officer's full name, username, assigned role, and list of assigned projects.

**Validates: Requirements 11.1**

---

### Property 26: Form Data Preserved on Error

*For any* non-empty form state held in a BLoC, when a `NetworkFailure` (timeout) or `LocalDbFailure` occurs during form submission, the BLoC state should retain all previously entered field values unchanged after the failure is emitted.

**Validates: Requirements 13.1, 13.2**

---

### Property 27: Unhandled Exception Does Not Expose Stack Trace

*For any* unhandled exception caught by the global error handler, the error message displayed to the Field_Officer should not contain any stack trace information (i.e., the displayed string should not match the pattern of Dart stack trace lines such as `#0`, `package:`, or `dart:`).

**Validates: Requirements 13.3**

---

### Property 28: Local_DB Integrity After Restart

*For any* set of records successfully committed to the Local_DB before an application restart, all those records should be queryable and return equivalent data after the application restarts and the DB connection is re-established.

**Validates: Requirements 13.4**
