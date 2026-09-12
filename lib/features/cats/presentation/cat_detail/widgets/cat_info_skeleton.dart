part of '../pages/cat_detail_page.dart';

class _CatInfoSkeleton extends StatelessWidget {
  const _CatInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    final Cat cat = Cat(
      id: '',
      nameBreed: 'Skeleton breed',
      origin: 'Skeleton origin',
      description: '',
      lifeSpan: '20-30',
      temperament: ['Smart', 'Skeleton temperament 2', 'Intelligent'],
      history: 'Loreipsum ',
      breedGroup: '',
    );
    return Skeletonizer(child: _CatInfo(cat: cat));
  }
}
