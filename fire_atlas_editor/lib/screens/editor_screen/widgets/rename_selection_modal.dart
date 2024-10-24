import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/input_text_row.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flutter/widgets.dart';
import 'package:slices/slices.dart';

class RenameSelectionModal extends StatefulWidget {
  final String currentName;

  const RenameSelectionModal({required this.currentName, super.key});

  @override
  State createState() => _RenameSelectionModalState();
}

class _RenameSelectionModalState extends State<RenameSelectionModal> {
  final newNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    newNameController.text = widget.currentName;
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const FSubtitleTitle(title: 'Rename selection'),
          InputTextRow(
            label: 'New name:',
            inputController: newNameController,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: () => _closeModal(ctx),
              ),
              const SizedBox(width: 20),
              FButton(
                label: 'Rename',
                onSelect: () => _renameSelection(ctx),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _renameSelection(BuildContext ctx) async {
    final store = SlicesProvider.of<FireAtlasState>(ctx);
    final newName = newNameController.text;
    if (newName.isEmpty) {
      store.dispatch(
        CreateMessageAction(
          type: MessageType.ERROR,
          message: 'The new name is required.',
        ),
      );
    } else {
      final action = RenameSelectionAction(
        oldName: widget.currentName,
        newName: newName,
      );
      await store.dispatchAsync(action);
      await _closeModal(ctx);
    }
  }

  Future<void> _closeModal(BuildContext ctx) async {
    final store = SlicesProvider.of<FireAtlasState>(ctx);
    store.dispatch(CloseEditorModal());
  }
}
