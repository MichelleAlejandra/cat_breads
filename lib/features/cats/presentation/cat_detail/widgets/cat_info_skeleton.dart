part of '../pages/cat_detail_page.dart';

class _CatInfoSkeleton extends StatelessWidget {
  const _CatInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Cat cat = Cat(
      id: '',
      nameBreed: 'Skeleton breed',
      origin: 'Skeleton origin',
      description: 'Loreipsum, Loreipsum, Loreipsum, Loreipsum, Loreipsum, Loreipsum',
      lifeSpan: '20-30',
      temperament: ['Smart', 'Skeleton temperament 2', 'Intelligent'],
      history: 'Loreipsum ',
      breedGroup: 'short hair',
      weight: '12-13'
    );
    return Skeletonizer(child: _CatInfo(cat: cat));
  }
}
