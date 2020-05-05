import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

class CanvasSprite extends StatelessWidget {
  final Sprite sprite;
  final double translateX;
  final double translateY;
  final double scale;
  final int tileSize;
  final Offset selectionStart;
  final Offset selectionEnd;

  CanvasSprite({
    this.sprite,
    this.translateX,
    this.translateY,
    this.scale,
    this.tileSize,
    this.selectionStart,
    this.selectionEnd,
  });

  @override
  Widget build(ctx) {
    return Container(
        child: CustomPaint(painter: _CanvasSpritePainer(
            sprite,
            translateX,
            translateY,
            scale,
            tileSize,
            selectionStart,
            selectionEnd,

            Theme.of(ctx).primaryColor,
        )),
    );
  }
}

class _CanvasSpritePainer extends CustomPainter {
  final Sprite _sprite;
  final double _x;
  final double _y;
  final double _scale;
  final int _tileSize;
  final Offset _selectionStart;
  final Offset _selectionEnd;

  Color _selectionColor;

  _CanvasSpritePainer(
      this._sprite,
      this._x,
      this._y,
      this._scale,

      this._tileSize,

      this._selectionStart,
      this._selectionEnd,
      this._selectionColor,
  );

  @override
  bool shouldRepaint(_CanvasSpritePainer old) =>
    old._sprite != _sprite ||
    old._x != _x ||
    old._y != _y ||
    old._scale != _scale ||
    old._selectionStart != _selectionStart ||
    old._selectionEnd != _selectionEnd;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(_x, _y);
    canvas.scale(_scale, _scale);

    _sprite.renderRect(
        canvas,
        Rect.fromLTWH(
            0,
            0,
            _sprite.size.x,
            _sprite.size.y,
        )
    );

    if (_selectionStart != null && _selectionEnd != null) {
      final size = _selectionEnd - _selectionStart + Offset(1, 1);
      canvas.drawRect(
          Rect.fromLTWH(
              (_selectionStart.dx * _tileSize),
              (_selectionStart.dy * _tileSize),
              (size.dx * _tileSize),
              (size.dy * _tileSize),
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = _selectionColor,
      );
    }

    canvas.restore();
  }
}
