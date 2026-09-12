part of '../pages/splash_page.dart';

class _Sparkle extends StatefulWidget {
  const _Sparkle({
    required this.glyph,
    required this.size,
    required this.opacity,
  });

  final String glyph;
  final double size;
  final double opacity;

  @override
  State<_Sparkle> createState() => _SparkleState();
}

class _SparkleState extends State<_Sparkle>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _bounce;

  @override
  void initState() {
    super.initState();

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _controller = controller;
    _bounce = Tween<double>(
      begin: 0,
      end: -6,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final sparkle = Text(
      widget.glyph,
      style: TextStyle(
        fontSize: widget.size,
        color: AppColors.primary.withValues(alpha: widget.opacity),
      ),
    );

    final bounce = _bounce;
    if (bounce == null) return sparkle;

    return AnimatedBuilder(
      animation: bounce,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, bounce.value), child: child),
      child: sparkle,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
