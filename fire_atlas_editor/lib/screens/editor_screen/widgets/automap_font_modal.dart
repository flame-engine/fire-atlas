import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

const _lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const _uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class AutoMapFontModal extends StatefulWidget {
  final Sprite currentSprite;

  const AutoMapFontModal({
    Key? key,
    required this.currentSprite,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AutoMapFontModalState();
  }
}

class _AutoMapFontModalState extends State<AutoMapFontModal> {
  late final TextEditingController _controller;
  late FireAtlas _currentAtlas;

  List<SpriteSelection> _currentSelections = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(_calculateSelections);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final _store = SlicesProvider.of<FireAtlasState>(context);

    final atlas = _store.state.currentAtlas;

    if (atlas == null) {
      throw "Can't map a bitmap font without a atlas selected";
    }

    _currentAtlas = atlas;
  }

  void _calculateSelections() {
    final _selections = <SpriteSelection>[];

    var x = 0;
    var y = 0;

    _controller.text.characters.forEach((e) {
      if (x * _currentAtlas.tileWidth >= widget.currentSprite.image.width) {
        x = 0;
        y++;
      }

      final selection = SpriteSelection(
        info: Selection(
          id: e,
          x: x,
          y: y,
          w: 0,
          h: 0,
        ),
      );

      x++;

      _selections.add(selection);
    });

    setState(() {
      _currentSelections = _selections;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FSubtitleTitle(title: 'Map Bitmap Font'),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Characters'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FButton(
                label: 'Lower case letters',
                onSelect: () {
                  _controller.text += _lowercaseLetters;
                },
              ),
              FButton(
                label: 'Upper case letters',
                onSelect: () {
                  _controller.text += _uppercaseLetters;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const FSubtitleTitle(title: 'Preview'),
          Expanded(
            child: CustomPaint(
              painter: _AutoMapPreviewPainter(
                widget.currentSprite,
                _currentSelections,
                _currentAtlas.tileWidth,
                _currentAtlas.tileHeight,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: () {
                  _store.dispatch(CloseEditorModal());
                },
              ),
              const SizedBox(width: 20),
              FButton(
                label: 'Confirm',
                selected: true,
                onSelect: () {
                  _store.dispatch(
                    SetSelectionAction.multiple(
                      selections: _currentSelections,
                    ),
                  );
                  _store.dispatch(CloseEditorModal());
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AutoMapPreviewPainter extends CustomPainter {
  static final Paint _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  final TextPaint _config = TextPaint(
    style: TextStyle(
      fontSize: 8,
      color: _paint.color,
    ),
  );

  final Sprite sprite;
  final List<SpriteSelection> selections;

  final double tileWidth;
  final double tileHeight;

  _AutoMapPreviewPainter(
    this.sprite,
    this.selections,
    this.tileWidth,
    this.tileHeight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final scale = sprite.image.width > sprite.image.height
        ? size.width / sprite.image.width
        : size.height / sprite.image.height;

    canvas.save();
    canvas.scale(scale);

    sprite.render(canvas);

    selections.forEach((selection) {
      final rect = Rect.fromLTWH(
        selection.x.toDouble() * tileWidth,
        selection.y.toDouble() * tileHeight,
        (selection.w.toDouble() * tileWidth) + tileWidth,
        (selection.h.toDouble() * tileHeight) + tileHeight,
      );

      canvas.drawRect(rect, _paint);
      _config.render(
        canvas,
        selection.id,
        Vector2(
          rect.left + 2,
          rect.top + 2,
        ),
      );
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(_AutoMapPreviewPainter oldDelegate) {
    return selections != oldDelegate.selections;
  }
}
