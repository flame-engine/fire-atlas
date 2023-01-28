import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class DeleteSelectionModal extends StatelessWidget {
  const DeleteSelectionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final store = SlicesProvider.of<FireAtlasState>(ctx);
    void _closeModal() => store.dispatch(CloseEditorModal());

    void _confirm() {
      store.dispatch(RemoveSelectedSelectionAction());
      _closeModal();
    }

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          const FSubtitleTitle(title: 'Confirmation'),
          const FLabel(
            label: 'Are you sure you want to delete this selection?',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: _closeModal,
              ),
              FButton(
                selected: true,
                label: 'Yes',
                onSelect: _confirm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
