import 'package:flutter/material.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:html';
import 'dart:typed_data';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';
import '../../../store/actions/atlas_actions.dart';
import '../../../store/actions/editor_actions.dart';

import './change_image_modal.dart';

import '../../../widgets/container.dart';
import '../../../widgets/icon_button.dart';
import '../../../widgets/text.dart';

class Toolbar extends StatelessWidget {

  _launchURL(FireAtlas atlas) async {
    final element = document.createElement('a');

    List<int> bytes = atlas.serialize();
    final uint8List = Uint8List.fromList(bytes);
    final blob = Blob([uint8List]);
    final url = Url.createObjectUrl(blob);
    element.setAttribute('href', url);
    element.setAttribute('download', '${atlas.id}.fa');

    element.click();
  }

  @override
  Widget build(ctx) {
    return MicroStoreProvider<FireAtlasState>(
        store: Store.instance,
        builder: (ctx, store) => FContainer(
            height: 60,
            child: Column(
                children: [
                  FLabel(label: 'Working on: ${store.state.currentAtlas?.id}', fontSize: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: [
                              FIconButton(
                                  iconData: Icons.save,
                                  disabled: !store.state.hasChanges,
                                  onPress: () {
                                    store.dispatch(SaveAction());
                                  }
                              ),
                              FIconButton(
                                  iconData: Icons.image,
                                  onPress: () {
                                    store.dispatch(
                                        OpenEditorModal(
                                            ChangeImageModal(),
                                            400,
                                            500,
                                        ),
                                    );
                                  }
                              ),
                              FIconButton(
                                  iconData: Icons.get_app,
                                  onPress: () {
                                    _launchURL(store.state.currentAtlas);
                                  }
                              ),
                            ]
                        ),
                        FIconButton(
                            iconData: Icons.exit_to_app,
                            onPress: () {
                              Navigator.of(ctx).pushReplacementNamed('/');
                            },
                        ),
                      ]
                  ),
                ],
            ),
        ),
    );
  }
}
