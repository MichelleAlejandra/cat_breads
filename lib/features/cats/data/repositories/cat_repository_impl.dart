import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/core/http/perform_http_request.dart';
import 'package:cat_breeds_app/features/cats/data/datasources/cat_remote_datasource.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  CatRepositoryImpl(this._remoteDataSource);

  final CatRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
    String? query,
  }) async {
    return await performHttpRequest(
      _remoteDataSource.getCatBreeds(page: page, limit: limit, query: query),
    );
  }

  @override
  Future<Either<Failure, Cat>> getCatById({required String id}) async {
    return await performHttpRequest(
      _remoteDataSource.getCatById(id: id),
    );
  }
}
