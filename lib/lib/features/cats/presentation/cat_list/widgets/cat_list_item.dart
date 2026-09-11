part of '../pages/cat_list_page.dart';

class _CatListItem extends StatelessWidget {
  const _CatListItem({super.key, required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    final double padding = 16.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder, width: 1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBorder,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cat.nameBreed,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                _SeeMoreChip(),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: padding, vertical: 8.0),
            child: _CatImage(imgUrl: cat.imageUrl),
          ),
          Divider(color: AppColors.cardBorder, height: 25.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              children: [
                Expanded(
                  child: _Info(
                    description: 'PAÍS DE ORIGEN',
                    value: cat.origin,
                    icon: Icons.public,
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8.0),
                _Info(
                  description: 'ESPERANZA DE VIDA',
                  value: cat.lifeSpan,
                  icon: Icons.favorite,
                  iconColor: Colors.red,
                  aligment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ),
          Divider(color: AppColors.cardBorder, height: 25.0),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: padding),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 6.0,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: cat.temperament
                  .take(3)
                  .map(
                    (temp) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        temp,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeeMoreChip extends StatelessWidget {
  const _SeeMoreChip();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Ver más',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}

class _CatImage extends StatelessWidget {
  const _CatImage({required this.imgUrl});

  final String? imgUrl;

  static const double _height = 150;

  @override
  Widget build(BuildContext context) {
    return imgUrl != null
        ? CachedNetworkImage(
            imageUrl: imgUrl!,
            placeholder: (context, url) =>
                _getPlaceholder(CircularProgressIndicator()),
            errorWidget: (context, url, error) => _getPlaceholder(
              Icon(
                Icons.image_not_supported_rounded,
                size: 100,
                color: AppColors.cardBorder,
              ),
            ),
          )
        : _getPlaceholder(
            Icon(
              Icons.image_not_supported_rounded,
              size: 100,
              color: AppColors.cardBorder,
            ),
          );
  }

  Container _getPlaceholder(Widget child) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: AppColors.cardBorder.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.image_not_supported_rounded,
        size: 100,
        color: AppColors.cardBorder,
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.description,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.aligment = CrossAxisAlignment.start,
  });

  final String description, value;
  final IconData icon;
  final Color iconColor;
  final CrossAxisAlignment aligment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: aligment,
      spacing: 2.0,
      children: [
        Text(
          description,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          spacing: 4.0,
          mainAxisAlignment: aligment == CrossAxisAlignment.start
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Icon(icon, size: 20, color: iconColor),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
