import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:slices/slices.dart';

import '../../../widgets/text.dart';
import '../../../widgets/container.dart';
import '../../../widgets/simple_sprite_widget.dart';
import '../../../widgets/simple_animation_widget.dart';

import '../../../store/store.dart';

class _PreviewSlice extends Equatable {
  final FireAtlas? currentAtlas;
  final BaseSelection? selectedSelection;

  _PreviewSlice(this.currentAtlas, this.selectedSelection);

  _PreviewSlice.fromState(FireAtlasState state)
      : this(state.currentAtlas, state.selectedSelection);

  @override
  List<Object?> get props => [currentAtlas?.id, selectedSelection?.id];
}

class Preview extends StatelessWidget {
  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _PreviewSlice>(
      slicer: (state) => _PreviewSlice.fromState(state),
      builder: (ctx, store, slice) {
        Widget child = Center(child: Text('Nothing selected'));
        final currentAtlas = slice.currentAtlas!;

        if (store.state.selectedSelection != null) {
          if (store.state.selectedSelection is SpriteSelection) {
            child = SimpleSpriteWidget(
                center: true,
                sprite:
                    currentAtlas.getSprite(store.state.selectedSelection!.id));
          } else if (slice.selectedSelection is AnimationSelection) {
            child = AnimationPlayerWidget(
                animation:
                    currentAtlas.getAnimation(slice.selectedSelection!.id));
          }
        }

        return FContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FSubtitleTitle(title: 'Preview'),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
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
