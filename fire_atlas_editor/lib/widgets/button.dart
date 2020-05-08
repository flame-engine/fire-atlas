import 'package:flutter/material.dart';

class FButton extends StatelessWidget {

  final bool selected;
  final String label;
  final void Function() onSelect;

  FButton({
    this.selected = false,
    this.label,
    this.onSelect,
  });

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);

    final color = selected ? theme.primaryColor : theme.buttonColor;

    return RaisedButton(
        color: color,
        onPressed: onSelect,
        child: Text(label),
    );
  }
}
