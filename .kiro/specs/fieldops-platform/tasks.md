# Implementation Plan: FieldOps Platform

## Overview

Implement the FieldOps Flutter mobile application following Clean Architecture (Presentation → Domain → Data) with BLoC state management, Drift/SQLite as the local source of truth, and a background Sync Engine. Tasks proceed layer-by-layer — core infrastructure first, then feature-by-feature from the inside out (domain → data → presentation), finishing with the sync engine and global wiring.

The workspace already contains: `DioClient` stub, `AppRouter` stub (splash + login routes only), `ApiConstants`, `AppTheme`, stub screen files (`LoginScreen`, `SplashScreen`), and empty feature directory skeletons. All tasks below build on top of that foundation.

---

## Tasks

- [ ] 1. Core infrastructure — error types, token store, and DioClient hardening
  - [x] 1.1 Create `lib/core/error/failures.dart` with `Failure`, `NetworkFailure`, `ServerFailure`, `LocalDbFailure`, `ValidationFailure`, `PermissionFailure` sealed classes extending `Equatable`
    - Export a `Result<T>` typedef as `Either<Failure, T>` using a simple sealed class pattern (no extra packages)
    - _Requirements: 13.1, 13.2_

  - [x] 1.2 Add `flutter_secure_storage: ^9.2.4` to `pubspec.yaml` and implement `SecureTokenStore` at `lib/core/storage/secure_token_store.dart`
    - Abstract class with `saveToken`, `readToken`, `deleteToken`
    - Concrete `SecureTokenStoreImpl` backed by `FlutterSecureStorage`
    - _Requirements: 1.1, 1.5_

  - [ ] 1.3 Harden `DioClient` at `lib/core/network/dio_client.dart`
    - Accept `SecureTokenStore` as a constructor parameter
    - Extend timeouts to 30 seconds (connect / receive / send) per design spec
    - Add `AuthInterceptor` (reads token → injects `Authorization: Bearer <token>`)
    - Add `ErrorInterceptor` (maps `DioException` → `AppFailure` / rethrows as `ServerFailure`)
    - _Requirements: 1.7, 13.1_

  - [ ] 1.4 Write unit tests for `AuthInterceptor` and `ErrorInterceptor`
    - Verify Bearer token is injected when token is present
    - Verify request is sent without Authorization header when token is absent
    - Verify `DioException` with 4xx maps to `ServerFailure`
    - _Requirements: 1.7_

- [ ] 2. Core infrastructure — Drift database schema
  - [ ] 2.1 Create `lib/core/storage/app_database.dart` with all five Drift tables: `users`, `projects`, `communities`, `beneficiaries`, `field_activities`, and `activity_photos`
    - Define columns exactly as per the design document data model section
    - Enable WAL journal mode in `DatabaseConnection` opener
    - Generate Drift files: run `dart run build_runner build`
    - _Requirements: 3.1, 3.4, 4.1, 6.1_

  - [ ] 2.2 Write property test for offline round-trip data access (Property 4)
    - **Property 4: Offline Round-Trip Data Access**
    - For any list of entities written to the Local_DB, querying the same type returns all entities with equivalent field values
    - **Validates: Requirements 3.1**

  - [ ] 2.3 Write property test for Local_DB integrity after restart (Property 28)
    - **Property 28: Local_DB Integrity After Restart**
    - For any records successfully committed before DB connection close, all records are queryable after re-opening the DB connection
    - **Validates: Requirements 13.4**

- [ ] 3. Core infrastructure — AppRouter, DI container, and global error handler
  - [ ] 3.1 Expand `lib/core/routes/app_router.dart` with all named routes from the design
    - Add routes: `/dashboard`, `/projects`, `/communities`, `/beneficiaries`, `/beneficiaries/register`, `/activities`, `/activities/log`, `/pending-sync`, `/profile`
    - All new routes point to placeholder `Scaffold` widgets until feature screens are built
    - _Requirements: 2.1_

  - [ ] 3.2 Create `lib/injection_container/injection_container.dart`
    - Register all dependencies with GetIt in the order specified in the design: `AppDatabase` → `DioClient` → `SecureTokenStore` → remote data sources → local data sources → repositories → use cases → BLoCs/Cubits
    - Initialise GetIt before `runApp` by calling `await setupInjection()` in `main.dart`
    - _Requirements: (architecture wiring)_

  - [ ] 3.3 Wire global error handler in `main.dart`
    - Override `FlutterError.onError` and `PlatformDispatcher.instance.onError`
    - Create `lib/core/utils/local_log_service.dart` that writes exceptions to a local log file via `path_provider`
    - Ensure stack traces are never surfaced to the UI (only generic messages)
    - _Requirements: 13.3, 13.4_

  - [ ] 3.4 Write property test for unhandled exception stack trace suppression (Property 27)
    - **Property 27: Unhandled Exception Does Not Expose Stack Trace**
    - For any unhandled exception caught by the global handler, the displayed message must not contain `#0`, `package:`, or `dart:` patterns
    - **Validates: Requirements 13.3**

- [ ] 4. Checkpoint — core infrastructure complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. Authentication feature — domain and data layers
  - [ ] 5.1 Create auth domain layer: `AuthUser` entity, `AuthRepository` interface, `LoginUseCase`, `LogoutUseCase`, `CheckAuthStatusUseCase`
    - Files under `lib/features/auth/domain/`
    - Use cases return `Result<AuthUser>` / `Result<void>`
    - _Requirements: 1.1, 1.5, 1.6_

  - [ ] 5.2 Create auth data layer: `AuthRemoteDataSource` (POST `/auth/login`, POST `/auth/logout`), `AuthLocalDataSource` (token read/write via `SecureTokenStore`), `AuthRepositoryImpl`
    - Files under `lib/features/auth/data/`
    - `AuthRepositoryImpl` orchestrates remote call → local token save
    - _Requirements: 1.1, 1.6_

  - [ ] 5.3 Write property test for session token round-trip (Property 1)
    - **Property 1: Session Token Round-Trip**
    - For any valid token string, `saveToken` followed immediately by `readToken` returns the identical string
    - **Validates: Requirements 1.1**

  - [ ] 5.4 Write property test for Bearer token on every authenticated request (Property 2)
    - **Property 2: Bearer Token on Every Authenticated Request**
    - For any outgoing request through `DioClient` while a token is present, the `Authorization` header equals `"Bearer <token>"`
    - **Validates: Requirements 1.7**

- [ ] 6. Authentication feature — BLoC and screens
  - [ ] 6.1 Create `AuthBloc` at `lib/features/auth/presentation/bloc/auth_bloc.dart`
    - Events: `LoginSubmitted`, `LogoutRequested`, `AppStarted`
    - States: `AuthInitial`, `AuthLoading`, `AuthSuccess`, `AuthFailure` (preserves username), `AuthUnauthenticated`
    - _Requirements: 1.2, 1.3, 1.4, 1.5, 1.6_

  - [ ] 6.2 Implement `LoginScreen` at `lib/features/presentation/screens/login_screen.dart`
    - Wire existing stub to `AuthBloc` via `BlocProvider` / `BlocConsumer`
    - Add username field (pre-populated on `AuthFailure`), password field, loading state on submit button, error message display
    - _Requirements: 1.2, 1.3, 1.4_

  - [ ] 6.3 Implement `SplashScreen` at `lib/features/presentation/screens/splash_screen.dart`
    - Replace timer-based navigation with `AuthBloc` `AppStarted` event dispatch
    - Navigate to `/dashboard` if token valid, `/login` otherwise
    - _Requirements: 1.5_

  - [ ] 6.4 Write property test for auto-login on valid stored token (Property 3)
    - **Property 3: Auto-Login on Valid Stored Token**
    - For any valid token persisted in `SecureTokenStore` at app launch, `SplashScreen` navigates to Dashboard without showing the login screen
    - **Validates: Requirements 1.5**

- [ ] 7. Checkpoint — auth complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 8. Projects and Communities feature
  - [ ] 8.1 Create domain layer for projects and communities
    - `Project` entity, `Community` entity under `lib/features/projects/domain/entities/` and `lib/features/communities/domain/entities/`
    - Repository interfaces: `ProjectRepository`, `CommunityRepository`
    - Use cases: `GetProjectsUseCase`, `GetCommunitiesUseCase`, `GetCommunitiesByProjectUseCase`
    - _Requirements: 7.1, 7.2, 7.3_

  - [ ] 8.2 Create data layer for projects and communities
    - `ProjectRemoteDataSource` (GET `/projects`), `CommunityRemoteDataSource` (GET `/communities?projectId=`)
    - `ProjectLocalDataSource` and `CommunityLocalDataSource` (Drift DAO wrappers)
    - `ProjectRepositoryImpl` and `CommunityRepositoryImpl`
    - _Requirements: 7.1, 7.2, 7.4_

  - [ ] 8.3 Create `ProjectsCubit` and `CommunitiesCubit`
    - `ProjectsCubit`: loads from Local_DB; refreshes from remote on sync
    - `CommunitiesCubit`: `filterByProject(projectId)` issues filtered Drift query
    - _Requirements: 7.1, 7.2, 7.3_

  - [ ] 8.4 Build `ProjectsScreen` and `CommunitiesScreen`
    - `ProjectsScreen`: list tiles showing name, status, community count
    - `CommunitiesScreen`: list tiles showing name, ward, LGA; filtered to selected project
    - Wire to AppRouter at `/projects` and `/communities`
    - _Requirements: 7.5, 7.6_

  - [ ] 8.5 Write property test for community filter by project (Property 14)
    - **Property 14: Community Filter by Project**
    - For any selected `projectId`, every Community returned by `GetCommunitiesByProjectUseCase` has `project_id == selectedProjectId`
    - **Validates: Requirements 7.3**

  - [ ] 8.6 Write property test for Project list tile render completeness (Property 15)
    - **Property 15: Project List Tile Render Completeness**
    - For any `Project` entity, the rendered tile includes name, status, and community count
    - **Validates: Requirements 7.5**

  - [ ] 8.7 Write property test for Community list tile render completeness (Property 16)
    - **Property 16: Community List Tile Render Completeness**
    - For any `Community` entity, the rendered tile includes name, ward, and LGA
    - **Validates: Requirements 7.6**

- [ ] 9. Dashboard feature
  - [ ] 9.1 Create `DashboardCubit` at `lib/features/dashboard/presentation/cubit/dashboard_cubit.dart`
    - Add four Drift watch queries to `AppDatabase`: `watchBeneficiaryCount`, `watchActivityCount`, `watchPendingCount`, `watchProjectCount`
    - `DashboardCubit.watchStats()` combines all four streams via `Rx.combineLatest4` (add `rxdart: ^0.28.0` to pubspec)
    - Emits `DashboardStats` whenever any count changes
    - _Requirements: 8.1, 8.2, 8.3_

  - [ ] 9.2 Build `DashboardScreen` at `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
    - Display beneficiary count, activity count, pending record count, project count from `DashboardCubit`
    - Navigation shortcuts (`InkWell` tiles) to `/beneficiaries/register` and `/activities/log`
    - Wire to AppRouter at `/dashboard`; mount `SyncStatusBanner` and `OfflineBannerWidget` in root `Scaffold`
    - _Requirements: 8.1, 8.2, 8.4_

  - [ ] 9.3 Write property test for Dashboard counts reflecting Local_DB state (Property 17)
    - **Property 17: Dashboard Counts Reflect Local_DB State**
    - For any known DB state (B beneficiaries, A activities, P pending, PR projects), `DashboardStats` satisfies all four count equalities
    - **Validates: Requirements 8.1, 8.3**

- [ ] 10. Connectivity and offline banner
  - [ ] 10.1 Create `ConnectivityService` at `lib/core/utils/connectivity_service.dart`
    - Wraps `connectivity_plus`; exposes `onConnectivityChanged` stream (`.distinct()`) and `isConnected` getter
    - _Requirements: 3.5, 9.1_

  - [ ] 10.2 Create `ConnectivityCubit` and `OfflineBannerWidget`
    - `ConnectivityCubit` listens to `ConnectivityService.onConnectivityChanged` and emits `ConnectedState` / `DisconnectedState`
    - `OfflineBannerWidget` renders a visible banner when `DisconnectedState` is emitted; hidden otherwise
    - Mount `OfflineBannerWidget` in the root `Scaffold` wrapping the navigator
    - _Requirements: 3.5_

- [ ] 11. Beneficiary registration feature — domain and data layers
  - [ ] 11.1 Create beneficiary domain layer
    - `Beneficiary` entity with `SyncStatus` enum at `lib/features/beneficiaries/domain/entities/`
    - `BeneficiaryRepository` interface
    - Use cases: `RegisterBeneficiaryUseCase`, `GetBeneficiariesUseCase`, `CheckDuplicateBeneficiaryUseCase`
    - Validation logic in `ValidateBeneficiaryForm` use case (checks mandatory fields per requirements 4.4)
    - _Requirements: 4.4, 4.5, 4.8_

  - [ ] 11.2 Create beneficiary data layer
    - `BeneficiaryLocalDataSource` with Drift DAO: `insertBeneficiary`, `watchBeneficiaries`, `findDuplicate(firstName, lastName, dob, projectId)`
    - `BeneficiaryRemoteDataSource`: POST `/beneficiaries` as multipart (record fields + photo file)
    - `BeneficiaryRepositoryImpl`
    - _Requirements: 4.5, 4.6, 4.8, 5.2, 5.4_

  - [ ] 11.3 Write property test for mandatory field validation (Property 6)
    - **Property 6: Mandatory Field Validation**
    - For any form submission with at least one mandatory field empty, `ValidateBeneficiaryForm` returns `ValidationFailure` containing an error for each empty mandatory field, and no DB write occurs
    - **Validates: Requirements 4.4, 6.2**

  - [ ] 11.4 Write property test for offline record persisted as pending (Property 5)
    - **Property 5: Offline Record Persisted as Pending**
    - For any valid record created while offline, it is present in the Local_DB with `sync_status = pending` immediately after the save completes
    - **Validates: Requirements 3.3, 4.5, 6.3**

  - [ ] 11.5 Write property test for duplicate beneficiary detection (Property 8)
    - **Property 8: Duplicate Beneficiary Detection**
    - For any beneficiary already in the DB, attempting to save a second record with the same `(first_name, last_name, date_of_birth, project_id)` causes the use case to return `DuplicateDetected` before any new record is written
    - **Validates: Requirements 4.8**

  - [ ] 11.6 Write property test for registration metadata auto-capture (Property 7)
    - **Property 7: Registration Metadata Auto-Capture**
    - For any valid submission, the persisted record contains non-null `latitude`, `longitude`, `gps_timestamp`, `field_officer_id`, and `project_id`
    - **Validates: Requirements 4.3**

- [ ] 12. Location and photo services
  - [ ] 12.1 Create `LocationService` at `lib/core/utils/location_service.dart`
    - Wraps `geolocator`; exposes `getCurrentPosition()` → `Result<GpsCoordinates>`
    - _Requirements: 4.2, 6.4_

  - [ ] 12.2 Create `PermissionService` at `lib/core/utils/permission_service.dart`
    - Wraps `permission_handler`; handles rationale display, `shouldShowRequestRationale`, and `isPermanentlyDenied` → returns `PermissionFailure` with Settings deep-link
    - Request only the permission needed for the active operation (location vs camera/gallery)
    - _Requirements: 4.7, 5.6, 12.1, 12.2, 12.3_

  - [ ] 12.3 Create `PhotoStorageService` at `lib/core/utils/photo_storage_service.dart`
    - Wraps `image_picker` (add `image_picker: ^1.1.2` to pubspec); saves captured/selected image to device filesystem via `path_provider`
    - Returns absolute file path; verifies the file exists and is readable before returning
    - _Requirements: 5.1, 5.2, 5.6_

  - [ ] 12.4 Write property test for photo path persistence (Property 10)
    - **Property 10: Photo Path Persistence**
    - For any photo captured/selected, the file path stored in the DB corresponds to a file that exists and is readable on the device filesystem at the time of storage
    - **Validates: Requirements 5.2**

- [ ] 13. Beneficiary registration feature — BLoC and screens
  - [ ] 13.1 Create `BeneficiaryBloc` at `lib/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart`
    - Events: `LoadFormMetadata`, `CaptureGpsRequested`, `CapturePhotoRequested`, `SubmitRegistrationForm`, `ConfirmDuplicateSave`
    - States: `BeneficiaryInitial`, `FormMetadataLoaded`, `CapturingGps`, `GpsCaptured`, `SavingBeneficiary`, `BeneficiarySaved`, `BeneficiaryValidationError`, `DuplicateDetected`, `BeneficiaryError`
    - All form state held in BLoC state — never in widget local state (preserves data on errors)
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 13.1, 13.2_

  - [ ] 13.2 Build `BeneficiariesScreen` (list) and `BeneficiaryRegistrationScreen` (multi-step form)
    - `BeneficiariesScreen`: watch query stream from `BeneficiaryBloc`; shows list tiles with name and sync status badge
    - `BeneficiaryRegistrationScreen`: 4-step form (personal → location → programme → field capture); cascaded dropdowns for LGA/ward/community; GPS capture button; photo capture button; duplicate confirmation dialog
    - Wire to AppRouter at `/beneficiaries` and `/beneficiaries/register`
    - _Requirements: 4.1, 4.2, 4.6, 4.7, 4.9_

  - [ ] 13.3 Write property test for newly saved record appears in list (Property 9)
    - **Property 9: Newly Saved Record Appears in List Immediately**
    - For any Beneficiary successfully saved to the Local_DB, a subsequent list query returns a collection containing that record
    - **Validates: Requirements 4.6, 6.5**

  - [ ] 13.4 Write property test for form data preserved on error (Property 26)
    - **Property 26: Form Data Preserved on Error**
    - For any non-empty BLoC form state, when `NetworkFailure` or `LocalDbFailure` occurs during submission, all field values remain unchanged after the failure state is emitted
    - **Validates: Requirements 13.1, 13.2**

- [ ] 14. Checkpoint — beneficiary registration complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 15. Field Activity logging feature — domain, data, BLoC, and screens
  - [ ] 15.1 Create activity domain layer
    - `FieldActivity` entity, `ActivityRepository` interface
    - Use cases: `LogActivityUseCase`, `GetActivitiesUseCase`
    - `ValidateActivityForm` use case (mandatory fields + non-negative counts per design spec)
    - _Requirements: 6.1, 6.2, 6.3, 6.6_

  - [ ] 15.2 Create activity data layer
    - `ActivityLocalDataSource` with Drift DAO: `insertActivity`, `insertActivityPhoto`, `watchActivities`, `getPhotosForActivity`
    - `ActivityRemoteDataSource`: POST `/activities` as multipart (record fields + photo files)
    - `ActivityRepositoryImpl`
    - _Requirements: 6.3, 5.3, 5.5_

  - [ ] 15.3 Write property test for non-negative participant counts (Property 13)
    - **Property 13: Non-Negative Participant Counts Enforced**
    - For any form where any participant count is negative, `ValidateActivityForm` returns `ValidationFailure` for that field and no DB write occurs
    - **Validates: Requirements 6.6**

  - [ ] 15.4 Write property test for multiple photos per activity (Property 11)
    - **Property 11: Multiple Photos Per Activity**
    - For any FieldActivity with N photos attached (N ≥ 1), querying `activity_photos` for that activity's id returns exactly N photo records
    - **Validates: Requirements 5.3**

  - [ ] 15.5 Create `ActivityBloc` at `lib/features/actitivies/presentation/bloc/activity_bloc.dart`
    - Mirror `BeneficiaryBloc` pattern; add multi-photo attachment support (list of photo paths in state)
    - All form state held in BLoC state
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 13.1, 13.2_

  - [ ] 15.6 Build `ActivitiesScreen` (list) and `ActivityLogScreen` (form)
    - `ActivitiesScreen`: watch query stream; shows list tiles with activity type and sync status badge
    - `ActivityLogScreen`: form with project/community dropdowns, activity type, date picker, participant count fields (validated non-negative), GPS capture, multi-photo attachment; shows field-level validation errors
    - Wire to AppRouter at `/activities` and `/activities/log`
    - _Requirements: 6.1, 6.2, 6.4, 6.5_

- [ ] 16. Sync Engine
  - [ ] 16.1 Add Drift watch queries and pending record retrieval to `AppDatabase`
    - `getPendingRecordsOldestFirst()`: returns all records with `sync_status = pending` ordered by `created_at` ASC across both `beneficiaries` and `field_activities`
    - `updateSyncStatus(id, status)` for both tables
    - `watchPendingRecords()` stream for `SyncStatusCubit`
    - _Requirements: 9.2, 9.3, 9.4, 9.5_

  - [ ] 16.2 Implement `SyncEngine` at `lib/features/sync/sync_engine.dart`
    - `start()` subscribes to `ConnectivityService.onConnectivityChanged`; triggers `_runSyncCycle()` on any non-none connectivity
    - `_runSyncCycle()`: fetches pending records oldest-first, calls `_uploadRecord` for each
    - `_uploadRecord`: sets status to `syncing` → dispatches upload → sets `synced` on 2xx; sets `failed` on 400/422; leaves `pending` on 5xx/timeout
    - Photo uploads after parent record accepted; unreadable photo → log + mark photo `failed` + continue
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.9, 5.7_

  - [ ] 16.3 Create `SyncStatusCubit` and `SyncStatusBanner` widget
    - `SyncStatusCubit` watches `AppDatabase.watchPendingRecords()` stream; emits `SyncStatusState(pendingCount, isSyncing)`
    - `SyncStatusBanner` widget: renders pending count when N > 0; renders "All synced" when N == 0
    - Mount banner in root `Scaffold`
    - _Requirements: 9.7, 9.8_

  - [ ] 16.4 Write property test for sync ordering — oldest first (Property 18)
    - **Property 18: Sync Ordering — Oldest First**
    - For any set of pending records with distinct `created_at` timestamps, upload requests are dispatched in ascending `created_at` order
    - **Validates: Requirements 9.2**

  - [ ] 16.5 Write property test for successful upload marks record as synced (Property 19)
    - **Property 19: Successful Upload Marks Record as Synced**
    - For any pending record that receives a 2xx response, `sync_status` is updated to `synced` in the Local_DB
    - **Validates: Requirements 9.3**

  - [ ] 16.6 Write property test for non-retryable error marks record as failed (Property 20)
    - **Property 20: Non-Retryable Error Marks Record as Failed**
    - For any pending record receiving HTTP 400 or 422, `sync_status` is set to `failed` and the next record is processed
    - **Validates: Requirements 9.4**

  - [ ] 16.7 Write property test for retryable error preserves pending status (Property 21)
    - **Property 21: Retryable Error Preserves Pending Status**
    - For any pending record receiving HTTP 5xx or network timeout, `sync_status` remains `pending`
    - **Validates: Requirements 9.5**

  - [ ] 16.8 Write property test for photo sync failure does not block record sync (Property 12)
    - **Property 12: Photo Sync Failure Does Not Block Record Sync**
    - For any photo with an unreadable file path at sync time, `sync_status` is set to `failed` for that photo, the error is logged, and all remaining pending records continue processing
    - **Validates: Requirements 5.7**

  - [ ] 16.9 Write property test for sync status banner reflects pending count (Property 22)
    - **Property 22: Sync Status Banner Reflects Pending Count**
    - For any sync state where N records have `sync_status = pending` or `syncing`, the `SyncStatusBanner` renders displaying the value N
    - **Validates: Requirements 9.7**

- [ ] 17. Pending Sync screen
  - [ ] 17.1 Build `PendingSyncScreen` at `lib/features/sync/presentation/screens/pending_sync_screen.dart`
    - Watches `AppDatabase.watchPendingRecords()` via `SyncStatusCubit` or a dedicated `PendingSyncCubit`
    - Groups records by type (Beneficiary, FieldActivity)
    - Each tile: type label, display name/identifier, creation timestamp, current sync status badge
    - For `failed` records: show retry icon/button that dispatches manual retry to `SyncEngine`
    - Real-time updates (stream-based, no manual refresh)
    - Wire to AppRouter at `/pending-sync`
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

  - [ ] 17.2 Write property test for pending screen display completeness (Property 23)
    - **Property 23: Pending Screen Display Completeness**
    - For any set of mixed-type pending records, the screen displays every record grouped by type, each tile including type label, display name, creation timestamp, and sync status
    - **Validates: Requirements 10.1, 10.2, 10.3**

  - [ ] 17.3 Write property test for failed record shows retry action (Property 24)
    - **Property 24: Failed Record Shows Retry Action**
    - For any record with `sync_status = failed`, its tile includes a visible retry action control
    - **Validates: Requirements 10.4**

- [ ] 18. Checkpoint — sync engine and pending screen complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 19. Profile feature
  - [ ] 19.1 Create profile domain and data layers
    - `UserProfile` entity; `ProfileRepository` interface; `GetProfileUseCase`
    - `ProfileRemoteDataSource` (GET `/profile`); `ProfileLocalDataSource` (Drift `users` DAO); `ProfileRepositoryImpl`
    - `ProfileCubit` loads from Local_DB; refreshes from remote when connected
    - _Requirements: 11.1, 11.2_

  - [ ] 19.2 Build `ProfileScreen` at `lib/features/profile/presentation/screens/profile_screen.dart`
    - Display full name, username, role, and assigned projects list
    - Logout button dispatches `LogoutRequested` to `AuthBloc`; clears token; navigates to `/login`
    - Wire to AppRouter at `/profile`
    - _Requirements: 11.1, 11.2, 11.3_

  - [ ] 19.3 Write property test for profile screen render completeness (Property 25)
    - **Property 25: Profile Screen Render Completeness**
    - For any `UserProfile` entity loaded from the Local_DB, the Profile screen renders full name, username, role, and assigned projects list
    - **Validates: Requirements 11.1**

- [ ] 20. Navigation — full AppRouter wiring and navigation guard
  - [ ] 20.1 Replace all placeholder routes in `AppRouter` with real screen classes
    - Import and wire every feature screen built in tasks 8–19
    - _Requirements: 2.1_

  - [ ] 20.2 Add Project context navigation guard
    - If a route requires a selected Project and none is selected, redirect to `/projects` with a prompt
    - Implement via a `RouteGuard` wrapper or inline check in `generateRoute`
    - _Requirements: 2.4_

  - [ ] 20.3 Mount `BlocProvider` hierarchy above navigator root in `app.dart`
    - Wrap `MaterialApp` with `MultiBlocProvider` for: `AuthBloc`, `ConnectivityCubit`, `SyncStatusCubit`, `DashboardCubit`
    - This preserves BLoC state across navigations (navigation state requirement)
    - _Requirements: 2.3_

- [ ] 21. Final checkpoint — full integration
  - Ensure all tests pass, ask the user if questions arise.

---

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP delivery
- Each task references specific requirements for traceability
- The design document has 28 Correctness Properties — each is covered by a corresponding `*` sub-task
- All form state is managed in BLoC (never widget-local) to satisfy error-resilience requirements 13.1 and 13.2
- `build_runner` must be re-run after any Drift table change: `dart run build_runner build --delete-conflicting-outputs`
- The `actitivies` directory name in the existing scaffold contains a typo (double `i`) — new files for this feature should go under `lib/features/actitivies/` to match the existing directory until a rename is decided
- `flutter_secure_storage`, `rxdart`, and `image_picker` are not yet in `pubspec.yaml` and must be added as part of tasks 1.2, 9.1, and 12.3 respectively

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2"] },
    { "id": 1, "tasks": ["1.3", "2.1", "3.1"] },
    { "id": 2, "tasks": ["1.4", "2.2", "2.3", "3.2", "3.3"] },
    { "id": 3, "tasks": ["3.4", "5.1", "10.1"] },
    { "id": 4, "tasks": ["5.2", "10.2"] },
    { "id": 5, "tasks": ["5.3", "5.4", "8.1"] },
    { "id": 6, "tasks": ["6.1", "8.2"] },
    { "id": 7, "tasks": ["6.2", "6.3", "8.3", "9.1", "12.1", "12.2", "12.3"] },
    { "id": 8, "tasks": ["6.4", "8.4", "9.2", "9.3", "12.4"] },
    { "id": 9, "tasks": ["8.5", "8.6", "8.7", "11.1"] },
    { "id": 10, "tasks": ["11.2", "15.1"] },
    { "id": 11, "tasks": ["11.3", "11.4", "11.5", "11.6", "15.2"] },
    { "id": 12, "tasks": ["13.1", "15.3", "15.4"] },
    { "id": 13, "tasks": ["13.2", "15.5", "16.1"] },
    { "id": 14, "tasks": ["13.3", "13.4", "15.6", "16.2"] },
    { "id": 15, "tasks": ["16.3"] },
    { "id": 16, "tasks": ["16.4", "16.5", "16.6", "16.7", "16.8", "16.9", "17.1", "19.1"] },
    { "id": 17, "tasks": ["17.2", "17.3", "19.2"] },
    { "id": 18, "tasks": ["19.3", "20.1"] },
    { "id": 19, "tasks": ["20.2", "20.3"] }
  ]
}
```
