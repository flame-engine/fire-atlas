import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:slices/slices.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import '../../../../widgets/container.dart';

import './canvas_board.dart';

import 'dart:ui';

class _SelectionCanvasSlice extends Equatable {
  final String? atlasId;
  final String? imageData;
  final double? tileHeight;
  final double? tileWidth;

  _SelectionCanvasSlice.fromState(FireAtlasState state)
      : atlasId = state.currentAtlas?.id,
        imageData = state.currentAtlas?.imageData,
        tileWidth = state.currentAtlas?.tileWidth,
        tileHeight = state.currentAtlas?.tileHeight;

  @override
  List<Object?> get props => [atlasId, imageData, tileHeight, tileWidth];

  bool isLoaded() => atlasId != null;
}

class SelectionCanvas extends StatelessWidget {
  @override
  Widget build(context) {
    return SliceWatcher<FireAtlasState, _SelectionCanvasSlice>(
      slicer: (state) => _SelectionCanvasSlice.fromState(state),
      builder: (context, store, slice) {
        if (!slice.isLoaded()) {
          return Text('No atlas selected');
        }

        return FContainer(
          child: FutureBuilder<Image>(
            future: Flame.images.fromBase64(
              slice.atlasId!,
              slice.imageData!,
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
                      tileHeight: slice.tileHeight!,
                      tileWidth: slice.tileWidth!,
                    );
                  },
                );
              }
              return Text('Something wrong happened :(');
            },
          ),
        );
      },
    );
  }
}
