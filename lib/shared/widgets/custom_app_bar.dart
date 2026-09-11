import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.isSecondary = false});

  final String title;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, color: AppColors.splashTitle),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
