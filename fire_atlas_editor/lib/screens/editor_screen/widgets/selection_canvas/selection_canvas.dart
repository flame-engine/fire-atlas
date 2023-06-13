import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/selection_canvas/canvas_board.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:slices/slices.dart';

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
  const SelectionCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return SliceWatcher<FireAtlasState, _SelectionCanvasSlice>(
      slicer: _SelectionCanvasSlice.fromState,
      builder: (context, store, slice) {
        if (!slice.isLoaded()) {
          return const Text('No atlas selected');
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
              return const Text('Something wrong happened :(');
            },
          ),
        );
      },
    );
  }
}
