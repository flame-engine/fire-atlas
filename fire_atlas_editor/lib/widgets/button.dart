import 'package:flutter/material.dart';

class FButton extends StatelessWidget {
  final bool selected;
  final String label;
  final bool disabled;
  final double? width;
  final EdgeInsets? padding;
  final void Function() onSelect;

  FButton({
    this.selected = false,
    this.disabled = false,
    this.width,
    this.padding,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);

    final color = selected ? theme.primaryColor : theme.buttonColor;

    return Container(
      padding: padding,
      child: Opacity(
        opacity: disabled ? 0.6 : 1,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {
            if (!disabled) onSelect();
          },
          child: Container(
            width: width,
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
