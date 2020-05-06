import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/animation.dart';

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
  double stepTime;
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

  Future<Animation> getAnimation(String selectionId) async {
    final selection = selections[selectionId];

    assert(selection != null, 'There is no selection with the id "$selectionId" on this atlas');
    assert(selection is AnimationSelection, 'Selection "$selectionId" is not an Animation');

    final image = await Flame.images.fromBase64(id, imageData);

    final initialX = selection.x.toDouble();

    final animationSelection = selection as AnimationSelection;

    final frameSize = (1 + selection.w.toDouble()) / animationSelection.frameCount;

    final width = frameSize * tileSize;
    final height = (1 + selection.h.toDouble()) * tileSize;

    final sprites = List.generate(animationSelection.frameCount, (i) {
      final x = (initialX + i) * frameSize;
      return Sprite.fromImage(
         image,
         x: x * tileSize,
         y: selection.y.toDouble() * tileSize,
         width: width,
         height: height,
      );
    });

    return Animation.spriteList(
        sprites,
        stepTime: animationSelection.stepTime,
        loop: animationSelection.loop,
    );
  }
}
