import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class FButton extends StatefulWidget {

  final bool selected;
  final String label;
  final void Function() onSelect;

  FButton({
    this.selected = false,
    this.label,
    this.onSelect,
  });

  @override
  State createState() => _FButtonState();
}

class _FButtonState extends State<FButton> {

  bool _isPressed = false;

  void _press() {
    widget.onSelect();
    setState(() {
      _isPressed = false;
    });
  }

  void _pressStart() {
    setState(() {
      _isPressed = true;
    });
  }

  void _pressCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);

    final color = widget.selected ? theme.primaryColor : theme.buttonColor;

    return GestureDetector(
        onTapUp: (_) => _press(),
        onTapDown: (_) => _pressStart(),
        onTapCancel: () => _pressCancel(),
        child: Container(
            child: Text(widget.label),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            color: _isPressed ? TinyColor(color).darken().color : color,
        ),
    );
  }
}
