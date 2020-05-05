import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

import 'dart:math';

class SimpleSpriteLoaderWidget extends StatelessWidget {
  final Future<Sprite> future;
  final bool center;

  SimpleSpriteLoaderWidget({
    this.future,
    this.center = false,
  });

  @override
  Widget build(ctx) {
    return FutureBuilder(
        future: future,
        builder: (ctx, snapshot) {
          if (snapshot.hasData)
            return SimpleSpriteWidget(sprite: snapshot.data, center: center);

          if (snapshot.hasError)
            return Text('Something went wrong :(');

          return Text('Loading...');
        }
    );
  }
}

class SimpleSpriteWidget extends StatelessWidget {
  final Sprite sprite;
  final bool center;

  SimpleSpriteWidget({
    this.sprite,
    this.center = false,
  });

  @override
  Widget build(_) {
    return Container(
        child: CustomPaint(painter: _SimpleSpritePainer(sprite, center)),
    );
  }
}

class _SimpleSpritePainer extends CustomPainter {
  final Sprite _sprite;
  final bool _center;

  _SimpleSpritePainer(this._sprite, this._center);

  @override
  bool shouldRepaint(_SimpleSpritePainer old) => old._sprite != _sprite;

  @override
  void paint(Canvas canvas, Size size) {
    final widthRate = size.width / _sprite.size.x;
    final heightRate = size.height / _sprite.size.y;

    final rate = min(widthRate, heightRate);

    final rect = Rect.fromLTWH(
        0,
        0,
        _sprite.size.x * rate,
        _sprite.size.y * rate,
    );

    if (_center) {
      canvas.translate(
          size.width / 2 - rect.width / 2,
          size.height / 2 - rect.height / 2,
      );
    }

    _sprite.renderRect(canvas, rect);
  }
}
