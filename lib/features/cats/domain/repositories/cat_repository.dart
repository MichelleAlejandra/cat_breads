import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';

abstract class CatRepository {
  /// Fetches cat breeds, [page]-indexed from 0, [limit] breeds per page, optionally filtered by [query].
  Future<Either<Failure, List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
    String? query,
  });

  /// Fetches cat by [id].
  Future<Either<Failure, Cat>> getCatById({required String id});
}
