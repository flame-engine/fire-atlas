import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';

class CanvasSprite extends StatelessWidget {
  final Sprite sprite;
  final double translateX;
  final double translateY;
  final double scale;
  final double tileWidth;
  final double tileHeight;
  final Offset? selectionStart;
  final Offset? selectionEnd;

  CanvasSprite({
    required this.sprite,
    required this.translateX,
    required this.translateY,
    required this.scale,
    required this.tileWidth,
    required this.tileHeight,
    this.selectionStart,
    this.selectionEnd,
  });

  @override
  Widget build(ctx) {
    return Container(
      child: CustomPaint(
          painter: _CanvasSpritePainer(
        sprite,
        translateX,
        translateY,
        scale,
        tileWidth,
        tileHeight,
        selectionStart,
        selectionEnd,
        Theme.of(ctx).primaryColor,
        Theme.of(ctx).dividerColor,
        Theme.of(ctx).brightness == Brightness.dark,
      )),
    );
  }
}

class _CanvasSpritePainer extends CustomPainter {
  final Sprite _sprite;
  final double _x;
  final double _y;
  final double _scale;
  final double _tileWidth;
  final double _tileHeight;
  final Offset? _selectionStart;
  final Offset? _selectionEnd;
  final bool _darkMode;

  Color _selectionColor;
  Color _gridTileColor;

  _CanvasSpritePainer(
    this._sprite,
    this._x,
    this._y,
    this._scale,
    this._tileWidth,
    this._tileHeight,
    this._selectionStart,
    this._selectionEnd,
    this._selectionColor,
    this._gridTileColor,
    this._darkMode,
  );

  Color _transformColor(Color color, double ammount) {
    final raw = color.withOpacity(1);

    if (_darkMode) {
      return raw.darken(ammount);
    } else {
      return raw.brighten(ammount);
    }
  }

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
    // Background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _transformColor(_gridTileColor, 0.6),
    );

    canvas.save();
    canvas.translate(_x, _y);
    canvas.scale(_scale, _scale);

    final spriteRect = Rect.fromLTWH(
      0,
      0,
      _sprite.originalSize.x,
      _sprite.originalSize.y,
    );

    // Background outline
    canvas.drawRect(
      spriteRect.inflate(1.0),
      Paint()..color = _transformColor(_gridTileColor, 0.2),
    );

    // Checker board
    final rowCount = (_sprite.originalSize.y / _tileHeight).ceil();
    final columnCount = (_sprite.originalSize.x / _tileWidth).ceil();

    final darkTilePaint = Paint()..color = _transformColor(_gridTileColor, 0.7);
    final lightTilePaint = Paint()
      ..color = _transformColor(_gridTileColor, 0.9);

    for (var y = 0.0; y < rowCount; y++) {
      final m = y % 2;
      final p1 = m == 0 ? darkTilePaint : lightTilePaint;
      final p2 = m == 0 ? lightTilePaint : darkTilePaint;

      for (var x = 0.0; x < columnCount; x++) {
        canvas.drawRect(
            Rect.fromLTWH(
                x * _tileWidth, y * _tileHeight, _tileWidth, _tileHeight),
            x % 2 == 0 ? p1 : p2);
      }
    }

    // Sprite itself
    _sprite.render(canvas);

    // Selection
    final _start = _selectionStart;
    final _end = _selectionEnd;
    if (_start != null && _end != null) {
      final size = _end - _start + Offset(1, 1);
      canvas.drawRect(
        Rect.fromLTWH(
          (_start.dx * _tileWidth),
          (_start.dy * _tileHeight),
          (size.dx * _tileWidth),
          (size.dy * _tileHeight),
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
