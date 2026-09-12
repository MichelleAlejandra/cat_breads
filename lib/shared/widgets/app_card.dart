import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
