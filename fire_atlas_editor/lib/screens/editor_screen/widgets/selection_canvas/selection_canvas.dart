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
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) => FContainer(child: FutureBuilder(
            future: Flame.images.fromBase64(
                store.state.currentAtlas.id,
                store.state.currentAtlas.imageData,
            ),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return LayoutBuilder(
                    builder: (ctx, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return CanvasBoard(
                          sprite: Sprite.fromImage(snapshot.data),
                          size: size,
                          tileHeight: store.state.currentAtlas.tileHeight,
                          tileWidth: store.state.currentAtlas.tileWidth,
                      );
                    },
                );
              } else if (snapshot.hasError) {
                return Text('Something wrong happened :(');
              }
              return Text('Something wrong happened :(');
            }
        ))
    );
  }
}


