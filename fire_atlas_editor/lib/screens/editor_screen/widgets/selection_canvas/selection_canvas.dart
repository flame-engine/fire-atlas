import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import '../../../../widgets/container.dart';

import '../../../../vendor/micro_store/micro_store.dart';
import '../../../../store/store.dart';

import './canvas_board.dart';

class SelectionCanvas extends StatelessWidget {
  @override
  Widget build(_) {
    return FContainer(child: FutureBuilder(
        future: Flame.images.fromBase64(
            Store.instance.state.currentAtlas.id,
            Store.instance.state.currentAtlas.imageData,
        ),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return MicroStoreProvider(
                store: Store.instance,
                builder: (ctx, store) => LayoutBuilder(
                    builder: (ctx, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return CanvasBoard(
                          sprite: Sprite.fromImage(snapshot.data),
                          tileSize: store.state.currentAtlas.tileSize,
                          size: size,
                      );
                    },
                ),
            );
          } else if (snapshot.hasError) {
            return Text('Something wrong happened :(');
          }
          return Text('Something wrong happened :(');
        }
    ));
  }
}


