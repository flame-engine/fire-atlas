import 'package:flutter/material.dart';
import 'package:flame/anchor.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final atlas = await FireAtlas.fromAsset('caveace.fa');

    final game = ExampleGame(atlas);
    runApp(game.widget);
  } catch(e) {
    print(e);
  }
}

class ExampleGame extends BaseGame with TapDetector {
  FireAtlas _atlas;

  ExampleGame(this._atlas) {
    add(
        AnimationComponent(
            150,
            100,
            _atlas.getAnimation('shooting_ptero')
        )..y = 50
    );

    add(
        AnimationComponent(
            150,
            100,
            _atlas.getAnimation('bomb_ptero')
        )
          ..y = 50
          ..x = 200
    );

    add(
        SpriteComponent.fromSprite(
            50, 50, _atlas.getSprite('bullet')
        )..y = 200,
    );

    add(
        SpriteComponent.fromSprite(
            50, 50, _atlas.getSprite('shield')
        )
        ..x = 100
        ..y = 200,
    );

    add(
        SpriteComponent.fromSprite(
            50, 50, _atlas.getSprite('ham')
        )
        ..x = 200
        ..y = 200,
    );
  }

  @override
  void onTapUp(details) {
    final o = details.localPosition;

    add(
        AnimationComponent(
            100,
            100,
            _atlas.getAnimation('explosion'),
            destroyOnFinish: true,
        )
        ..anchor = Anchor.center
        ..x = o.dx
        ..y = o.dy
    );
  }
}

