import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/exercise/data/datasources/exercise_remote_data_source.dart';
import '../../features/exercise/data/repositories/exercise_repository_impl.dart';
import '../../features/exercise/domain/repositories/exercise_repository.dart';
import '../../features/exercise/domain/usecases/exercise_usecases.dart';
import '../../features/exercise/presentation/bloc/workout_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());

  // Core Network
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), prefs: sl()),
  );

  // ==================== AUTH FEATURE ====================
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      apiClient: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyOtpUseCase: sl(),
      getMeUseCase: sl(),
      logoutUseCase: sl(),
      apiClient: sl(),
    ),
  );

  // ==================== EXERCISE FEATURE ====================
  // Data sources
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SaveWorkoutUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutHistoryUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => WorkoutBloc(
      saveWorkoutUseCase: sl(),
    ),
  );

  // ==================== DASHBOARD FEATURE ====================
  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => DashboardBloc(getDashboardStatsUseCase: sl()),
  );

  // ==================== HISTORY FEATURE ====================
  sl.registerFactory(
    () => HistoryBloc(getWorkoutHistoryUseCase: sl()),
  );
}
