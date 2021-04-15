import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/vendor/slices/slices.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import '../../../../widgets/container.dart';

import './canvas_board.dart';

import 'dart:ui';

class SelectionCanvas extends StatelessWidget {
  @override
  Widget build(context) {
    final store = SlicesProvider.of<FireAtlasState>(context);
    final atlas = store.state.currentAtlas;

    if (atlas == null) {
      return Text('No atlas selected');
    }

    return FContainer(
      child: FutureBuilder<Image>(
        future: Flame.images.fromBase64(
          atlas.id,
          atlas.imageData!,
        ),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(
              builder: (ctx, constraints) {
                final size = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return CanvasBoard(
                  sprite: Sprite(snapshot.data!),
                  size: size,
                  tileHeight: atlas.tileHeight,
                  tileWidth: atlas.tileWidth,
                );
              },
            );
          }
          return Text('Something wrong happened :(');
        },
      ),
    );
  }
}
