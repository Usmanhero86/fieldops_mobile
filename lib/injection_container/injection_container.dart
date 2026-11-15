import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';
import '../core/storage/app_database.dart';
import '../core/storage/secure_token_store.dart';
import '../features/actitivies/data/datasources/activity_local_dao.dart';
import '../features/beneficiaries/data/datasources/beneficiary_local_dao.dart';
import '../features/dashboard/data/dashboard_local_dao.dart';
import '../features/map/data/map_local_dao.dart';
import '../features/reports/data/reports_local_dao.dart';

/// Global service locator instance.
///
/// Throughout the app, dependencies are obtained via:
/// ```dart
/// final db = sl<AppDatabase>();
/// ```
final GetIt sl = GetIt.instance;

/// Registers all application dependencies with [GetIt].
///
/// Must be called (and awaited) before [runApp] in `main.dart`.
/// Registration order follows the dependency graph from the design doc:
///
///   AppDatabase
///   → DioClient
///   → SecureTokenStore
///   → Remote data sources  (added per-feature in later tasks)
///   → Local data sources   (added per-feature in later tasks)
///   → Repositories         (added per-feature in later tasks)
///   → Use cases            (added per-feature in later tasks)
///   → BLoCs / Cubits       (added per-feature in later tasks)
Future<void> setupInjection() async {
  // -------------------------------------------------------------------------
  // 1. AppDatabase — Drift/SQLite singleton
  // -------------------------------------------------------------------------
  sl.registerSingletonAsync<AppDatabase>(() async {
    final db = AppDatabase();
    return db;
  });

  // Wait for the database to be ready before registering dependants.
  await sl.allReady();

  // -------------------------------------------------------------------------
  // 2. SecureTokenStore — registered before DioClient (AuthInterceptor needs it)
  // -------------------------------------------------------------------------
  sl.registerLazySingleton<SecureTokenStore>(() => SecureTokenStoreImpl());

  // -------------------------------------------------------------------------
  // 3. DioClient — depends on SecureTokenStore
  // -------------------------------------------------------------------------
  sl.registerLazySingleton<DioClient>(
    () => DioClient(tokenStore: sl<SecureTokenStore>()),
  );

  // -------------------------------------------------------------------------
  // 4. Remote data sources
  // -------------------------------------------------------------------------
  // TODO(task-5.2):  sl.registerLazySingleton<AuthRemoteDataSource>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<ProjectRemoteDataSource>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<CommunityRemoteDataSource>(...)
  // TODO(task-11.2): sl.registerLazySingleton<BeneficiaryRemoteDataSource>(...)
  // TODO(task-15.2): sl.registerLazySingleton<ActivityRemoteDataSource>(...)
  // TODO(task-19.1): sl.registerLazySingleton<ProfileRemoteDataSource>(...)

  // -------------------------------------------------------------------------
  // 5. Local data sources (Drift DAO wrappers)
  // -------------------------------------------------------------------------
  sl.registerLazySingleton<BeneficiaryLocalDao>(
    () => BeneficiaryLocalDao(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<ActivityLocalDao>(
    () => ActivityLocalDao(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<DashboardLocalDao>(
    () => DashboardLocalDao(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<MapLocalDao>(() => MapLocalDao(sl<AppDatabase>()));

  sl.registerLazySingleton<ReportsLocalDao>(
    () => ReportsLocalDao(sl<AppDatabase>()),
  );

  // TODO(task-5.2):  sl.registerLazySingleton<AuthLocalDataSource>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<ProjectLocalDataSource>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<CommunityLocalDataSource>(...)
  // TODO(task-19.1): sl.registerLazySingleton<ProfileLocalDataSource>(...)

  // -------------------------------------------------------------------------
  // 6. Repositories
  // -------------------------------------------------------------------------
  // TODO(task-5.2):  sl.registerLazySingleton<AuthRepository>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<ProjectRepository>(...)
  // TODO(task-8.2):  sl.registerLazySingleton<CommunityRepository>(...)
  // TODO(task-11.2): sl.registerLazySingleton<BeneficiaryRepository>(...)
  // TODO(task-15.2): sl.registerLazySingleton<ActivityRepository>(...)
  // TODO(task-19.1): sl.registerLazySingleton<ProfileRepository>(...)

  // -------------------------------------------------------------------------
  // 7. Use cases
  // -------------------------------------------------------------------------
  // TODO(task-5.1):  sl.registerLazySingleton(() => LoginUseCase(...))
  // TODO(task-5.1):  sl.registerLazySingleton(() => LogoutUseCase(...))
  // TODO(task-5.1):  sl.registerLazySingleton(() => CheckAuthStatusUseCase(...))
  // TODO(task-8.1):  sl.registerLazySingleton(() => GetProjectsUseCase(...))
  // TODO(task-8.1):  sl.registerLazySingleton(() => GetCommunitiesUseCase(...))
  // TODO(task-8.1):  sl.registerLazySingleton(() => GetCommunitiesByProjectUseCase(...))
  // TODO(task-11.1): sl.registerLazySingleton(() => RegisterBeneficiaryUseCase(...))
  // TODO(task-11.1): sl.registerLazySingleton(() => GetBeneficiariesUseCase(...))
  // TODO(task-11.1): sl.registerLazySingleton(() => CheckDuplicateBeneficiaryUseCase(...))
  // TODO(task-11.1): sl.registerLazySingleton(() => ValidateBeneficiaryForm(...))
  // TODO(task-15.1): sl.registerLazySingleton(() => LogActivityUseCase(...))
  // TODO(task-15.1): sl.registerLazySingleton(() => GetActivitiesUseCase(...))
  // TODO(task-15.1): sl.registerLazySingleton(() => ValidateActivityForm(...))
  // TODO(task-19.1): sl.registerLazySingleton(() => GetProfileUseCase(...))

  // -------------------------------------------------------------------------
  // 8. BLoCs / Cubits — factory registrations (new instance per BlocProvider)
  // -------------------------------------------------------------------------
  // TODO(task-6.1):  sl.registerFactory(() => AuthBloc(...))
  // TODO(task-8.3):  sl.registerFactory(() => ProjectsCubit(...))
  // TODO(task-8.3):  sl.registerFactory(() => CommunitiesCubit(...))
  // TODO(task-9.1):  sl.registerFactory(() => DashboardCubit(...))
  // TODO(task-10.2): sl.registerFactory(() => ConnectivityCubit(...))
  // TODO(task-13.1): sl.registerFactory(() => BeneficiaryBloc(...))
  // TODO(task-15.5): sl.registerFactory(() => ActivityBloc(...))
  // TODO(task-16.3): sl.registerLazySingleton(() => SyncStatusCubit(...))
  // TODO(task-19.1): sl.registerFactory(() => ProfileCubit(...))
}
