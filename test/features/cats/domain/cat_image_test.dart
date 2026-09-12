import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('heightForWidth', () {
    test(
      'given a width and height, '
      'when heightForWidth is called, '
      'then it returns the proportional height for the given width',
      () {
        final image = CatImage(url: 'url', width: 200, height: 100);

        expect(image.heightForWidth(400), 200);
      },
    );

    test(
      'given a null width, '
      'when heightForWidth is called, '
      'then it returns null',
      () {
        final image = CatImage(url: 'url', width: null, height: 100);

        expect(image.heightForWidth(400), isNull);
      },
    );

    test(
      'given a null height, '
      'when heightForWidth is called, '
      'then it returns null',
      () {
        final image = CatImage(url: 'url', width: 200, height: null);

        expect(image.heightForWidth(400), isNull);
      },
    );

    test(
      'given a width of zero, '
      'when heightForWidth is called, '
      'then it returns null',
      () {
        final image = CatImage(url: 'url', width: 0, height: 100);

        expect(image.heightForWidth(400), isNull);
      },
    );
  });
}
