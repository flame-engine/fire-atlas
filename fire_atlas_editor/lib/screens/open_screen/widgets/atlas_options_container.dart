import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/utils/validators.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/image_selection_container.dart';
import 'package:fire_atlas_editor/widgets/input_text_row.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:slices/slices.dart';

class AtlasOptionsContainer extends StatefulWidget {
  final void Function() onCancel;
  final Function(String, String, double, double) onConfirm;

  const AtlasOptionsContainer({
    required this.onCancel,
    required this.onConfirm,
    super.key,
  });

  @override
  State createState() => _AtlasOptionsContainerState();
}

class _AtlasOptionsContainerState extends State<AtlasOptionsContainer> {
  String? _imageData;
  String? _imageName;
  late final TextEditingController atlasNameController;
  late final TextEditingController tileWidthController;
  late final TextEditingController tileHeightController;

  @override
  void initState() {
    super.initState();

    atlasNameController = TextEditingController();
    tileWidthController = TextEditingController();
    tileHeightController = TextEditingController();
  }

  @override
  void dispose() {
    atlasNameController.dispose();
    tileWidthController.dispose();
    tileHeightController.dispose();
    super.dispose();
  }

  void _confirm() {
    final store = SlicesProvider.of<FireAtlasState>(context);
    final tileWidthRaw = tileWidthController.text;
    final tileHeightRaw = tileHeightController.text;
    final atlasName = atlasNameController.text;

    if (atlasName.isEmpty) {
      store.dispatch(
        CreateMessageAction(
          message: 'Atlas name is required',
          type: MessageType.ERROR,
        ),
      );
      return;
    }
    if (tileWidthRaw.isEmpty) {
      store.dispatch(
        CreateMessageAction(
          message: 'Tile Width is required',
          type: MessageType.ERROR,
        ),
      );
      return;
    }

    if (tileHeightRaw.isEmpty) {
      store.dispatch(
        CreateMessageAction(
          message: 'Tile Height is required',
          type: MessageType.ERROR,
        ),
      );
      return;
    }

    if (tileWidthRaw.isNotEmpty && !isValidNumber(tileWidthRaw)) {
      store.dispatch(
        CreateMessageAction(
          message: 'Tile Width must be a number',
          type: MessageType.ERROR,
        ),
      );
      return;
    }

    if (tileHeightRaw.isNotEmpty && !isValidNumber(tileHeightRaw)) {
      store.dispatch(
        CreateMessageAction(
          message: 'Tile Height must be a number',
          type: MessageType.ERROR,
        ),
      );
      return;
    }

    if (_imageData == null) {
      store.dispatch(
        CreateMessageAction(
          message: 'An image must be selected',
          type: MessageType.ERROR,
        ),
      );
      return;
    }

    widget.onConfirm(
      atlasName,
      _imageData!,
      double.parse(tileWidthRaw),
      double.parse(tileHeightRaw),
    );
  }

  void _cancel() {
    widget.onCancel();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: 600,
      height: 400,
      color: Theme.of(ctx).dialogBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const FTitle(title: 'New atlas'),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      InputTextRow(
                        label: 'Atlas name:',
                        inputController: atlasNameController,
                      ),
                      const SizedBox(height: 40),
                      InputTextRow(
                        label: 'Tile Width:',
                        inputController: tileWidthController,
                      ),
                      const SizedBox(height: 40),
                      InputTextRow(
                        label: 'Tile Height:',
                        inputController: tileHeightController,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ImageSelectionContainer(
                    imageData: _imageData,
                    imageName: _imageName,
                    onSelectImage: (imageName, imageData) {
                      setState(() {
                        _imageData = imageData;
                        _imageName = imageName;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: _cancel,
              ),
              const SizedBox(width: 20),
              FButton(
                label: 'Ok',
                onSelect: _confirm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
