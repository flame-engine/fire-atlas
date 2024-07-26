import 'dart:math';

import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:fire_atlas_editor/widgets/simple_sprite_widget.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Animation;

class SimpleAnimationLoaderWidget extends StatelessWidget {
  final Future<SpriteAnimation> future;

  const SimpleAnimationLoaderWidget({
    required this.future,
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder<SpriteAnimation>(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return AnimationPlayerWidget(animation: snapshot.data!);
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong :(');
        }

        return const Text('Loading...');
      },
    );
  }
}

class AnimationPlayerWidget extends StatefulWidget {
  final SpriteAnimation animation;

  const AnimationPlayerWidget({
    required this.animation,
    super.key,
  });

  @override
  State createState() => _AnimationPlayerWidget();
}

class _AnimationPlayerWidget extends State<AnimationPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _lastUpdated = 0;
  bool _playing = false;

  late final SpriteAnimationTicker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = widget.animation.createTicker();

    _controller = AnimationController(vsync: this)
      ..addListener(() {
        final now = DateTime.now().millisecond;

        final double dt = max(0, (now - _lastUpdated) / 1000);
        _ticker.update(dt);

        setState(() {
          _lastUpdated = now;
        });
      });

    _ticker.onComplete = _pauseAnimation;
  }

  void _initAnimation() {
    setState(() {
      _ticker.reset();
      _playing = true;
      _lastUpdated = DateTime.now().millisecond;
      _controller.repeat(
        // -/+ 60 fps
        period: const Duration(milliseconds: 16),
      );
    });
  }

  void _pauseAnimation() {
    setState(() {
      _playing = false;
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Stack(
      children: [
        Positioned.fill(
          child: SimpleSpriteWidget(
            sprite: _ticker.getSprite(),
            center: true,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              FIconButton(
                iconData: Icons.play_arrow,
                onPress: _initAnimation,
                disabled: _playing,
                tooltip: 'Play',
              ),
              FIconButton(
                iconData: Icons.stop,
                onPress: _pauseAnimation,
                disabled: !_playing,
                tooltip: 'Stop',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
