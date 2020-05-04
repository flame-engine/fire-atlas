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
                child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return _CanvasBoard(
                          sprite: Sprite.fromImage(snapshot.data),
                          size: size,
                      );
                    },
                ),
            );
          } else if (snapshot.hasError) {
            return Text('Something wrong happened :(');
          }
          return Text('Something wrong happened :(');
        }
    ));
  }
}

enum CanvasTools {
  SELECTION,
  MOVE,
}

class _ToolButton extends StatelessWidget {

  final bool selected;
  final String label;
  final void Function() onSelect;

  _ToolButton({
    this.selected = false,
    this.label,
    this.onSelect,
  });

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);

    return GestureDetector(
        onTap: onSelect,
        child: Container(
            child: Text(label),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            color: selected ? theme.primaryColor : theme.buttonColor,
        ),
    );
  }
}

class _CanvasBoard extends StatefulWidget {
  Sprite sprite;
  Size size;

  _CanvasBoard({ this.sprite, this.size });

  @override
  State createState() => _CanvasBoardState();
}

class _CanvasBoardState extends State<_CanvasBoard> {
  CanvasTools _currentTool = CanvasTools.MOVE;

  Offset _dragStart = Offset.zero;
  Offset _lastDrag = Offset.zero;

  double _translateX = 0.0;
  double _translateY = 0.0;

  double _scale = 1.0;

  void _handleMove(double x, double y) {
    if (_currentTool == CanvasTools.MOVE) {
      _translateX += x;
      _translateY += y;
    }
  }

  void _zoomIn() {
    setState(() {
      _scale += 0.2;
    });
  }

  void _zoomOut() {
    setState(() {
      _scale -= 0.2;
    });
  }

  @override
  void initState() {
    super.initState();

    _scale = (widget.size.width - 200) / widget.sprite.size.x;

    final middleX = widget.size.width / 2;

    _translateX = middleX - (widget.sprite.size.x * _scale) / 2;
    _translateY = 100;
  }

  @override
  Widget build(ctx) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              children: [
                _ToolButton(
                    onSelect: () =>  setState(() => _currentTool = CanvasTools.MOVE),
                    label: 'Move',
                    selected: _currentTool == CanvasTools.MOVE
                ),
                _ToolButton(
                    onSelect: () =>  setState(() => _currentTool = CanvasTools.SELECTION),
                    label: 'Selection',
                    selected: _currentTool == CanvasTools.SELECTION
                ),
                _ToolButton(
                    onSelect: _zoomIn,
                    label: 'Zoom In',
                ),
                _ToolButton(
                    onSelect: _zoomOut,
                    label: 'Zoom Out',
                ),
              ],
          ),
          Expanded(
              child: GestureDetector(
                  child: ClipRect(
                      child: _CanvasSprite(
                          sprite: widget.sprite,
                          translateX: _translateX,
                          translateY: _translateY,
                          scale: _scale,
                      ),
                  ),
                  onPanStart: (details) {
                    setState(() {
                      _lastDrag = _dragStart = details.localPosition;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      final x = details.localPosition.dx - _lastDrag.dx;
                      final y = details.localPosition.dy - _lastDrag.dy;

                      _handleMove(x, y);

                      _lastDrag = details.localPosition;
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _lastDrag = _dragStart = null;
                    });
                  },
              ),
          ),
        ],
    );
  }
}

class _CanvasSprite extends StatelessWidget {
  final Sprite sprite;
  final double translateX;
  final double translateY;
  final double scale;

  _CanvasSprite({ this.sprite, this.translateX, this.translateY, this.scale });

  @override
  Widget build(_) {
    return Container(
        child: CustomPaint(painter: _CanvasSpritePainer(
            sprite,
            translateX,
            translateY,
            scale,
        )),
    );
  }
}

class _CanvasSpritePainer extends CustomPainter {
  final Sprite _sprite;
  final double _x;
  final double _y;
  final double _scale;

  _CanvasSpritePainer(this._sprite, this._x, this._y, this._scale);

  @override
  bool shouldRepaint(_CanvasSpritePainer old) => 
    old._sprite != _sprite ||
    old._x != _x ||
    old._y != _y ||
    old._scale != _scale;

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

    canvas.restore();
  }
}
