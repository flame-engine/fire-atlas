import 'package:flutter/material.dart';

import '../../../store/store.dart';
import '../../../store/actions/editor_actions.dart';
import '../../../store/actions/atlas_actions.dart';
import '../../../widgets/text.dart';
import '../../../widgets/button.dart';

class DeleteSelectionModal extends StatelessWidget {
  @override
  Widget build(ctx) {
    void _closeModal() => Store.instance.dispatch(CloseEditorModal());

    void _confirm() {
      Store.instance.dispatch(RemoveSelectedSelectionAction());
      _closeModal();
    }

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(children: [
        FSubtitleTitle(title: 'Confirmation'),
        FLabel(label: 'Are you sure you want to delete this selection?'),
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
      ]),
    );
  }
}
