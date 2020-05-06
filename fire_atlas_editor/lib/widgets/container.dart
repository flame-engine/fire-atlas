import 'package:flutter/material.dart';

class FContainer extends StatelessWidget {

  final double width;
  final double height;
  final Widget child;
  final Color color;

  FContainer({
    this.child,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(ctx) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
                color: Theme.of(ctx).dividerColor,
                width: 2.5,
            ),
            borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.all(2.5),
        width: width,
        height: height,
        child: child,
    );
  }
}
