import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinycolor/tinycolor.dart';

class ColorBadge extends StatelessWidget {
  final String label;
  final Color color;

  ColorBadge({
    @required this.label,
    @required this.color,
  });

  @override
  Widget build(ctx) {
    final textColor = TinyColor(color).lighten(35).color;

    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        color: color,
        child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
