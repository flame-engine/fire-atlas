import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'dart:html';
import 'dart:ui';

import '../../../store/store.dart';
import '../../../store/actions/editor_actions.dart';
import '../../../widgets/text.dart';
import '../../../widgets/container.dart';
import '../../../widgets/button.dart';
import '../../../widgets/simple_sprite_widget.dart';
import '../../../widgets/input_text_row.dart';
import '../../../utils/validators.dart';

class AtlasOptionsContainer extends StatefulWidget {
  final void Function() onCancel;
  final Function(String, int, String) onConfirm;

  AtlasOptionsContainer({
    this.onCancel,
    this.onConfirm,
  });

  @override
  State createState() => _AtlaOptionsContainerState();
}

class _AtlaOptionsContainerState extends State<AtlasOptionsContainer> {

  String _imageData;
  String _error;

  final tileSizeController = TextEditingController();
  final atlasNameController = TextEditingController();

  @override
  void dispose() {
    tileSizeController.dispose();
    super.dispose();
  }

  void _confirm() {
    setState(() {
      _error = null;
    });

    final tileSizeRaw = tileSizeController.text;
    final atlasName = atlasNameController.text;

    if (atlasName.isEmpty) {
      Store.instance.dispatch(
          CreateMessageAction(
              message: 'Atlas name is required',
              type: MessageType.ERROR,
          )
      );
      return;
    }

    if (!isValidNumber(tileSizeRaw)) {
      Store.instance.dispatch(
          CreateMessageAction(
              message: 'Tile size is required, and must be a number',
              type: MessageType.ERROR,
          )
      );
      return;
    }

    if (_imageData == null) {
      Store.instance.dispatch(
          CreateMessageAction(
              message: 'An image must be selected',
              type: MessageType.ERROR,
          )
      );
      return;
    }

    widget.onConfirm(atlasName, int.parse(tileSizeRaw), _imageData);
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
        child: Column(
            children: [
              FTitle(title: 'New atlas'),
              SizedBox(height: 20),
              Expanded(child: Row(
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
                              SizedBox(height: 40),
                              InputTextRow(
                                  label: 'Tile size:',
                                  inputController: tileSizeController,
                              ),
                            ],
                        )
                    ),
                    Expanded(
                        flex: 5,
                        child: _ImageSelectionContainer(
                            imageData: _imageData,
                            onSelectImage: (imageData) {
                              Flame.images.clearCache();
                              setState(() {
                                _imageData = imageData;
                              });
                            }
                        ),
                    ),
                ]
              )),
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FButton(
                        label: 'Cancel',
                        onSelect: _cancel,
                    ),
                    FButton(
                        label: 'Ok',
                        onSelect: _confirm,
                    ),
                  ]
              ),
          ]
        ),
    );
  }
}

class _ImageSelectionContainer extends StatelessWidget {
  final String imageData;
  final void Function(String) onSelectImage;

  _ImageSelectionContainer({ this.imageData, this.onSelectImage });

  @override
  Widget build(_) {
    return Column(
        children: [
          Expanded(
              child: FContainer(margin:
                  EdgeInsets.only(left: 30, right: 2.5, top: 2.5, bottom: 2.5),
                  child: imageData != null
                      ? FutureBuilder<Image>(
                          // todo image name
                          future: Flame.images.fromBase64('', imageData),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(width: 200, child: SimpleSpriteWidget(
                                  sprite: Sprite.fromImage(snapshot.data)
                              ));
                            } else if (snapshot.hasError) {
                              return Text('Something wrong happened :(');
                            } else {
                              return Text('Loading');
                            }
                          }
                      )
                      : Center(child: Text('No image selected')),
                  ),
          ),
          Container(
              child: FButton(
                  label: 'Select image',
                  onSelect: () {
                    InputElement uploadInput = FileUploadInputElement();
                    uploadInput.click();

                    uploadInput.onChange.listen((e) {
                      // read file content as dataURL
                      final files = uploadInput.files;
                      if (files.length == 1) {
                        final file = files[0];
                        final reader = new FileReader();

                        reader.onLoadEnd.listen((e) {
                          onSelectImage(reader.result);
                        });
                        reader.readAsDataUrl(file);
                      }
                    });
                  }
              )
          )
        ]
    );
  }
}

