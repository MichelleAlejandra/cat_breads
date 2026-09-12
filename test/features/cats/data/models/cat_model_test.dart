import 'package:cat_breeds_app/features/cats/data/models/cat_image_model.dart';
import 'package:cat_breeds_app/features/cats/data/models/cat_model.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatModel.fromJson', () {
    test('given a full breed json payload, '
        'when fromJson is called, '
        'then it maps every field', () {
      final json = {
        'id': 'abys',
        'name': 'Abyssinian',
        'origin': 'Egypt',
        'description': 'The Abyssinian is easy to care for.',
        'life_span': '14 - 15',
        'image': {
          'id': '0XYvRd7oD',
          'url': 'https://example.com/abys.jpg',
          'width': 3114,
          'height': 2609,
        },
        'weight': {'imperial': '8-12', 'metric': '3.6-5.4'},
        'height': {'imperial': '10-12', 'metric': '25-30'},
        'temperament': 'Active, Energetic, Independent',
        'history': 'Some history text.',
      };

      final model = CatModel.fromJson(json);

      expect(model.id, 'abys');
      expect(model.nameBreed, 'Abyssinian');
      expect(model.origin, 'Egypt');
      expect(model.description, 'The Abyssinian is easy to care for.');
      expect(model.lifeSpan, '14 - 15');
      expect(model.image?.url, 'https://example.com/abys.jpg');
      expect(model.image?.width, 3114);
      expect(model.image?.height, 2609);
      expect(model.weight, '3.6-5.4');
      expect(model.height, '25-30');
      expect(model.temperament, 'Active, Energetic, Independent');
      expect(model.history, 'Some history text.');
    });

    test(
      'given a json with only the required id, '
      'when fromJson is called, '
      'then it applies defaults to every optional field, including a null image',
      () {
        final model = CatModel.fromJson({'id': 'abys'});

        expect(model.id, 'abys');
        expect(model.nameBreed, '');
        expect(model.origin, '');
        expect(model.description, '');
        expect(model.lifeSpan, '');
        expect(model.image, isNull);
        expect(model.weight, '');
        expect(model.height, '');
        expect(model.temperament, '');
        expect(model.history, '');
      },
    );
  });

  group('CatModel.toEntity', () {
    test('given a model with a comma-separated temperament, '
        'when toEntity is called, '
        'then it splits and trims each value', () {
      const model = CatModel(
        id: 'abys',
        nameBreed: 'Abyssinian',
        origin: 'Egypt',
        description: 'desc',
        lifeSpan: '14 - 15',
        image: CatImageModel(
          url: 'https://example.com/abys.jpg',
          width: 3114,
          height: 2609,
        ),
        weight: '3.6-5.4',
        height: '25-30',
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
          image: CatImage(
            url: 'https://example.com/abys.jpg',
            width: 3114,
            height: 2609,
          ),
          weight: '3.6-5.4',
          height: '25-30',
          temperament: const ['Active', 'Energetic', 'Independent'],
          history: 'history',
          breedGroup: '',
        ),
      );
    });

    test(
      'given a model with default (empty) temperament and no image, '
      'when toEntity is called, '
      'then temperament is a single empty-string item and image stays null',
      () {
        const model = CatModel(id: 'abys');

        final cat = model.toEntity();

        expect(cat.temperament, const ['']);
        expect(cat.image, isNull);
      },
    );
  });
}
