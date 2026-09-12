part of '../pages/cat_detail_page.dart';

class _CatFlashInfoGrid extends StatelessWidget {
  const _CatFlashInfoGrid({required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      children: [
        _CardInfo(
          description: 'LONGEVITY',
          value: '${cat.lifeSpan} years',
          color: AppColors.statLongevity,
          icon: Icons.favorite_border_rounded,
        ),
        _CardInfo(
          description: 'WEIGHT',
          value: '${cat.weight} kg',
          color: AppColors.statWeight,
          icon: Icons.balance_outlined,
        ),
        _CardInfo(
          description: 'HEIGHT',
          value: '${cat.height} cm',
          color: AppColors.statHeight,
          icon: Icons.height_outlined,
        ),
        _CardInfo(
          description: 'ORIGIN',
          value: cat.origin,
          color: AppColors.statOrigin,
          icon: Icons.public_outlined,
        ),
      ],
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({
    required this.description,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String description, value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        spacing: 10.0,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Flexible(
            child: Column(
              spacing: 2.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: context.textTheme.headlineSmall),
                Text(value, maxLines: 2, style: context.textTheme.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
