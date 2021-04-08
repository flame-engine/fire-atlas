import 'package:flutter/material.dart';

class FButton extends StatelessWidget {
  final bool selected;
  final String label;
  final bool disabled;
  final void Function() onSelect;

  FButton({
    this.selected = false,
    this.disabled = false,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);

    final color = selected ? theme.primaryColor : theme.buttonColor;

    return Opacity(
        opacity: disabled ? 0.6 : 1,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {
            if (!disabled) onSelect();
          },
          child: Text(label),
        ));
  }
}
