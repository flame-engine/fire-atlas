import 'package:flutter/material.dart';

class FLabel extends StatelessWidget {
  final String label;

  FLabel({
    this.label,
  });

  @override
  Widget build(BuildContext ctx) {
    return Text(
        label,
        style: Theme.of(ctx).textTheme.bodyText2,
    );
  }
}

class FTitle extends StatelessWidget {
  final String title;

  FTitle({
    this.title,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 2,
                    color: Theme.of(ctx).dividerColor
                ),
            ),
        ),
        margin: EdgeInsets.only(
            bottom: 25,
            top: 5,
            left: 5,
            right: 5,
        ),
        child: Center(child: Text(
            title,
            style: Theme.of(ctx).textTheme.headline4,
        ))
    );
  }
}
