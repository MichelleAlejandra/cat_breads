import 'package:cat_breeds_app/core/env/env.dart';
import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:cat_breeds_app/lib/features/cats/data/models/cat_model.dart';
import 'package:cat_breeds_app/lib/features/cats/domain/cat.dart';

abstract class CatRemoteDataSource {
  Future<HttpResult<List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
  });
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  CatRemoteDataSourceImpl(this._coreHttp);

  final CoreHttp _coreHttp;

  @override
  Future<HttpResult<List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
  }) {
    return _coreHttp.get<List<Cat>>(
      '${Env.apiBaseUrl}breeds',
      headers: {'x-api-key': Env.apiKey},
      queryParameters: {'page': '$page', 'limit': '$limit'},
      parser: (status, json) => (json as List)
          .map((breed) => CatModel.fromJson(breed as Map<String, dynamic>).toEntity())
          .toList(),
    );
  }
}
