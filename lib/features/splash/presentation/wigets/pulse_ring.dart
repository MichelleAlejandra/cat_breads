part of '../pages/splash_page.dart';

class _PulseRing extends StatefulWidget {
  const _PulseRing({
    required this.diameter,
    required this.borderColor,
    required this.fillColor,
    required this.duration,
    this.delay = Duration.zero,
  });

  final double diameter;
  final Color borderColor;
  final Color fillColor;
  final Duration duration;
  final Duration delay;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _pulse(_controller.value, 0.6, 0.2),
        child: Transform.scale(
          scale: _pulse(_controller.value, 0.92, 1.12),
          child: child,
        ),
      ),
      child: Container(
        width: widget.diameter,
        height: widget.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.fillColor,
          border: Border.all(color: widget.borderColor, width: 1),
        ),
      ),
    );
  }

  /// Triangle wave (0 -> 1 -> 0 as [t] goes 0 -> 1) eased and lerped between
  /// [begin] and [end], used to drive the breathing ring animation.
  static double _pulse(double t, double begin, double end) {
    final triangle = Curves.easeInOut.transform(1 - (2 * t - 1).abs());
    return begin + (end - begin) * triangle;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
