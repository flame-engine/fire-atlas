import 'package:flutter/material.dart';

class FIconButton extends StatefulWidget {
  final IconData iconData;
  final VoidCallback onPress;
  final bool disabled;
  final Color? color;
  final String? tooltip;

  FIconButton({
    required this.iconData,
    required this.onPress,
    this.disabled = false,
    this.color,
    this.tooltip,
  });

  @override
  State createState() => _FIconButtonState();
}

class _FIconButtonState extends State<FIconButton> {
  bool _pressed = false;

  void _pressReleased() {
    if (widget.disabled) return;
    widget.onPress.call();
    setState(() {
      _pressed = false;
    });
  }

  void _pressStart() {
    if (widget.disabled) return;
    setState(() {
      _pressed = true;
    });
  }

  void _pressCancel() {
    if (widget.disabled) return;
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(ctx) {
    final color = widget.color ?? Theme.of(ctx).primaryColor;
    final container = Container(
      margin: EdgeInsets.all(5),
      child: Icon(
        widget.iconData,
        color: color.withOpacity(widget.disabled || _pressed ? 0.2 : 1.0),
      ),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressStart(),
        onTapUp: (_) => _pressReleased(),
        onTapCancel: _pressCancel,
        child: widget.tooltip != null
            ? Tooltip(
                message: widget.tooltip!,
                child: container,
              )
            : container,
      ),
    );
  }
}
