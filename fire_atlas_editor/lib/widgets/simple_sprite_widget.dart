import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class SimpleSpriteLoaderWidget extends StatelessWidget {
  final Future<Sprite> future;
  final bool center;

  const SimpleSpriteLoaderWidget({
    required this.future,
    super.key,
    this.center = false,
  });

  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder<Sprite>(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return SimpleSpriteWidget(
            sprite: snapshot.data!,
            center: center,
          );
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong :(');
        }

        return const Text('Loading...');
      },
    );
  }
}

class SimpleSpriteWidget extends StatelessWidget {
  final Sprite sprite;
  final bool center;

  const SimpleSpriteWidget({
    required this.sprite,
    super.key,
    this.center = false,
  });

  @override
  Widget build(_) {
    return CustomPaint(painter: _SimpleSpritePainter(sprite, center: center));
  }
}

class _SimpleSpritePainter extends CustomPainter {
  final Sprite _sprite;
  final bool _center;

  _SimpleSpritePainter(this._sprite, {required bool center}) : _center = center;

  @override
  bool shouldRepaint(_SimpleSpritePainter old) => old._sprite != _sprite;

  @override
  void paint(Canvas canvas, Size size) {
    final widthRate = size.width / _sprite.srcSize.x;
    final heightRate = size.height / _sprite.srcSize.y;

    final rate = min(widthRate, heightRate);

    final rect = Rect.fromLTWH(
      0,
      0,
      _sprite.srcSize.x * rate,
      _sprite.srcSize.y * rate,
    );

    if (_center) {
      canvas.translate(
        size.width / 2 - rect.width / 2,
        size.height / 2 - rect.height / 2,
      );
    }

    _sprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(rect.width, rect.height),
    );
  }
}
