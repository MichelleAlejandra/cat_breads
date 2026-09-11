import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/lib/features/cats/data/datasources/cat_remote_datasource.dart';
import 'package:cat_breeds_app/lib/features/cats/data/repositories/cat_repository_impl.dart';
import 'package:cat_breeds_app/lib/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/lib/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:get_it/get_it.dart';

/// Global service locator. Call [initDependencies] once in `main.dart`
/// before `runApp`, then resolve dependencies anywhere via `sl<T>()`.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => CoreHttp());

  // Cats feature
  sl.registerLazySingleton<CatRemoteDataSource>(
    () => CatRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CatRepository>(() => CatRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CatListBloc(repository: sl()));
}
