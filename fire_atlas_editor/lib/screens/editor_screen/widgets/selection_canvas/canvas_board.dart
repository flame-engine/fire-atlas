import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

import '../../../../widgets/button.dart';

import './canvas_sprite.dart';
import './selection_create_form.dart';

enum CanvasTools {
  SELECTION,
  MOVE,
}


class CanvasBoard extends StatefulWidget {
  final Sprite sprite;
  final Size size;
  final int tileSize;

  CanvasBoard({ this.sprite, this.size, this.tileSize });

  @override
  State createState() => CanvasBoardState();
}

class CanvasBoardState extends State<CanvasBoard> {
  CanvasTools _currentTool = CanvasTools.SELECTION;

  Offset _selectionStart;
  Offset _selectionEnd;

  Offset _dragStart = Offset.zero;
  Offset _lastDrag = Offset.zero;

  double _translateX = 0.0;
  double _translateY = 0.0;

  double _scale = 1.0;

  Offset _calculateIndexClick(Offset offset) {
    final int x = ((offset.dx - _translateX) /  (widget.tileSize * _scale)).floor();
    final int y = ((offset.dy - _translateY) /  (widget.tileSize * _scale)).floor();

    return Offset(x.toDouble(), y.toDouble());
  }

  void _handleMove(DragUpdateDetails details) {
    setState(() {
      final x = details.localPosition.dx - _lastDrag.dx;
      final y = details.localPosition.dy - _lastDrag.dy;

      if (_currentTool == CanvasTools.MOVE) {
        _translateX += x;
        _translateY += y;
      } else if (_currentTool == CanvasTools.SELECTION) {
        _selectionEnd = _calculateIndexClick(details.localPosition);
      }

      _lastDrag = details.localPosition;
    });
  }

  void _handleMoveEnd() {
    setState(() {
      if (_currentTool == CanvasTools.SELECTION) {
        _selectionEnd = _calculateIndexClick(_lastDrag);
      }
      _lastDrag = _dragStart = null;
    });
  }

  void _handleMoveStart(DragStartDetails details) {
    setState(() {
      _lastDrag = _dragStart = details.localPosition;

      if (_currentTool == CanvasTools.SELECTION) {
        _selectionStart = _calculateIndexClick(_dragStart);
        _selectionEnd = _selectionStart;
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

  void _createItem() {
    if (_selectionStart != null && _selectionEnd != null) {
      showModalBottomSheet(
          context: context,
          isDismissible: true,
          builder: (builder) {
            return SelectionCreateForm(
                selectionStart: _selectionStart,
                selectionEnd: _selectionEnd,
            );
          }
      );
    }
  }

  @override
  Widget build(ctx) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              children: [
                FButton(
                    onSelect: () =>  setState(() => _currentTool = CanvasTools.SELECTION),
                    label: 'Selection',
                    selected: _currentTool == CanvasTools.SELECTION
                ),
                FButton(
                    onSelect: () =>  setState(() => _currentTool = CanvasTools.MOVE),
                    label: 'Move',
                    selected: _currentTool == CanvasTools.MOVE
                ),
                FButton(
                    onSelect: _zoomIn,
                    label: 'Zoom In',
                ),
                FButton(
                    onSelect: _zoomOut,
                    label: 'Zoom Out',
                ),
                FButton(
                    onSelect: _createItem,
                    label: 'Create item',
                ),
              ],
          ),
          Expanded(
              child: GestureDetector(
                  child: ClipRect(
                      child: CanvasSprite(
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
