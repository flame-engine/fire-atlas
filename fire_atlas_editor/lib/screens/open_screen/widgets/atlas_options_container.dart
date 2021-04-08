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

  final atlasNameController = TextEditingController();
  final tileWidthController = TextEditingController();
  final tileHeightController = TextEditingController();

  @override
  void dispose() {
    atlasNameController.dispose();
    tileWidthController.dispose();
    tileHeightController.dispose();
    super.dispose();
  }

  void _confirm() {
    final tileWidthRaw = tileWidthController.text;
    final tileHeightRaw = tileHeightController.text;
    final atlasName = atlasNameController.text;

    if (atlasName.isEmpty) {
      Store.instance.dispatch(CreateMessageAction(
        message: 'Atlas name is required',
        type: MessageType.ERROR,
      ));
      return;
    }
    if (tileWidthRaw.isEmpty) {
      Store.instance.dispatch(CreateMessageAction(
        message: 'Tile Width is required',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileHeightRaw.isEmpty) {
      Store.instance.dispatch(CreateMessageAction(
        message: 'Tile Height is required',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileWidthRaw.isNotEmpty && !isValidNumber(tileWidthRaw)) {
      Store.instance.dispatch(CreateMessageAction(
        message: 'Tile Width must be a number',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (tileHeightRaw.isNotEmpty && !isValidNumber(tileHeightRaw)) {
      Store.instance.dispatch(CreateMessageAction(
        message: 'Tile Height must be a number',
        type: MessageType.ERROR,
      ));
      return;
    }

    if (_imageData == null) {
      Store.instance.dispatch(CreateMessageAction(
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
