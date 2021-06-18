import 'package:slices/slices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';

import '../../../../widgets/icon_button.dart';

import './canvas_sprite.dart';
import './selection_form.dart';

import '../../../../store/store.dart';
import '../../../../store/actions/editor_actions.dart';

enum CanvasTools {
  SELECTION,
  MOVE,
}

class CanvasBoard extends StatefulWidget {
  final Sprite sprite;
  final Size size;
  final double tileWidth;
  final double tileHeight;

  CanvasBoard({
    required this.sprite,
    required this.size,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  State createState() => CanvasBoardState();
}

class CanvasBoardState extends State<CanvasBoard> {
  CanvasTools _currentTool = CanvasTools.SELECTION;

  Offset? _selectionStart;
  Offset? _selectionEnd;

  Offset? _dragStart = Offset.zero;
  Offset? _lastDrag = Offset.zero;

  double _translateX = 0.0;
  double _translateY = 0.0;

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    _scale = (widget.size.width - 200) / widget.sprite.originalSize.x;

    final middleX = widget.size.width / 2;

    _translateX = middleX - (widget.sprite.originalSize.x * _scale) / 2;
    _translateY = 100;
  }

  void _finishSelection(Offset offset) {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    if (_selectionEnd != offset && _selectionStart != null) {
      final _start = _selectionStart!;
      final rect = Rect.fromLTWH(
        _start.dx * widget.tileWidth,
        _start.dy * widget.tileHeight,
        ((offset.dx - _start.dx) + 1) * widget.tileWidth,
        ((offset.dy - _start.dy) + 1) * widget.tileHeight,
      );
      _store.dispatch(SetCanvasSelection(rect));
    }
    _selectionEnd = offset;
  }

  Offset _calculateIndexClick(Offset offset) {
    final int x =
        ((offset.dx - _translateX) / (widget.tileWidth * _scale)).floor();
    final int y =
        ((offset.dy - _translateY) / (widget.tileHeight * _scale)).floor();

    return Offset(x.toDouble(), y.toDouble());
  }

  void _handleMove(DragUpdateDetails details) {
    final _last = _lastDrag;
    if (_last != null) {
      setState(() {
        final delta = details.localPosition - _last;

        if (_currentTool == CanvasTools.MOVE) {
          _translateX += delta.dx;
          _translateY += delta.dy;
        } else if (_currentTool == CanvasTools.SELECTION) {
          _finishSelection(_calculateIndexClick(details.localPosition));
        }

        _lastDrag = details.localPosition;
      });
    }
  }

  void _handleMoveEnd() {
    if (_lastDrag == null) {
      return;
    }
    final clickIndex = _calculateIndexClick(_lastDrag!);
    setState(() {
      if (_currentTool == CanvasTools.SELECTION) {
        _finishSelection(clickIndex);
      }
      _lastDrag = _dragStart = null;
    });
  }

  void _handleMoveStart(DragStartDetails details) {
    setState(() {
      _lastDrag = _dragStart = details.localPosition;

      if (_currentTool == CanvasTools.SELECTION) {
        _selectionStart = _calculateIndexClick(_dragStart!);
        _finishSelection(_selectionStart!);
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

  void _createItem() {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    if (_selectionStart != null && _selectionEnd != null) {
      _store.dispatch(OpenEditorModal(
        SelectionForm(
          selectionStart: _selectionStart!,
          selectionEnd: _selectionEnd!,
        ),
        400,
        600,
      ));
    } else {
      _store.dispatch(CreateMessageAction(
        type: MessageType.ERROR,
        message: 'Nothing is selected',
      ));
    }
  }

  @override
  Widget build(ctx) {
    List<Widget> children = [];

    children.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              FIconButton(
                  onPress: () =>
                      setState(() => _currentTool = CanvasTools.SELECTION),
                  iconData: Icons.select_all,
                  disabled: _currentTool == CanvasTools.SELECTION,
                  tooltip: 'Selection tool',
              ),
              FIconButton(
                  onPress: () =>
                      setState(() => _currentTool = CanvasTools.MOVE),
                  iconData: Icons.open_with,
                  disabled: _currentTool == CanvasTools.MOVE,
                  tooltip: 'Move tool',
              ),
              FIconButton(
                iconData: Icons.zoom_in,
                onPress: _zoomIn,
                tooltip: 'Zoom in',
              ),
              FIconButton(
                iconData: Icons.zoom_out,
                onPress: _zoomOut,
                tooltip: 'Zoom out',
              ),
              FIconButton(
                iconData: Icons.add_box,
                onPress: _createItem,
                tooltip: 'Create selection',
              ),
            ],
          ),
          Expanded(
            child: Listener(
              onPointerSignal: (s) {
                if (s is PointerScrollEvent) {
                  setState(() {
                    _translateX += s.scrollDelta.dx;
                    _translateY += s.scrollDelta.dy;
                  });
                }
              },
              child: GestureDetector(
                child: ClipRect(
                  child: CanvasSprite(
                    sprite: widget.sprite,
                    translateX: _translateX,
                    translateY: _translateY,
                    scale: _scale,
                    tileWidth: widget.tileWidth,
                    tileHeight: widget.tileHeight,
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
          ),
        ],
      ),
    );

    return Stack(children: children);
  }
}
