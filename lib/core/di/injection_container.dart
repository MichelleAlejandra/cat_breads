
import 'package:get_it/get_it.dart';

/// Global service locator. Call [initDependencies] once in `main.dart`
/// before `runApp`, then resolve dependencies anywhere via `sl<T>()`.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  // sl.registerLazySingleton(() => DioClient.create());

  // Core


  // Posts feature
  // sl.registerLazySingleton<PostRemoteDataSource>(
  //   () => PostRemoteDataSourceImpl(sl()),
  // );
  // sl.registerLazySingleton<PostRepository>(
  //   () => PostRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  // );
  // sl.registerLazySingleton(() => GetPosts(sl()));
  // sl.registerFactory(() => PostBloc(sl()));
}