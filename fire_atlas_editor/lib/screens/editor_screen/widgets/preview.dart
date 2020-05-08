import 'package:flutter/material.dart';

import '../../../widgets/text.dart';
import '../../../widgets/container.dart';
import '../../../widgets/simple_sprite_widget.dart';
import '../../../widgets/simple_animation_widget.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';
import '../../../models/fire_atlas.dart';

class Preview extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider(
        store: Store.instance,
        builder: (ctx, store) {

          Widget child = Center(child: Text('Nothing selected'));

          if (store.state.selectedSelection != null) {
            if (store.state.selectedSelection is SpriteSelection) {
              child = SimpleSpriteLoaderWidget(
                  center: true,
                  future: store.state.currentAtlas.getSprite(store.state.selectedSelection.id)
              );
            } else if (store.state.selectedSelection is AnimationSelection) {
              child = SimpleAnimationLoaderWidget(
                  center: true,
                  future: store.state.currentAtlas.getAnimation(store.state.selectedSelection.id)
              );
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
        }
    );
  }
}
