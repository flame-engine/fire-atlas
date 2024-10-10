import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/change_image_modal.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/concat_image_modal.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/rename_atlas_modal.dart';
import 'package:fire_atlas_editor/screens/widgets/toggle_theme_button.dart';
import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _ToolbarSlice extends Equatable {
  final FireAtlas? currentAtlas;
  final String? lastUsedImage;
  final bool hasChanges;

  _ToolbarSlice.fromState(FireAtlasState state)
      : currentAtlas = state.currentAtlas,
        lastUsedImage = state.loadedProject.value?.lastUsedImage,
        hasChanges = state.hasChanges;

  @override
  List<Object?> get props => [
        currentAtlas?.id,
        lastUsedImage,
        hasChanges,
      ];
}

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  Future<void> _launchURL(FireAtlas atlas) async {
    final bytes = atlas.serialize();
    final fileName = '${atlas.id}.fa';

    final storage = FireAtlasStorage();
    await storage.exportFile(bytes, fileName);
  }

  @override
  Widget build(BuildContext ctx) {
    return SliceWatcher<FireAtlasState, _ToolbarSlice>(
      slicer: _ToolbarSlice.fromState,
      builder: (ctx, store, slice) => FContainer(
        height: 60,
        child: Column(
          children: [
            FLabel(
              label: 'Working on: ${slice.currentAtlas?.id}',
              fontSize: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FIconButton(
                      iconData: Icons.save,
                      disabled: !slice.hasChanges,
                      onPress: () {
                        store.dispatchAsync(SaveAction());
                      },
                      tooltip: 'Save project',
                    ),
                    FIconButton(
                      iconData: Icons.edit,
                      onPress: () {
                        store.dispatch(
                          OpenEditorModal(
                            RenameAtlasModal(
                              currentName: store.state.currentAtlas?.id,
                            ),
                            400,
                            500,
                          ),
                        );
                      },
                      tooltip: 'Rename project',
                    ),
                    FIconButton(
                      iconData: Icons.image,
                      onPress: () {
                        store.dispatch(
                          OpenEditorModal(
                            const ChangeImageModal(),
                            400,
                            500,
                          ),
                        );
                      },
                      tooltip: 'Update base image',
                    ),
                    if (!kIsWeb)
                      FIconButton(
                        disabled: slice.lastUsedImage == null,
                        iconData: Icons.fireplace,
                        onPress: () {
                          store.dispatchAsync(QuickReplaceImageAction());
                        },
                        tooltip: 'Quick replace base image',
                      ),
                    FIconButton(
                      iconData: Icons.add_photo_alternate,
                      onPress: () {
                        store.dispatch(
                          OpenEditorModal(
                            const ConcatImageModal(),
                            600,
                            500,
                          ),
                        );
                      },
                      tooltip: 'Add image',
                    ),
                    if (kIsWeb)
                      FIconButton(
                        iconData: Icons.get_app,
                        onPress: () {
                          _launchURL(slice.currentAtlas!);
                        },
                        tooltip: 'Export atlas',
                      ),
                  ],
                ),
                Row(
                  children: [
                    const ToggleThemeButton(),
                    FIconButton(
                      iconData: Icons.exit_to_app,
                      onPress: () {
                        store.dispatch(SelectSelectionAction());
                        Navigator.of(ctx).pushReplacementNamed('/');
                      },
                      tooltip: 'Close atlas',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
