import 'package:bloc_test/bloc_test.dart';
import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockCatRepository repository;

  Cat buildCat(String id) => Cat(
    id: id,
    nameBreed: 'Breed $id',
    origin: 'Origin $id',
    description: 'desc',
    lifeSpan: '10 - 15',
    temperament: const ['Active'],
    history: 'history',
    breedGroup: '',
  );

  final cats = [buildCat('1'), buildCat('2')];

  setUp(() {
    repository = _MockCatRepository();
  });

  group('CatListEvent.initialize', () {
    blocTest<CatListBloc, CatListState>(
      'given the repository returns Either.right, '
      'when initialize is called, '
      'then it emits loading followed by loaded with the returned cats',
      setUp: () {
        when(
          () => repository.getCatBreeds(page: 0, limit: 10, query: null),
        ).thenAnswer((_) async => Either.right(cats));
      },
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.initialize()),
      expect: () => [
        CatListState.loading(),
        CatListState.loaded(cats: cats, page: 0, limit: 10),
      ],
    );

    blocTest<CatListBloc, CatListState>(
      'given the repository returns Either.left, '
      'when initialize is added, '
      'then it emits loading followed by error',
      setUp: () {
        when(
          () => repository.getCatBreeds(page: 0, limit: 10, query: null),
        ).thenAnswer(
          (_) async => Either.left(const Failure(FailureType.server)),
        );
      },
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.initialize()),
      expect: () => [CatListState.loading(), CatListState.error()],
    );
  });

  group('CatListEvent.loadMore', () {
    final moreCats = List.generate(10, (i) => buildCat('page1-$i'));

    blocTest<CatListBloc, CatListState>(
      'given the repository returns more cats than the limit, '
      'when loadMore is added, '
      'then it appends the new cats, advances the page and keeps hasReachedMax false',
      setUp: () {
        when(
          () => repository.getCatBreeds(page: 1, limit: 10, query: null),
        ).thenAnswer((_) async => Either.right(moreCats));
      },
      seed: () => CatListState.loaded(cats: cats, page: 0, limit: 10),
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.loadMore()),
      verify: (bloc) {
        bloc.state.maybeMap(
          loaded: (loaded) {
            expect(loaded.cats.length, cats.length + 10);
            expect(loaded.page, 1);
            expect(loaded.isLoadingMore, isFalse);
            expect(loaded.hasReachedMax, isFalse);
          },
          orElse: () => fail('expected loaded state'),
        );
      },
      expect: () => [
        CatListState.loaded(
          cats: cats,
          page: 0,
          limit: 10,
          isLoadingMore: true,
          hasReachedMax: false,
        ),
        CatListState.loaded(
          cats: cats + moreCats,
          page: 1,
          limit: 10,
          isLoadingMore: false,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<CatListBloc, CatListState>(
      'given the repository returns fewer cats than the limit, '
      'when loadMore is added, '
      'then it sets hasReachedMax to true',
      setUp: () {
        when(
          () => repository.getCatBreeds(page: 1, limit: 10, query: null),
        ).thenAnswer((_) async => Either.right([buildCat('last')]));
      },
      seed: () => CatListState.loaded(cats: cats, page: 0, limit: 10),
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.loadMore()),
      verify: (bloc) {
        bloc.state.maybeMap(
          loaded: (loaded) => expect(loaded.hasReachedMax, isTrue),
          orElse: () => fail('expected loaded state'),
        );
      },
    );

    blocTest<CatListBloc, CatListState>(
      'given hasReachedMax is already true, '
      'when loadMore is added, '
      'then it does not emit a new state and does not call the repository',
      seed: () => CatListState.loaded(
        cats: cats,
        page: 0,
        limit: 10,
        hasReachedMax: true,
      ),
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.loadMore()),
      expect: () => <CatListState>[],
      verify: (_) {
        verifyNever(
          () => repository.getCatBreeds(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    blocTest<CatListBloc, CatListState>(
      'given isLoadingMore is already true, '
      'when loadMore is added, '
      'then it does not emit a new state and does not call the repository',
      seed: () => CatListState.loaded(
        cats: cats,
        page: 0,
        limit: 10,
        isLoadingMore: true,
      ),
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.loadMore()),
      expect: () => <CatListState>[],
      verify: (_) {
        verifyNever(
          () => repository.getCatBreeds(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    blocTest<CatListBloc, CatListState>(
      'given the repository returns Either.left, '
      'when loadMore is added, '
      'then it keeps the current cats and page, and sets hasReachedMax to true',
      setUp: () {
        when(
          () => repository.getCatBreeds(page: 1, limit: 10, query: null),
        ).thenAnswer(
          (_) async => Either.left(const Failure(FailureType.network)),
        );
      },
      seed: () => CatListState.loaded(cats: cats, page: 0, limit: 10),
      build: () => CatListBloc(repository: repository),
      act: (bloc) => bloc.add(const CatListEvent.loadMore()),
      verify: (bloc) {
        bloc.state.maybeMap(
          loaded: (loaded) {
            expect(loaded.cats, cats);
            expect(loaded.page, 0);
            expect(loaded.isLoadingMore, isFalse);
            expect(loaded.hasReachedMax, isTrue);
          },
          orElse: () => fail('expected loaded state'),
        );
      },
    );
  });

  group('CatListEvent.search', () {
    blocTest<CatListBloc, CatListState>(
      'given several search queries typed in quick succession, '
      'when the debounce duration elapses, '
      'then it only triggers initialize once, with the last query',
      setUp: () {
        when(
          () => repository.getCatBreeds(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => Either.right(cats));
      },
      build: () => CatListBloc(repository: repository),
      act: (bloc) async {
        bloc.add(const CatListEvent.search(query: 'be'));
        await Future<void>.delayed(const Duration(milliseconds: 500));
        bloc.add(const CatListEvent.search(query: 'ben'));
        await Future<void>.delayed(const Duration(milliseconds: 500));
        bloc.add(const CatListEvent.search(query: 'bengal'));
      },
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        CatListState.loading(),
        CatListState.loaded(cats: cats, page: 0, limit: 10, query: 'bengal'),
      ],
      verify: (_) {
        verify(
          () => repository.getCatBreeds(page: 0, limit: 10, query: 'bengal'),
        ).called(1);
        verifyNever(
          () => repository.getCatBreeds(page: 0, limit: 10, query: 'be'),
        );
        verifyNever(
          () => repository.getCatBreeds(page: 0, limit: 10, query: 'ben'),
        );
      },
    );
  });
}

class _MockCatRepository extends Mock implements CatRepository {}
