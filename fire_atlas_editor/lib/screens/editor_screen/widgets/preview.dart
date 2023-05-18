import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:fire_atlas_editor/widgets/simple_animation_widget.dart';
import 'package:fire_atlas_editor/widgets/simple_sprite_widget.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _PreviewSlice extends Equatable {
  final FireAtlas? currentAtlas;
  final BaseSelection? selectedSelection;
  final String? currentImage;

  const _PreviewSlice(
    this.currentAtlas,
    this.selectedSelection,
    this.currentImage,
  );

  _PreviewSlice.fromState(FireAtlasState state)
      : this(
          state.currentAtlas,
          state.selectedSelection,
          state.currentAtlas?.imageData,
        );

  @override
  List<Object?> get props =>
      [currentAtlas?.id, selectedSelection?.id, currentImage];
}

class Preview extends StatelessWidget {
  const Preview({super.key});

  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _PreviewSlice>(
      slicer: _PreviewSlice.fromState,
      builder: (ctx, store, slice) {
        Widget child = const Center(child: Text('Nothing selected'));
        final currentAtlas = slice.currentAtlas!;

        if (store.state.selectedSelection != null) {
          if (store.state.selectedSelection is SpriteSelection) {
            child = SimpleSpriteWidget(
              center: true,
              sprite: currentAtlas.getSprite(store.state.selectedSelection!.id),
            );
          } else if (slice.selectedSelection is AnimationSelection) {
            child = AnimationPlayerWidget(
              animation: currentAtlas.getAnimation(slice.selectedSelection!.id),
            );
          }
        }

        return FContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FSubtitleTitle(title: 'Preview'),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
