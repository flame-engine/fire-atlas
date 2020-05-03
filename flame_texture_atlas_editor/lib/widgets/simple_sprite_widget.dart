import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

import 'dart:math';

class SimpleSpriteWidget extends StatelessWidget {
  final Sprite sprite;

  SimpleSpriteWidget({ this.sprite });

  @override
  Widget build(_) {
    return Container(
        child: CustomPaint(painter: _SimpleSpritePainer(sprite)),
    );
  }
}

class _SimpleSpritePainer extends CustomPainter {
  final Sprite _sprite;

  _SimpleSpritePainer(this._sprite);

  @override
  bool shouldRepaint(_SimpleSpritePainer old) => old._sprite != _sprite;

  @override
  void paint(Canvas canvas, Size size) {
    final widthRate = size.width / _sprite.size.x;
    final heightRate = size.height / _sprite.size.y;

    final rate = min(widthRate, heightRate);

    _sprite.renderRect(
        canvas,
        Rect.fromLTWH(
            0,
            0,
            _sprite.size.x * rate,
            _sprite.size.y * rate,
        )
    );
  }
}
