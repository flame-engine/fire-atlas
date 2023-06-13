import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class ColorBadge extends StatelessWidget {
  final String label;
  final Color color;

  const ColorBadge({
    required this.label,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    final textColor = color.brighten(0.85);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      color: color,
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
