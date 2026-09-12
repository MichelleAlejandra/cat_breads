import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/repositories/cat_repository.dart';
import 'package:cat_breeds_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final Cat cat = Cat(
    id: 'abys',
    nameBreed: 'Abyssinian',
    origin: 'Egypt',
    description: 'desc',
    lifeSpan: '14 - 15',
    temperament: const ['Active'],
    history: 'history',
    breedGroup: '',
  );

  setUp(() async {
    await initDependencies();

    final _MockCatRepository repository = _MockCatRepository();
    when(
      () => repository.getCatBreeds(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => Either.right([cat]));
    when(
      () => repository.getCatById(id: any(named: 'id')),
    ).thenAnswer((_) async => Either.right(cat));

    sl.unregister<CatRepository>();
    sl.registerLazySingleton<CatRepository>(() => repository);
  });

  tearDown(() async => await sl.reset());

  testWidgets('given the app just launched, '
      'when the splash redirect delay elapses and the user taps "see more" '
      'on a cat card, '
      'then it lands on the cat list and then on that cat\'s detail page', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('splash-title')), findsNothing);

    // Splash's animation + redirect delay before it navigates away.
    await tester.pump(const Duration(milliseconds: 5200));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cat-list')), findsOneWidget);
    expect(find.text(cat.nameBreed), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('see-more-chip_${cat.id}')));
    await tester.pumpAndSettle();

    expect(find.text(cat.description), findsOneWidget);
  });
}

class _MockCatRepository extends Mock implements CatRepository {}
