import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/lib/features/cats/domain/cat.dart';

abstract class CatRepository {
  /// Fetches cat breeds, [page]-indexed from 0, [limit] breeds per page.
  Future<Either<Failure, List<Cat>>> getCatBreeds({int page = 0, int limit = 10});
}
