import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../models/fire_atlas.dart';
import '../../../store/store.dart';
import '../../../store/actions/atlas_actions.dart';
import '../../../store/actions/editor_actions.dart';

import '../../../widgets/text.dart';
import '../../../widgets/container.dart';
import '../../../widgets/icon_button.dart';

import './delete_selection_modal.dart';
import './selection_canvas/selection_form.dart';

class SelectionList extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider(
        store: Store.instance,
        builder: (ctx, store) {
          void _select(Selection selection) => store.dispatch(SelectSelectionAction(selection: selection));

          return FContainer(
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [FSubtitleTitle(title: 'Selections')]..addAll(store.state.currentAtlas?.selections?.length == 0
                        ? [FLabel(label: 'No selections yet')]
                        : store.state.currentAtlas.selections.values.map((selection) {
                            return Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(ctx).dividerColor,
                                        ),
                                    )
                                ),
                                child: GestureDetector(
                                    onTap: () => _select(selection),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${selection.id}',
                                              style: TextStyle(
                                                  fontWeight: (store.state.selectedSelection?.id == selection.id)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal)
                                          ),
                                          Row(
                                              children: [
                                                selection is AnimationSelection ? FIconButton(
                                                    iconData: Icons.edit,
                                                    onPress: () {
                                                      _select(selection);
                                                      Store.instance.dispatch(
                                                          OpenEditorModal(
                                                              SelectionForm(
                                                                  editingSelection: selection,
                                                              ),
                                                              400,
                                                          )
                                                      );
                                                    },
                                                ) : Container(),
                                                FIconButton(
                                                    iconData: Icons.cancel,
                                                    onPress: () {
                                                      _select(selection);
                                                      Store.instance.dispatch(
                                                          OpenEditorModal(DeleteSelectionModal(), 300, 200)
                                                      );
                                                    },
                                                ),
                                              ]
                                          ),
                                        ]
                                    ),
                                ),
                            );
                          }).toList().cast<Widget>()),
                  ),
              ),
          );
        },
    );
  }
}
