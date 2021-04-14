import 'package:fire_atlas_editor/vendor/slices/slices.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';

import '../../../store/store.dart';
import '../../../store/actions/editor_actions.dart';
import '../../../widgets/text.dart';
import '../../../widgets/button.dart';
import '../../../widgets/input_text_row.dart';
import '../../../widgets/image_selection_container.dart';

import '../../../utils/validators.dart';

class AtlasOptionsContainer extends StatefulWidget {
  final void Function() onCancel;
  final Function(String, String, double, double) onConfirm;

  AtlasOptionsContainer({
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State createState() => _AtlaOptionsContainerState();
}

class _AtlaOptionsContainerState extends State<AtlasOptionsContainer> {
  String? _imageData;
  late final atlasNameController;
  late final tileWidthController;
  late final tileHeightController;

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
    final _store = SlicesProvider.of<FireAtlasState>(context);
    final tileWidthRaw = tileWidthController.text;
    final tileHeightRaw = tileHeightController.text;
    final atlasName = atlasNameController.text;

    if (atlasName.isEmpty) {
      _store.dispatch(CreateMessageAction(
        message: 'Atlas name is required',
        type: MessageType.ERROR,
      ));
      return;
    }
    if (tileWidthRaw.isEmpty) {
      _store.dispatch(CreateMessageAction(
        message: 'Tile Width is required',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileHeightRaw.isEmpty) {
      _store.dispatch(CreateMessageAction(
        message: 'Tile Height is required',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileWidthRaw.isNotEmpty && !isValidNumber(tileWidthRaw)) {
      _store.dispatch(CreateMessageAction(
        message: 'Tile Width must be a number',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileHeightRaw.isNotEmpty && !isValidNumber(tileHeightRaw)) {
      _store.dispatch(CreateMessageAction(
        message: 'Tile Height must be a number',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (_imageData == null) {
      _store.dispatch(CreateMessageAction(
        message: 'An image must be selected',
        type: MessageType.ERROR,
      ));
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
  Widget build(ctx) {
    return Container(
      width: 600,
      height: 400,
      color: Theme.of(ctx).dialogBackgroundColor,
      padding: EdgeInsets.all(20),
      child: Column(children: [
        FTitle(title: 'New atlas'),
        SizedBox(height: 20),
        Expanded(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  InputTextRow(
                    label: 'Atlas name:',
                    inputController: atlasNameController,
                  ),
                  SizedBox(height: 40),
                  InputTextRow(
                    label: 'Tile Width:',
                    inputController: tileWidthController,
                  ),
                  SizedBox(height: 40),
                  InputTextRow(
                    label: 'Tile Height:',
                    inputController: tileHeightController,
                  ),
                ],
              )),
          Expanded(
            flex: 5,
            child: ImageSelectionContainer(
                imageData: _imageData,
                onSelectImage: (imageData) {
                  Flame.images.clearCache();
                  setState(() {
                    _imageData = imageData;
                  });
                }),
          ),
        ])),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FButton(
            label: 'Cancel',
            onSelect: _cancel,
          ),
          SizedBox(width: 20),
          FButton(
            label: 'Ok',
            onSelect: _confirm,
          ),
        ]),
      ]),
    );
  }
}
