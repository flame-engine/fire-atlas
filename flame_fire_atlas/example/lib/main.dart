import 'package:flutter/material.dart';
import 'package:flame/anchor.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components/sprite_animation_component.dart';
import 'package:flame/components/sprite_component.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final game = ExampleGame();
    runApp(GameWidget(game: game));
  } catch (e) {
    print(e);
  }
}

class ExampleGame extends BaseGame with TapDetector {
  FireAtlas _atlas;

  @override
  Future<void> onLoad() async {
    _atlas = await loadFireAtlas('caveace.fa');
    add(
      SpriteAnimationComponent(
        Vector2(150, 100),
        _atlas.getAnimation('shooting_ptero'),
      )..y = 50,
    );

    add(SpriteAnimationComponent(
      Vector2(150, 100),
      _atlas.getAnimation('bomb_ptero'),
    )
      ..y = 50
      ..x = 200);

    add(
      SpriteComponent.fromSprite(Vector2(50, 50), _atlas.getSprite('bullet'))
        ..y = 200,
    );

    add(
      SpriteComponent.fromSprite(Vector2(50, 50), _atlas.getSprite('shield'))
        ..x = 100
        ..y = 200,
    );

    add(
      SpriteComponent.fromSprite(Vector2(50, 50), _atlas.getSprite('ham'))
        ..x = 200
        ..y = 200,
    );
  }

  @override
  void onTapUp(details) {
    final o = details.localPosition;

    add(SpriteAnimationComponent(
      Vector2(100, 100),
      _atlas.getAnimation('explosion'),
      removeOnFinish: true,
    )
      ..anchor = Anchor.center
      ..x = o.dx
      ..y = o.dy);
  }
}
