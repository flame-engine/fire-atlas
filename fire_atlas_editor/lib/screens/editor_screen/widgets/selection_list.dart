import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/delete_selection_modal.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/selection_canvas/selection_form.dart';
import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/container.dart';
import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _SelectionListSlice extends Equatable {
  final FireAtlas? currentAtlas;
  final BaseSelection? selectedSelection;

  const _SelectionListSlice(this.currentAtlas, this.selectedSelection);

  @override
  List<Object?> get props => [currentAtlas?.id, selectedSelection?.id];
}

class SelectionList extends StatelessWidget {
  const SelectionList({super.key});

  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _SelectionListSlice>(
      slicer: (state) => _SelectionListSlice(
        state.currentAtlas,
        state.selectedSelection,
      ),
      builder: (ctx, store, slice) {
        final currentAtlas = slice.currentAtlas;

        if (currentAtlas == null) {
          return const Text('No atlas selected');
        }

        void select(BaseSelection selection) =>
            store.dispatch(SelectSelectionAction(selection: selection));

        return FContainer(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FSubtitleTitle(title: 'Selections'),
                ...currentAtlas.selections.isEmpty
                    ? [const FLabel(label: 'No selections yet')]
                    : currentAtlas.selections.values
                        .map((selection) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Theme.of(ctx).dividerColor,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () => select(selection),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selection.id,
                                      style: TextStyle(
                                        fontWeight:
                                            (slice.selectedSelection?.id ==
                                                    selection.id)
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (selection is AnimationSelection)
                                        FIconButton(
                                          iconData: Icons.edit,
                                          onPress: () {
                                            select(selection);
                                            store.dispatch(
                                              OpenEditorModal(
                                                SelectionForm(
                                                  editingSelection: selection,
                                                ),
                                                400,
                                                500,
                                              ),
                                            );
                                          },
                                          tooltip: 'Edit selection',
                                        )
                                      else
                                        Container(),
                                      FIconButton(
                                        iconData: Icons.cancel,
                                        onPress: () {
                                          select(selection);
                                          store.dispatch(
                                            OpenEditorModal(
                                              const DeleteSelectionModal(),
                                              300,
                                              200,
                                            ),
                                          );
                                        },
                                        tooltip: 'Edit selection',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList()
                        .cast<Widget>()
              ],
            ),
          ),
        );
      },
    );
  }
}
