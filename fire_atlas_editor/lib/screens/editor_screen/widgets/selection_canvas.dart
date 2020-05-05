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
                          tileSize: store.state.currentAtlas.tileSize,
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
  final Sprite sprite;
  final Size size;
  final int tileSize;

  _CanvasBoard({ this.sprite, this.size, this.tileSize });

  @override
  State createState() => _CanvasBoardState();
}

class _CanvasBoardState extends State<_CanvasBoard> {
  CanvasTools _currentTool = CanvasTools.MOVE;

  Offset _selectionStart = null;
  Offset _selectionEnd = null;

  Offset _dragStart = Offset.zero;
  Offset _lastDrag = Offset.zero;

  double _translateX = 0.0;
  double _translateY = 0.0;

  double _scale = 1.0;

  void _handleMove(DragUpdateDetails details) {
    setState(() {
      final x = details.localPosition.dx - _lastDrag.dx;
      final y = details.localPosition.dy - _lastDrag.dy;

      if (_currentTool == CanvasTools.MOVE) {
        _translateX += x;
        _translateY += y;
      }

      _lastDrag = details.localPosition;
    });
  }

  Offset _calculateIndexClick(Offset offset) {
    final int x = ((offset.dx - _translateX) /  (widget.tileSize * _scale)).floor();
    final int y = ((offset.dy - _translateY) /  (widget.tileSize * _scale)).floor();

    return Offset(x.toDouble(), y.toDouble());
  }

  void _handleMoveEnd() {
    setState(() {
      if (_currentTool == CanvasTools.MOVE) {
        _lastDrag = _dragStart = null;
      }
    });
  }

  void _handleMoveStart(DragStartDetails details) {
    setState(() {
      _lastDrag = _dragStart = details.localPosition;

      if (_currentTool == CanvasTools.SELECTION) {
        print(_calculateIndexClick(_dragStart));
      }
    });
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
                          tileSize: widget.tileSize,
                          selectionStart: _selectionStart,
                          selectionEnd: _selectionEnd,
                      ),
                  ),
                  onPanStart: (details) {
                    _handleMoveStart(details);
                  },
                  onPanUpdate: (details) {
                    _handleMove(details);
                  },
                  onPanEnd: (details) {
                    _handleMoveEnd();
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
  final int tileSize;
  final Offset selectionStart;
  final Offset selectionEnd;

  _CanvasSprite({
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
      canvas.drawRect(
          Rect.fromLTWH(
              (_selectionStart.dx * _tileSize),
              (_selectionStart.dy * _tileSize),
              (_selectionEnd.dx * _tileSize),
              (_selectionEnd.dy * _tileSize),
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
