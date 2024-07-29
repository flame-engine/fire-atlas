import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class EditSelectionFolderModal extends StatefulWidget {
  const EditSelectionFolderModal({
    required this.selectionId,
    this.folderId,
    super.key,
  });

  final String selectionId;
  final String? folderId;

  @override
  State<EditSelectionFolderModal> createState() =>
      _EditSelectionFolderModalState();
}

class _EditSelectionFolderModalState extends State<EditSelectionFolderModal> {
  late final _groupTextController = TextEditingController()
    ..value = TextEditingValue(text: widget.folderId ?? '');

  @override
  Widget build(BuildContext context) {
    final store = SlicesProvider.of<FireAtlasState>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const FSubtitleTitle(title: 'Move to folder'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _groupTextController,
            decoration: const InputDecoration(
              labelText: 'Folder name (leave empty to remove from folder)',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: () {
                  store.dispatch(CloseEditorModal());
                },
              ),
              const SizedBox(width: 5),
              FButton(
                selected: true,
                label: 'Ok',
                onSelect: () {
                  store.dispatch(
                    UpdateSelectionGroup(
                      selectionId: widget.selectionId,
                      group: _groupTextController.text.isEmpty
                          ? null
                          : _groupTextController.text,
                    ),
                  );
                  store.dispatch(CloseEditorModal());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
