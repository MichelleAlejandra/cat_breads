import 'package:cat_breeds_app/features/cats/data/models/cat_model.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatModel.fromJson', () {
    test(
      'given a full breed json payload, '
      'when fromJson is called, '
      'then it maps every field',
      () {
        final json = {
          'id': 'abys',
          'name': 'Abyssinian',
          'origin': 'Egypt',
          'description': 'The Abyssinian is easy to care for.',
          'life_span': '14 - 15',
          'image': {'id': '0XYvRd7oD', 'url': 'https://example.com/abys.jpg'},
          'temperament': 'Active, Energetic, Independent',
          'history': 'Some history text.',
        };

        final model = CatModel.fromJson(json);

        expect(model.id, 'abys');
        expect(model.nameBreed, 'Abyssinian');
        expect(model.origin, 'Egypt');
        expect(model.description, 'The Abyssinian is easy to care for.');
        expect(model.lifeSpan, '14 - 15');
        expect(model.imageUrl, 'https://example.com/abys.jpg');
        expect(model.temperament, 'Active, Energetic, Independent');
        expect(model.history, 'Some history text.');
      },
    );

    test(
      'given a json with only the required id, '
      'when fromJson is called, '
      'then it applies defaults to every optional field, including a null imageUrl',
      () {
        final model = CatModel.fromJson({'id': 'abys'});

        expect(model.id, 'abys');
        expect(model.nameBreed, '');
        expect(model.origin, '');
        expect(model.description, '');
        expect(model.lifeSpan, '');
        expect(model.imageUrl, isNull);
        expect(model.temperament, '');
        expect(model.history, '');
      },
    );
  });

  group('CatModel.toEntity', () {
    test(
      'given a model with a comma-separated temperament, '
      'when toEntity is called, '
      'then it splits and trims each value',
      () {
        const model = CatModel(
          id: 'abys',
          nameBreed: 'Abyssinian',
          origin: 'Egypt',
          description: 'desc',
          lifeSpan: '14 - 15',
          imageUrl: 'https://example.com/abys.jpg',
          temperament: 'Active, Energetic,  Independent',
          history: 'history',
        );

        final cat = model.toEntity();

        expect(
          cat,
          Cat(
            id: 'abys',
            nameBreed: 'Abyssinian',
            origin: 'Egypt',
            description: 'desc',
            lifeSpan: '14 - 15',
            imageUrl: 'https://example.com/abys.jpg',
            temperament: const ['Active', 'Energetic', 'Independent'],
            history: 'history',
          ),
        );
      },
    );

    test(
      'given a model with default (empty) temperament and no imageUrl, '
      'when toEntity is called, '
      'then temperament is a single empty-string item and imageUrl stays null',
      () {
        const model = CatModel(id: 'abys');

        final cat = model.toEntity();

        expect(cat.temperament, const ['']);
        expect(cat.imageUrl, isNull);
      },
    );
  });
}
