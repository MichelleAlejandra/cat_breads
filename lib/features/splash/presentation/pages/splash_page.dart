import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:cat_breeds_app/core/theme/app_images.dart';
import 'package:cat_breeds_app/core/theme/build_context_theme_ext.dart';
import 'package:cat_breeds_app/features/cats/presentation/cat_list/pages/cat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part '../wigets/pulse_ring.dart';
part '../wigets/sparkle.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = 'splash';
  static const routePath = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;

  final Duration _animationDuration = const Duration(milliseconds: 2400);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _initAnimations();

    _controller.forward();

    // Redirect to principal page
    Future.delayed(_animationDuration + const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go(CatListPage.routePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SplashLogo(scale: _logoScale, opacity: _logoOpacity),
            const SizedBox(height: 24),
            SlideTransition(
              position: _titleOffset,
              child: FadeTransition(
                opacity: _titleOpacity,
                child: _SplashTitle(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initAnimations() {
    // Logo animations
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Title animations
    _titleOffset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        Text.rich(
          TextSpan(
            style: context.textTheme.headlineLarge,
            children: [
              TextSpan(
                text: 'Cat',
                style: TextStyle(color: AppColors.splashTitle),
              ),
              TextSpan(
                text: 'Breed',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        Text(
          'Discover, learn, and connect with each breed.',
          style: TextStyle(
            color: AppColors.splashTitle,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo({required this.scale, required this.opacity});

  final Animation<double> scale;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: opacity,
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _PulseRing(
                diameter: 280,
                borderColor: AppColors.splashRingSlowBorder.withValues(
                  alpha: 0.6,
                ),
                fillColor: AppColors.splashRingSlowFill.withValues(alpha: 0.4),
                duration: const Duration(seconds: 4),
              ),
              _PulseRing(
                diameter: 220,
                borderColor: AppColors.splashRingFastBorder.withValues(
                  alpha: 0.4,
                ),
                fillColor: AppColors.splashRingFastFill.withValues(alpha: 0.3),
                duration: const Duration(seconds: 3),
                delay: const Duration(seconds: 1),
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 35),
                    child: Image.asset(
                      AppImages.puchis,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 20,
                right: 35,
                child: _Sparkle(glyph: '✦', size: 18, opacity: 1),
              ),
              const Positioned(
                bottom: 45,
                left: 25,
                child: _Sparkle(glyph: '✧', size: 14, opacity: 0.75),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
