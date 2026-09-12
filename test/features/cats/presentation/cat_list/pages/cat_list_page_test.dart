import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_detail/pages/cat_detail_page.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/bloc/cat_list_bloc.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/pages/cat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockCatRepository repository;

  Cat buildCat(String id) => Cat(
    id: id,
    nameBreed: 'Breed $id',
    origin: 'Origin $id',
    description: 'desc',
    lifeSpan: '${id}0 - ${id}5',
    temperament: ['Active $id', 'Curious $id'],
    history: 'history',
  );

  final cats = [buildCat('1'), buildCat('2')];

  setUp(() {
    repository = _MockCatRepository();
    sl.registerFactory<CatListBloc>(() => CatListBloc(repository: repository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('given the repository returns cats, '
      'when the fetch completes, '
      'then it renders each cat name, origin, life span and temperament', (
    tester,
  ) async {
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: null),
    ).thenAnswer((_) async => Either.right(cats));

    await tester.pumpWidget(_makeWidget());
    await tester.pumpAndSettle();

    for (final cat in cats) {
      expect(find.text(cat.nameBreed), findsOneWidget);
      expect(find.text(cat.origin), findsOneWidget);
      expect(find.text(cat.lifeSpan), findsOneWidget);
      expect(find.text(cat.temperament.first), findsOneWidget);
    }
    expect(find.text('Ver más'), findsNWidgets(cats.length));
  });

  testWidgets('given the repository returns Either.left, '
      'when the fetch completes, '
      'then it shows an error message', (tester) async {
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: null),
    ).thenAnswer((_) async => Either.left(const Failure(FailureType.server)));

    await tester.pumpWidget(_makeWidget());
    await tester.pumpAndSettle();

    expect(find.text('Error loading cats'), findsOneWidget);
  });

  testWidgets('given a user types in the search field, '
      'when the debounce duration elapses, '
      'then it fetches cats filtered by the typed query', (tester) async {
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: null),
    ).thenAnswer((_) async => Either.right(cats));
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: 'bengal'),
    ).thenAnswer((_) async => Either.right([cats.first]));

    await tester.pumpWidget(_makeWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('search-textfield')), 'bengal');

    // Time to debounce completes
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text(cats.first.nameBreed), findsOneWidget);
    expect(find.text(cats.first.origin), findsOneWidget);
    expect(find.text(cats.first.lifeSpan), findsOneWidget);
    expect(find.text(cats.first.temperament.first), findsOneWidget);
  });

  testWidgets('given reaching the end of the last visible item,'
      'when the isLoadingMore state is set to true,'
      'a skeleton element is rendered at the end of the list', (tester) async {
    final otherCats = [buildCat('3'), buildCat('4')];
    final Duration delay = const Duration(milliseconds: 300);
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: null),
    ).thenAnswer((_) async => Either.right(cats));
    when(
      () => repository.getCatBreeds(page: 1, limit: 10, query: null),
    ).thenAnswer((_) => Future.delayed(delay, () => Either.right(otherCats)));

    await tester.pumpWidget(_makeWidget());
    await tester.pumpAndSettle();

    final ListView listView = tester.widget<ListView>(
      find.byKey(const Key('cat-list')),
    );
    listView.controller!.jumpTo(listView.controller!.position.maxScrollExtent);

    await tester.pump();
    expect(find.byKey(const Key('cat-skeleton')), findsOneWidget);

    // Advance the virtual clock past the repository's debounce.
    await tester.pump(delay);
    await tester.pumpAndSettle();
    expect(find.text(otherCats.first.nameBreed), findsOneWidget);
    expect(find.text(otherCats.first.origin), findsOneWidget);
    expect(find.text(otherCats.first.lifeSpan), findsOneWidget);
    expect(find.text(otherCats.first.temperament.first), findsOneWidget);
  });

  testWidgets('given a cat card, '
      'when the user taps "Ver más", '
      'then it navigates to CatDetailPage with that cat\'s id', (tester) async {
    when(
      () => repository.getCatBreeds(page: 0, limit: 10, query: null),
    ).thenAnswer((_) async => Either.right(cats));

    final _MockGoRouter mockGoRouter = _MockGoRouter();

    when(
      () => mockGoRouter.goNamed(
        any(),
        pathParameters: any(named: 'pathParameters'),
      ),
    ).thenReturn(null);

    await tester.pumpWidget(
      InheritedGoRouter(goRouter: mockGoRouter, child: _makeWidget()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ValueKey('see-more-chip_${cats.first.id}')));
    await tester.pumpAndSettle();

    verify(
      () => mockGoRouter.goNamed(
        CatDetailPage.routeName,
        pathParameters: {'id': cats.first.id},
      ),
    ).called(1);
  });
}

MaterialApp _makeWidget() => const MaterialApp(home: CatListPage());

class _MockGoRouter extends Mock implements GoRouter {}

class _MockCatRepository extends Mock implements CatRepository {}
