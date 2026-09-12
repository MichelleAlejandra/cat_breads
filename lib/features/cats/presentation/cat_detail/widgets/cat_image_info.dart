part of '../pages/cat_detail_page.dart';

class _CatImageInformation extends StatelessWidget {
  const _CatImageInformation({required this.image, required this.breedGroup});

  final CatImage? image;
  final String breedGroup;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.40,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomNetworkImage(
                  url: image?.url ?? '',
                  width: constraints.maxWidth,
                  height: image?.heightForWidth(constraints.maxWidth),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 8.0,
          left: 8.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
            child: Row(
              spacing: 4.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sell_outlined, color: Colors.white, size: 16),
                Text(
                  breedGroup,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
