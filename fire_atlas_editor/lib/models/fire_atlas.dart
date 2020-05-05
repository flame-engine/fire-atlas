import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

abstract class Selection {
  String id;
  int x;
  int y;
  int w;
  int h;
}

class SpriteSelection extends Selection { }

class AnimationSelection extends Selection {
  int frameCount;
  List<double> timeSteps = [];
  bool loop;
}

class FireAtlas {
  String id;
  int tileSize;
  String imageData;

  Map<String, Selection> selections = {};

  Future<Sprite> getSprite(String selectionId) async {
    final selection = selections[selectionId];

    assert(selection != null, 'There is no selection with the id "$selectionId" on this atlas');
    assert(selection is SpriteSelection, 'Selection "$selectionId" is not a Sprite');

    final image = await Flame.images.fromBase64(id, imageData);
    return Sprite.fromImage(
        image,
        x: selection.x.toDouble() * tileSize,
        y: selection.y.toDouble() * tileSize,
        width: (1 + selection.w.toDouble()) * tileSize,
        height:(1 + selection.h.toDouble()) * tileSize,
    );
  }
}
