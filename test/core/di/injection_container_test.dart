import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/features/cats/data/datasources/cat_remote_datasource.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async => await sl.reset());

  test(
    'given initDependencies is called, '
    'when resolving each registered dependency, '
    'then it returns an instance of the expected type, '
    'wiring CatRepository down to CoreHttp through their abstractions',
    () async {
      await initDependencies();

      expect(sl<CoreHttp>(), isA<CoreHttp>());
      expect(sl<CatRemoteDataSource>(), isA<CatRemoteDataSource>());
      expect(sl<CatRepository>(), isA<CatRepository>());
      expect(sl<CatListBloc>(), isA<CatListBloc>());
      expect(sl<CatDetailBloc>(), isA<CatDetailBloc>());
    },
  );
}
