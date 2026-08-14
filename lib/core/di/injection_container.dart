import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../../data/datasources/github_remote_datasource.dart';
import '../../data/datasources/search_history_local_datasource.dart';
import '../../data/repositories/github_repository_impl.dart';
import '../../data/repositories/search_history_repository_impl.dart';
import '../../domain/repositories/github_repository.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/get_user_repos_usecase.dart';
import '../../domain/usecases/search_history_usecases.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/repositories/repositories_bloc.dart';
import '../../presentation/blocs/recent_searches/recent_searches_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies({SharedPreferences? customPrefs}) async {
  // 1. External
  final sharedPreferences = customPrefs ?? await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sharedPreferences: sl()));

  // 2. Data Sources
  sl.registerLazySingleton<GithubRemoteDataSource>(
    () => GithubRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<SearchHistoryLocalDataSource>(
    () => SearchHistoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // 3. Repositories
  sl.registerLazySingleton<GithubRepository>(
    () => GithubRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SearchHistoryRepository>(
    () => SearchHistoryRepositoryImpl(localDataSource: sl()),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserReposUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentSearchesUseCase(sl()));
  sl.registerLazySingleton(() => AddRecentSearchUseCase(sl()));
  sl.registerLazySingleton(() => RemoveRecentSearchUseCase(sl()));
  sl.registerLazySingleton(() => ClearRecentSearchesUseCase(sl()));

  // 5. BLoCs / Cubits
  sl.registerFactory(
    () => SearchBloc(getUserUseCase: sl()),
  );
  sl.registerFactory(
    () => RepositoriesBloc(getUserReposUseCase: sl()),
  );
  sl.registerFactory(
    () => RecentSearchesBloc(
      getRecentSearchesUseCase: sl(),
      addRecentSearchUseCase: sl(),
      removeRecentSearchUseCase: sl(),
      clearRecentSearchesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ThemeCubit(sharedPreferences: sl()),
  );
}
