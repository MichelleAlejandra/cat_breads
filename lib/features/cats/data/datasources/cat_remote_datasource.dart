import 'package:cat_breeds_app/core/env/env.dart';
import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:cat_breeds_app/features/cats/data/models/cat_model.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';

abstract class CatRemoteDataSource {
  /// Returns a list of [Cat]s given [page], [limit] and [query]
  Future<HttpResult<List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
    String? query,
  });

  /// Returns a [Cat] with the given [id]
  Future<HttpResult<Cat>> getCatById({required String id});
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  CatRemoteDataSourceImpl(this._coreHttp);

  final CoreHttp _coreHttp;

  @override
  Future<HttpResult<List<Cat>>> getCatBreeds({
    required int page,
    required int limit,
    String? query,
  }) {
    return _coreHttp.get<List<Cat>>(
      '${Env.apiBaseUrl}breeds/search',
      headers: {'x-api-key': Env.apiKey},
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (query != null && query.isNotEmpty) 'q': query,
        'attach_image': '1',
      },
      parser: (status, json) => (json as List)
          .map(
            (breed) =>
                CatModel.fromJson(breed as Map<String, dynamic>).toEntity(),
          )
          .toList(),
    );
  }

  @override
  Future<HttpResult<Cat>> getCatById({required String id}) {
    return _coreHttp.get<Cat>(
      '${Env.apiBaseUrl}breeds/$id',
      headers: {'x-api-key': Env.apiKey},
      parser: (status, json) =>
          CatModel.fromJson(json as Map<String, dynamic>).toEntity(),
    );
  }
}
