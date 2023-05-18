import 'package:flutter/material.dart';

class FLabel extends StatelessWidget {
  final String label;
  final double? fontSize;

  const FLabel({
    required this.label,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    return Text(
      label,
      style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
    );
  }
}

class _FTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const _FTitle({
    required this.title,
    this.style,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Theme.of(ctx).dividerColor),
        ),
      ),
      margin: const EdgeInsets.only(
        bottom: 25,
        top: 5,
        left: 5,
        right: 5,
      ),
      child: Center(
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}

class FTitle extends StatelessWidget {
  final String title;

  const FTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) => _FTitle(
        title: title,
        style: Theme.of(ctx).textTheme.headlineMedium,
      );
}

class FSubtitleTitle extends StatelessWidget {
  final String title;

  const FSubtitleTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) => _FTitle(
        title: title,
        style: Theme.of(ctx).textTheme.titleLarge,
      );
}
