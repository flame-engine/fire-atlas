import 'package:flutter/material.dart';

class FContainer extends StatelessWidget {

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final EdgeInsets margin;

  FContainer({
    this.child,
    this.height,
    this.width,
    this.color,
    this.margin = const EdgeInsets.all(2.5),
  });

  @override
  Widget build(ctx) {
    final containerColor = color ?? Theme.of(ctx).dialogBackgroundColor;
    return Container(
        decoration: BoxDecoration(
            color: containerColor,
            border: Border.all(
                color: Theme.of(ctx).dividerColor,
                width: 2.5,
            ),
            borderRadius: BorderRadius.circular(5),
        ),
        margin: margin,
        width: width,
        height: height,
        child: child,
    );
  }
}
