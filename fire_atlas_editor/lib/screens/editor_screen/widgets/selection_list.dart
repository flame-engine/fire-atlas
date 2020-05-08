import 'package:flutter/material.dart';

import '../../../vendor/micro_store/micro_store.dart';
import '../../../store/store.dart';
import '../../../store/actions/atlas_actions.dart';

import '../../../widgets/text.dart';
import '../../../widgets/container.dart';

class SelectionList extends StatelessWidget {
  @override
  Widget build(_) {
    return MicroStoreProvider(
        store: Store.instance,
        builder: (ctx, store) => FContainer(
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
                                  onTap: () => store.dispatch(SelectSelectionAction(selection: selection)),
                                  child: Text(
                                      '${selection.id}',
                                      style: TextStyle(
                                          fontWeight: (store.state.selectedSelection?.id == selection.id)
                                            ? FontWeight.bold
                                            : FontWeight.normal)
                                  ),
                              ),
                          );
                        }).toList().cast<Widget>()),
                ),
            ),
        ),
    );
  }
}
