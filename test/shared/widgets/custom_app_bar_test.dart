import 'package:cat_breeds_app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testWidgets(
    'given isSecondary is false (primary appbar), '
    'when the app bar is rendered, '
    'then it shows the app icon and no back button',
    (tester) async {
      await tester.pumpWidget(_makeWidget(title: 'CatBreeds'));

      expect(find.byIcon(Icons.pets), findsOneWidget);
      expect(find.byKey(const Key('back-button')), findsNothing);
      expect(find.text('CatBreeds'), findsOneWidget);
    },
  );

  testWidgets(
    'given isSecondary is true, '
    'when the back button is tapped, '
    'then it pops the current route',
    (tester) async {
      final mockGoRouter = _MockGoRouter();
      when(() => mockGoRouter.pop<BuildContext>(any())).thenAnswer((_) {});

      await tester.pumpWidget(
        InheritedGoRouter(
          goRouter: mockGoRouter,
          child: _makeWidget(title: 'Breed detail', isSecondary: true),
        ),
      );

      expect(find.byKey(const Key('back-button')), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsNothing);

      await tester.tap(find.byKey(const Key('back-button')));
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.pop<BuildContext>(any())).called(1);
    },
  );
}

MaterialApp _makeWidget({required String title, bool isSecondary = false}) =>
    MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: title, isSecondary: isSecondary),
      ),
    );

class _MockGoRouter extends Mock implements GoRouter {}
