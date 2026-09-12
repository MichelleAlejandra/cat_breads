import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/bloc/cat_detail_bloc.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/pages/cat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockCatRepository repository;

  Cat buildCat(String id) => Cat(
    id: id,
    nameBreed: 'Breed $id',
    origin: 'Origin $id',
    description: 'Description $id',
    lifeSpan: '10 - 15',
    temperament: ['Active $id', 'Curious $id'],
    history: 'History $id',
    breedGroup: 'Short hair',
    weight: '4 - 5',
    height: '25 - 30',
    image: CatImage(url: 'url', width: 100, height: 100),
  );

  setUp(() {
    repository = _MockCatRepository();
    sl.registerFactory<CatDetailBloc>(
      () => CatDetailBloc(repository: repository),
    );
  });

  tearDown(() async => await sl.reset());

  testWidgets('given the repository returns a cat, '
      'when the fetch completes, '
      'then it renders the cat\'s name, breed group, flash info, '
      'description, temperament and history', (tester) async {
    final Cat cat = buildCat('1');

    when(
      () => repository.getCatById(id: cat.id),
    ).thenAnswer((_) async => Either.right(cat));

    await tester.pumpWidget(_makeWidget(id: cat.id));
    await tester.pumpAndSettle();

    expect(find.text(cat.nameBreed), findsOneWidget);
    expect(find.text(cat.breedGroup), findsOneWidget);
    expect(find.textContaining(cat.lifeSpan), findsOneWidget);
    expect(find.textContaining(cat.weight), findsOneWidget);
    expect(find.textContaining(cat.height), findsOneWidget);
    expect(find.text(cat.origin), findsOneWidget);
    expect(find.text(cat.description), findsOneWidget);
    expect(find.text(cat.history), findsOneWidget);
    for (final trait in cat.temperament) {
      expect(find.text(trait), findsOneWidget);
    }
  });

  testWidgets('given the repository returns Either.left, '
      'when the fetch completes, '
      'then it shows an error message', (tester) async {
    final Duration duration = Duration(seconds: 2);

    when(() => repository.getCatById(id: '1')).thenAnswer(
      (_) async => Future.delayed(
        duration,
        () => Either.left(Failure(FailureType.server)),
      ),
    );
    await tester.pumpWidget(_makeWidget(id: '1'));
    await tester.pump();
    expect(find.byKey(ValueKey('cat-info-skeleton')), findsOneWidget);

    await tester.pumpAndSettle(duration);
    expect(find.byKey(const Key('cat-detail-error')), findsOneWidget);
  });
}

MaterialApp _makeWidget({required String id}) =>
    MaterialApp(home: CatDetailPage(id: id));

class _MockCatRepository extends Mock implements CatRepository {}
