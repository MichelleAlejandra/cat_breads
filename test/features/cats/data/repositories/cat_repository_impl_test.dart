import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:cat_breeds_app/features/cats/data/datasources/cat_remote_datasource.dart';
import 'package:cat_breeds_app/features/cats/data/repositories/cat_repository_impl.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final _MockCatRemoteDataSource remoteDataSource = _MockCatRemoteDataSource();
  final CatRepositoryImpl repository = CatRepositoryImpl(remoteDataSource);

  final cat = Cat(
    id: 'abys',
    nameBreed: 'Abyssinian',
    origin: 'Egypt',
    description: 'desc',
    lifeSpan: '14 - 15',
    temperament: const ['Active'],
    history: 'history',
  );

  group('getCatBreeds', () {
    test(
      'given page, limit and query, '
      'when getCatBreeds is called and the data source returns HttpSuccess, '
      'then it forwards them to the data source and returns Either.right with the data',
      () async {
        when(
          () => remoteDataSource.getCatBreeds(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => HttpSuccess([cat]));

        final result = await repository.getCatBreeds(
          page: 3,
          limit: 20,
          query: 'bengal',
        );

        verify(
          () => remoteDataSource.getCatBreeds(
            page: 3,
            limit: 20,
            query: 'bengal',
          ),
        ).called(1);

        expect(result.value, isA<List<Cat>>());
      },
    );

    test(
      'given page, limit without query, '
      'when getCatBreeds is called and the data source returns Failure, '
      'then it forwards them to the data source and returns Either.left with a mapped Failure',
      () async {
        when(
          () => remoteDataSource.getCatBreeds(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const HttpFailure(
            HttpFailureReason.server,
            statusCode: 500,
            message: 'Server error',
          ),
        );

        final result = await repository.getCatBreeds(page: 0, limit: 10);

        verify(
          () => remoteDataSource.getCatBreeds(page: 0, limit: 10, query: null),
        ).called(1);

        expect(result.value, isA<Failure>());
      },
    );
  });

  group('getCatById', () {
    test('given the data source returns HttpSuccess, '
        'when getCatById is called, '
        'then it returns Either.right with the data', () async {
      when(
        () => remoteDataSource.getCatById(id: any(named: 'id')),
      ).thenAnswer((_) async => HttpSuccess(cat));

      final result = await repository.getCatById(id: 'abys');

      verify(() => remoteDataSource.getCatById(id: 'abys')).called(1);

      expect(result.value, isA<Cat>());
    });

    test('given the data source returns HttpFailure, '
        'when getCatById is called, '
        'then it returns Either.left with a mapped Failure', () async {
      when(
        () => remoteDataSource.getCatById(id: any(named: 'id')),
      ).thenAnswer((_) async => const HttpFailure(HttpFailureReason.network));

      final result = await repository.getCatById(id: 'unknown');

      verify(() => remoteDataSource.getCatById(id: 'unknown')).called(1);

      expect(result.value, isA<Failure>());
    });
  });
}

class _MockCatRemoteDataSource extends Mock implements CatRemoteDataSource {}
