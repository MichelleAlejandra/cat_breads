import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// The CustomNetworkImage class is a StatelesWidget that renders an
/// image from a url
class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        httpHeaders: const {'Connection': 'keep-alive'},
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            _ResizableContainer(
              child: (w, h) => Container(
                width: w,
                height: h,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
              ratio: 0.45,
            ),
        errorWidget: (_, _, _) => _errorWidget(),
      ),
    );
  }

  _ResizableContainer _errorWidget() {
    return _ResizableContainer(
      child: (w, h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.image_not_supported_rounded,
          size: w / 4,
          color: AppColors.cardBorder,
        ),
      ),
      ratio: 1,
    );
  }
}

class _ResizableContainer extends StatelessWidget {
  const _ResizableContainer({required this.child, required this.ratio});

  final double ratio;
  final Widget Function(double, double) child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final width = size.width.isFinite ? size.width * ratio : ratio * 1.5;
        final height = size.height.isFinite
            ? size.height * ratio
            : width * ratio;
        return Center(child: child(width, height));
      },
    );
  }
}
