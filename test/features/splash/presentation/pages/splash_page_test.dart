import 'package:cat_breeds_app/features/cats/presentation/cat_list/pages/cat_list_page.dart';
import 'package:cat_breeds_app/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockGoRouter mockGoRouter = _MockGoRouter();

  testWidgets('given the splash page is shown, '
      'when it renders, '
      'then it shows the app title and tagline and redirects to CatListPage', (
    tester,
  ) async {
    when(() => mockGoRouter.go(any())).thenReturn(null);

    await tester.pumpWidget(
      InheritedGoRouter(goRouter: mockGoRouter, child: _makeWidget()),
    );
    await tester.pump();

    expect(find.byKey(const Key('splash-title')), findsOneWidget);

    // Flush the pending redirect timer so no timer leaks past the test.
    await tester.pump(const Duration(milliseconds: 4900));

    verify(() => mockGoRouter.go(CatListPage.routePath)).called(1);
  });
}

MaterialApp _makeWidget() => const MaterialApp(home: SplashPage());

class _MockGoRouter extends Mock implements GoRouter {}
