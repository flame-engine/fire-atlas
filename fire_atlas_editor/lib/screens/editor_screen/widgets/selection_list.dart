import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/delete_selection_modal.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/edit_selection_folder_modal.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/rename_selection_modal.dart';
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

  final List<(String, String?)> _selections;

  _SelectionListSlice(this.currentAtlas, this.selectedSelection)
      : _selections = currentAtlas?.selections.values
                .map((e) => (e.id, e.group))
                .toList() ??
            const [];

  @override
  List<Object?> get props => [
        currentAtlas?.id,
        selectedSelection?.id,
        _selections,
      ];
}

class SelectionList extends StatefulWidget {
  const SelectionList({super.key});

  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  final _openGroups = <String>[];

  @override
  Widget build(_) {
    return SliceWatcher<FireAtlasState, _SelectionListSlice>(
      slicer: (state) {
        return _SelectionListSlice(
          state.currentAtlas,
          state.selectedSelection,
        );
      },
      builder: (ctx, store, slice) {
        final currentAtlas = slice.currentAtlas;

        if (currentAtlas == null) {
          return const Text('No atlas selected');
        }

        void select(BaseSelection selection) =>
            store.dispatch(SelectSelectionAction(selection: selection));

        final groupedSelections = currentAtlas.selections.values.fold(
          <String, List<BaseSelection>>{},
          (map, selection) {
            final group = selection.group ?? '';
            if (!map.containsKey(group)) {
              map[group] = [];
            }

            map[group]!.add(selection);
            return map;
          },
        );

        final rootLevelGroup = groupedSelections[''] ?? <BaseSelection>[];

        final folders = Map.fromEntries(
          groupedSelections.entries
              .where((entry) => entry.key.isNotEmpty)
              .toList(),
        );

        return FContainer(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FSubtitleTitle(title: 'Selections'),
                    if (currentAtlas.selections.isEmpty)
                      const FLabel(label: 'No selections yet'),
                    for (final selection in rootLevelGroup)
                      _SelectionEntry(
                        selection: selection,
                        slice: slice,
                        select: select,
                        store: store,
                      ),
                    for (final folderEntry in folders.entries)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_openGroups.contains(folderEntry.key)) {
                                    _openGroups.remove(folderEntry.key);
                                  } else {
                                    _openGroups.add(folderEntry.key);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    _openGroups.contains(folderEntry.key)
                                        ? Icons.folder_open
                                        : Icons.folder,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(folderEntry.key),
                                ],
                              ),
                            ),
                            if (_openGroups.contains(folderEntry.key))
                              for (final selection in folderEntry.value)
                                _SelectionEntry(
                                  selection: selection,
                                  slice: slice,
                                  select: select,
                                  store: store,
                                ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SelectionEntry extends StatelessWidget {
  const _SelectionEntry({
    required this.selection,
    required this.slice,
    required this.select,
    required this.store,
  });

  final BaseSelection selection;
  final _SelectionListSlice slice;
  final void Function(BaseSelection) select;
  final SlicesStore<FireAtlasState> store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => select(selection),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selection.id,
                style: TextStyle(
                  fontWeight: (slice.selectedSelection?.id == selection.id)
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
                            editingSelection: selection as AnimationSelection,
                          ),
                          400,
                          500,
                        ),
                      );
                    },
                    tooltip: 'Edit selection',
                  ),
                FIconButton(
                  iconData: Icons.folder,
                  onPress: () {
                    store.dispatch(
                      OpenEditorModal(
                        EditSelectionFolderModal(
                          selectionId: selection.id,
                          folderId: selection.group,
                        ),
                        500,
                        280,
                      ),
                    );
                  },
                  tooltip: 'Move into Folder',
                ),
                FIconButton(
                  iconData: Icons.drive_file_rename_outline_sharp,
                  onPress: () {
                    select(selection);
                    store.dispatch(
                      OpenEditorModal(
                        RenameSelectionModal(
                          currentName: selection.id,
                        ),
                        300,
                        300,
                      ),
                    );
                  },
                  tooltip: 'Rename selection',
                ),
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
                  tooltip: 'Delete selection',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
