import 'package:flutter/material.dart';

import './widgets/toolbar.dart';
import './widgets/selection_canvas/selection_canvas.dart';
import './widgets/selection_list.dart';
import './widgets/preview.dart';

import '../../widgets/scaffold.dart';
import '../../widgets/button.dart';
import '../../store/store.dart';

class EditorScreen extends StatelessWidget {
  @override
  Widget build(ctx) {

    if (Store.instance.state.currentAtlas == null) {
      // TODO improve this
      return Scaffold(
          body: Center(
              child: Column(
                  children: [
                    Text('No atlas selected'),
                    FButton(
                        label: 'Back',
                        onSelect: () {
                          Navigator.of(ctx).pop();
                        },
                    ),
                  ],
              ),
          ),
      );
    }

    final body = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Body
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Toolbar(),
                    Expanded(
                        child: SelectionCanvas(),
                    ),
                  ],
              ),
          ),
          Container(
              width: 400,
              child: Column(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Preview(),
                    ),
                    Expanded(
                        flex: 6,
                        child: SelectionList(),
                    ),
                  ],
              ),
          ),
        ],
    );

    return FScaffold(child: body);
  }
}
