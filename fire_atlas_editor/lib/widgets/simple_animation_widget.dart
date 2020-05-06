import 'package:flutter/material.dart' hide Animation;
import 'package:flame/animation.dart';

import './simple_sprite_widget.dart';

import 'dart:math';

class SimpleAnimationLoaderWidget extends StatelessWidget {
  final Future<Animation> future;
  final bool center;

  SimpleAnimationLoaderWidget({
    this.future,
    this.center = false,
  });

  @override
  Widget build(ctx) {
    return FutureBuilder(
        future: future,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return AnimationPlayerWidget(animation: snapshot.data);
          }

          if (snapshot.hasError)
            return Text('Something went wrong :(');

          return Text('Loading...');
        }
    );
  }
}

class AnimationPlayerWidget extends StatefulWidget {
  final Animation animation;

  AnimationPlayerWidget({
    this.animation,
  });

  @override
  State createState() => _AnimationPlayerWidget();
}

class _AnimationPlayerWidget extends State<AnimationPlayerWidget> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  int _lastUpdated;

  @override
  void initState() {
    super.initState();

    _lastUpdated = DateTime.now().millisecond;
    _controller = AnimationController(
        vsync: this
    )
    ..addListener(() {
      final now = DateTime.now().millisecond;

      final dt = max(0, (now - _lastUpdated) / 1000);
      widget.animation.update(dt);

      setState(() {
        _lastUpdated = now;
      });
    })
    ..repeat(
        // -/+ 60 fps
        period: Duration(milliseconds: 16)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(ctx) {
    //return Stack(children: [
      return SimpleSpriteWidget(sprite: widget.animation.getSprite(), center: true);
    //]);
  }
}
