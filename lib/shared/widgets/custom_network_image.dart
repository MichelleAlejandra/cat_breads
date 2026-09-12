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
    final dpr = MediaQuery.of(context).devicePixelRatio;
    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        // Decode at display size (not full resolution) to cut memory usage.
        cacheWidth: width != null ? (width! * dpr).round() : null,
        cacheHeight: height != null ? (height! * dpr).round() : null,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: frame != null
                ? child
                : _ResizableContainer(
                    child: (w, h) => SizedBox(
                      width: w,
                      height: h,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    ratio: 1,
                  ),
          );
        },
        errorBuilder: (context, url, error) => _errorWidget(),
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
