import 'package:fire_atlas_editor/screens/editor_screen/widgets/preview.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/selection_canvas/selection_canvas.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/selection_list.dart';
import 'package:fire_atlas_editor/screens/editor_screen/widgets/toolbar.dart';
import 'package:fire_atlas_editor/screens/widgets/scaffold.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final _store = SlicesProvider.of<FireAtlasState>(ctx);
    if (_store.state.currentAtlas == null) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('No atlas selected'),
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
            children: const [
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
            children: const [
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
