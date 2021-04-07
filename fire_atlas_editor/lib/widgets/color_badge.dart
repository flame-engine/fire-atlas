import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';

class ColorBadge extends StatelessWidget {
  final String label;
  final Color color;

  ColorBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(ctx) {
    final textColor = color.brighten(0.85);

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      color: color,
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
