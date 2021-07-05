import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

const _lowcaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const _upcaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

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

    _controller.addListener(() {
      _calculateSelections();
    });
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

    int x = 0;
    int y = 0;

    _controller.text.characters.forEach((e) {
      final selection = SpriteSelection(
        info: Selection(
          id: e,
          x: (x * _currentAtlas.tileWidth).toInt(),
          y: (y * _currentAtlas.tileHeight).toInt(),
          w: _currentAtlas.tileWidth.toInt(),
          h: _currentAtlas.tileHeight.toInt(),
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
          FSubtitleTitle(title: 'Map Bitmap Font'),
          SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Characters'),
          ),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FButton(
                    label: 'Lower case letters',
                    onSelect: () {
                      _controller.text += _lowcaseLetters;
                    },
                ),
                FButton(
                    label: 'Upper case letters',
                    onSelect: () {
                      _controller.text += _upcaseLetters;
                    },
                ),
              ],
          ),
          Text('Preview'),
          SizedBox(height: 40),
          Expanded(
              child: CustomPaint(
            painter: _AutoMapPreviewPainter(
                widget.currentSprite, _currentSelections),
          )),
        ],
      ),
    );
  }
}

class _AutoMapPreviewPainter extends CustomPainter {
  static Paint _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  final TextConfig _config = TextConfig(fontSize: 10, color: _paint.color);

  final Sprite sprite;
  final List<SpriteSelection> selections;

  _AutoMapPreviewPainter(this.sprite, this.selections);

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
        selection.x.toDouble(),
        selection.y.toDouble(),
        selection.w.toDouble(),
        selection.h.toDouble(),
      );

      canvas.drawRect(rect, _paint);
      _config.render(
        canvas,
        selection.id,
        Vector2(
          rect.right - _config.fontSize / 2,
          rect.top - _config.fontSize - 1,
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
