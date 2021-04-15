import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

import 'dart:html';
import 'dart:ui';

import './container.dart';
import './simple_sprite_widget.dart';
import './button.dart';

typedef OnSelectImage = void Function(String);

class ImageSelectionContainer extends StatelessWidget {
  final String? imageData;
  final OnSelectImage onSelectImage;
  final EdgeInsets margin;

  ImageSelectionContainer({
    this.imageData,
    required this.onSelectImage,
    this.margin =
        const EdgeInsets.only(left: 30, right: 2.5, top: 2.5, bottom: 2.5),
  });

  @override
  Widget build(context) {
    return Column(children: [
      Expanded(
        child: FContainer(
          margin: margin,
          child: imageData != null
              ? FutureBuilder<Image>(
                  // todo image name
                  future: Flame.images.fromBase64('', imageData!),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      Flame.images.clearCache();
                      return SizedBox(
                        width: 200,
                        child: SimpleSpriteWidget(
                          sprite: Sprite(snapshot.data!),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Something wrong happened :(');
                    } else {
                      return Text('Loading');
                    }
                  })
              : Center(child: Text('No image selected')),
        ),
      ),
      Container(
          child: FButton(
              label: 'Select image',
              onSelect: () async {
                final storage = FireAtlasStorage();
                final imgDataUrl = await storage.selectFile(context);
                onSelectImage(imgDataUrl);
              }))
    ]);
  }
}
