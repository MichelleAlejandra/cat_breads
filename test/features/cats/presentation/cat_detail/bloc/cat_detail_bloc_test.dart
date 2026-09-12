import 'package:bloc_test/bloc_test.dart';
import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final _MockCatRepository repository = _MockCatRepository();

  final cat = Cat(
    id: '1',
    nameBreed: 'Breed 1',
    origin: 'Origin 1',
    description: 'desc',
    lifeSpan: '10 - 15',
    temperament: const ['Active'],
    history: 'history',
    breedGroup: '',
  );

  group('CatDetailEvent.initialize', () {
    blocTest<CatDetailBloc, CatDetailState>(
      'given the repository returns Either.right, '
      'when initialize is added, '
      'then it emits loading followed by loaded with the returned cat',
      setUp: () {
        when(
          () => repository.getCatById(id: cat.id),
        ).thenAnswer((_) async => Either.right(cat));
      },
      build: () => CatDetailBloc(repository: repository),
      act: (bloc) => bloc.add(CatDetailEvent.initialize(id: cat.id)),
      expect: () => [CatDetailState.loading(), CatDetailState.loaded(cat: cat)],
    );

    blocTest<CatDetailBloc, CatDetailState>(
      'given the repository returns Either.left, '
      'when initialize is added, '
      'then it emits loading followed by error',
      setUp: () {
        when(() => repository.getCatById(id: cat.id)).thenAnswer(
          (_) async => Either.left(const Failure(FailureType.server)),
        );
      },
      build: () => CatDetailBloc(repository: repository),
      act: (bloc) => bloc.add(CatDetailEvent.initialize(id: cat.id)),
      expect: () => [CatDetailState.loading(), CatDetailState.error()],
    );
  });
}

class _MockCatRepository extends Mock implements CatRepository {}
