import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:html';

import '../../../vendor/slices/slices.dart';
import '../../../store/store.dart';
import '../../../store/actions/atlas_actions.dart';
import '../../../store/actions/editor_actions.dart';

import './change_image_modal.dart';
import './concat_image_modal.dart';

import '../../../widgets/container.dart';
import '../../../widgets/icon_button.dart';
import '../../../widgets/text.dart';

class _ToolbarSlice extends Equatable {
  final FireAtlas? currentAtlas;
  final bool hasChanges;

  _ToolbarSlice.fromState(FireAtlasState state)
      : currentAtlas = state.currentAtlas,
        hasChanges = state.hasChanges;

  @override
  List<Object?> get props => [currentAtlas?.id, hasChanges];
}

class Toolbar extends StatelessWidget {
  _launchURL(FireAtlas atlas) async {
    List<int> bytes = atlas.serialize();
    final fileName = '${atlas.id}.fa';

    final storage = FireAtlasStorage();
    await storage.exportFile(bytes, fileName);
  }

  @override
  Widget build(ctx) {
    return SliceWatcher<FireAtlasState, _ToolbarSlice>(
      slicer: (state) => _ToolbarSlice.fromState(state),
      builder: (ctx, store, slice) => FContainer(
        height: 60,
        child: Column(
          children: [
            FLabel(
                label: 'Working on: ${slice.currentAtlas?.id}', fontSize: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                FIconButton(
                    iconData: Icons.save,
                    disabled: !slice.hasChanges,
                    onPress: () {
                      store.dispatch(SaveAction());
                    }),
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
                    }),
                FIconButton(
                    iconData: Icons.add_photo_alternate,
                    onPress: () {
                      store.dispatch(
                        OpenEditorModal(
                          ConcatImageModal(),
                          600,
                          500,
                        ),
                      );
                    }),
                if (kIsWeb)
                  FIconButton(
                      iconData: Icons.get_app,
                      onPress: () {
                        _launchURL(slice.currentAtlas!);
                      }),
              ]),
              FIconButton(
                iconData: Icons.exit_to_app,
                onPress: () {
                  store.dispatch(SelectSelectionAction(selection: null));
                  Navigator.of(ctx).pushReplacementNamed('/');
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
