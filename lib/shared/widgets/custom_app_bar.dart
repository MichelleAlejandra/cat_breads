import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isSecondary = false,
  });

  final String title;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
      textAlign: TextAlign.center,
    );
    return AppBar(
      elevation: 5,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSecondary)
            _BackButton(key: const Key('back-button'))
          else ...[
            const Icon(Icons.pets, color: AppColors.primary),
            const SizedBox(width: 8),
          ],
          if (isSecondary) Expanded(child: text) else text,
          if (isSecondary) SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BackButton extends StatelessWidget {
  const _BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 25,
          color: Colors.black,
        ),
      ),
    );
  }
}
