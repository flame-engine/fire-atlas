import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import '../../../widgets/container.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';

import 'dart:math';

class SelectionCanvas extends StatelessWidget {
  @override
  Widget build(_) {
    final store = Store.instance;

    return FContainer(child: FutureBuilder(
        future: Flame.images.fromBase64(
            store.state.currentAtlas.id,
            store.state.currentAtlas.imageData,
        ),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return MicroStoreProvider(
                store: store,
                child: _CanvasBoard(sprite: Sprite.fromImage(snapshot.data)),
            );
          } else if (snapshot.hasError) {
            return Text('Something wrong happened :(');
          }
          return Text('Something wrong happened :(');
        }
    ));
  }
}

class _CanvasBoard extends StatefulWidget {
  Sprite sprite;

  _CanvasBoard({ this.sprite });

  @override
  State createState() => _CanvasBoardState();
}

enum CanvasTools {
  SELECTION,
  MOVE,
  SCALE_UP,
  SCALE_DOWN,
}

class _CanvasBoardState extends State<_CanvasBoard> {
  CanvasTools _currentTool = CanvasTools.SELECTION;

  @override
  Widget build(ctx) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() => _currentTool = CanvasTools.SELECTION);
                    },
                    child: Text('Selection'),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() => _currentTool = CanvasTools.MOVE);
                    },
                    child: Text('Move'),
                ),
              ],
          ),
          Expanded(
              child: _CanvasSprite(sprite: widget.sprite),
          ),
        ],
    );
  }
}

class _CanvasSprite extends StatelessWidget {
  final Sprite sprite;

  _CanvasSprite({ this.sprite });

  @override
  Widget build(_) {
    return Container(
        child: CustomPaint(painter: _CanvasSpritePainer(sprite)),
    );
  }
}

class _CanvasSpritePainer extends CustomPainter {
  final Sprite _sprite;

  _CanvasSpritePainer(this._sprite);

  @override
  bool shouldRepaint(_CanvasSpritePainer old) => old._sprite != _sprite;

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
