import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChipWrap extends StatelessWidget {
  const ChipWrap({
    super.key,
    required this.values,
    this.color = AppColors.primary,
    this.withBorder = true,
  });

  final List<String> values;
  final Color color;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: values
          .map(
            (value) =>
                _Chip(value: value, color: color, withBorder: withBorder),
          )
          .toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.value,
    required this.color,
    required this.withBorder,
  });

  final String value;
  final Color color;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: withBorder
            ? Border.all(color: color.withValues(alpha: 0.3), width: 1)
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
