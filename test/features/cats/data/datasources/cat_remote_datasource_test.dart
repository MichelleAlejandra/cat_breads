import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:cat_breeds_app/features/cats/data/datasources/cat_remote_datasource.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final _MockCoreHttp coreHttp = _MockCoreHttp();
  final CatRemoteDataSourceImpl dataSource = CatRemoteDataSourceImpl(coreHttp);

  group('getCatBreeds', () {
    test('given page, limit and a null query and a successful response, '
        'when getCatBreeds is called, '
        'then it sends page and limit but omits q', () async {
      when(
        () => coreHttp.get<List<Cat>>(
          any(),
          headers: any(named: 'headers'),
          queryParameters: any(named: 'queryParameters'),
          parser: any(named: 'parser'),
        ),
      ).thenAnswer((_) async => HttpSuccess(<Cat>[_cat]));

      final result = await dataSource.getCatBreeds(page: 2, limit: 15);

      final captured = verify(
        () => coreHttp.get<List<Cat>>(
          any(),
          headers: any(named: 'headers'),
          queryParameters: {'page': '2', 'limit': '15', 'attach_image': '1'},
          parser: captureAny(named: 'parser'),
        ),
      ).captured;

      expect(result, isA<HttpSuccess<List<Cat>>>());

      final parser = captured.single as List<Cat> Function(int, dynamic);
      final parsed = parser(200, [
        {
          'id': 'abys',
          'name': 'Abyssinian',
          'origin': 'Egypt',
          'description': 'desc',
          'life_span': '14 - 15',
          'temperament': 'Active, Energetic',
          'history': 'history',
        },
      ]);

      expect(parsed, [
        Cat(
          id: 'abys',
          nameBreed: 'Abyssinian',
          origin: 'Egypt',
          description: 'desc',
          lifeSpan: '14 - 15',
          temperament: const ['Active', 'Energetic'],
          history: 'history',
        ),
      ]);
    });

    test('given page, limit, query and a failure response, '
        'when getCatBreeds is called, '
        'then it returns that HttpResult failure', () async {
      const failure = HttpFailure<List<Cat>>(HttpFailureReason.network);
      when(
        () => coreHttp.get<List<Cat>>(
          any(),
          headers: any(named: 'headers'),
          queryParameters: any(named: 'queryParameters'),
          parser: any(named: 'parser'),
        ),
      ).thenAnswer((_) async => failure);

      final result = await dataSource.getCatBreeds(
        page: 0,
        limit: 10,
        query: 'stuff',
      );

      verify(
        () => coreHttp.get<List<Cat>>(
          any(),
          headers: any(named: 'headers'),
          queryParameters: {
            'page': '0',
            'limit': '10',
            'attach_image': '1',
            'q': 'stuff',
          },
          parser: any(named: 'parser'),
        ),
      ).called(1);

      expect(result, same(failure));
    });
  });

  group('getCatById', () {
    test(
      'given a successful response, '
      'when getCatById is called, '
      'then it requests the breed-by-id endpoint with the api key header',
      () async {
        when(
          () => coreHttp.get<Cat>(
            any(),
            headers: any(named: 'headers'),
            parser: any(named: 'parser'),
          ),
        ).thenAnswer(
          (_) async => HttpSuccess(
            Cat(
              id: 'abys',
              nameBreed: 'Abyssinian',
              origin: 'Egypt',
              description: 'desc',
              lifeSpan: '14 - 15',
              temperament: const ['Active'],
              history: 'history',
            ),
          ),
        );

        final result = await dataSource.getCatById(id: 'abys');

        final captured = verify(
          () => coreHttp.get<Cat>(
            captureAny(),
            headers: any(named: 'headers'),
            parser: captureAny(named: 'parser'),
          ),
        ).captured;

        expect(captured[0], contains('abys'));
        expect(result, isA<HttpSuccess<Cat>>());

        final parser = captured[1] as Cat Function(int, dynamic);
        final parsed = parser(200, {
          'id': 'abys',
          'name': 'Abyssinian',
          'origin': 'Egypt',
          'description': 'desc',
          'life_span': '14 - 15',
          'temperament': 'Active',
          'history': 'history',
        });

        expect(
          parsed,
          Cat(
            id: 'abys',
            nameBreed: 'Abyssinian',
            origin: 'Egypt',
            description: 'desc',
            lifeSpan: '14 - 15',
            temperament: const ['Active'],
            history: 'history',
          ),
        );
      },
    );

    test('given CoreHttp returns a failure, '
        'when getCatById is called, '
        'then it returns that HttpResult unchanged', () async {
      const failure = HttpFailure<Cat>(HttpFailureReason.parsing);
      when(
        () => coreHttp.get<Cat>(
          any(),
          headers: any(named: 'headers'),
          parser: any(named: 'parser'),
        ),
      ).thenAnswer((_) async => failure);

      final result = await dataSource.getCatById(id: 'unknown');

      expect(result, same(failure));
    });
  });
}

class _MockCoreHttp extends Mock implements CoreHttp {}

final Cat _cat = Cat(
  id: 'abys',
  nameBreed: 'Abyssinian',
  origin: 'Egypt',
  description: 'desc',
  lifeSpan: '14 - 15',
  temperament: const ['Active'],
  history: 'history',
);
