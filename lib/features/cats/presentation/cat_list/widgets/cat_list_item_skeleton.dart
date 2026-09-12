part of '../pages/cat_list_page.dart';

class _CatListItemSkeleton extends StatelessWidget {
  const _CatListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final Cat cat = Cat(
      id: '',
      nameBreed: 'Skeleton breed',
      origin: 'Skeleton origin',
      description: '',
      lifeSpan: '20-30',
      temperament: ['Smart', 'Skeleton temperament 2', 'Intelligent'],
      history: '',
    );
    return Skeletonizer(
      key: const Key('cat-skeleton'),
      child: _CatListItem(cat: cat),
    );
  }
}
