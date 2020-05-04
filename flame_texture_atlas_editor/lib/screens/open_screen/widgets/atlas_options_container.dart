import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'dart:html';
import 'dart:ui';

import '../../../widgets/simple_sprite_widget.dart';

class AtlasOptionsContainer extends StatefulWidget {
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

    RegExp regExp = new RegExp(
        r"^[0-9]+",
        caseSensitive: false,
        multiLine: false,
    );
    final tileSizeRaw = tileSizeController.text;
    final atlasName = atlasNameController.text;

    if (atlasName.isEmpty) {
      setState(() {
        _error = 'Atlas name is required';
      });

      return;
    }

    if (!regExp.hasMatch(tileSizeRaw)) {
      setState(() {
        _error = 'Tile size is required, and must be a number';
      });

      return;
    }

    if (_imageData == null) {
      setState(() {
        _error = 'An image must be selected';
      });

      return;
    }
  }

  void _cancel() {
  }

  @override
  Widget build(ctx) {
    return Container(
        width: 600,
        height: 400,
        color: Theme.of(ctx).dialogBackgroundColor,
        padding: EdgeInsets.all(10),
        child: Column(
            children: [
              Expanded(child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                            children: [
                              Text('Atlas name:'),
                              TextField(
                                  controller: atlasNameController,
                              ),
                              SizedBox(height: 40),
                              Text('Tile size:'),
                              TextField(
                                  controller: tileSizeController,
                              ),
                              SizedBox(height: 40),
                              Container(
                                  child: _error != null ? Text(_error) : null
                              ),
                            ]
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        child: Text('Cancel'),
                        onPressed: _cancel,
                    ),
                    RaisedButton(
                        child: Text('Ok'),
                        onPressed: _confirm,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: imageData != null
                  ? FutureBuilder<Image>(
                      // todo image name
                      future: Flame.images.fromBase64('', imageData),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return SimpleSpriteWidget(
                              sprite: Sprite.fromImage(snapshot.data)
                          );
                        } else if (snapshot.hasError) {
                          return Text('Something wrong happened :(');
                        } else {
                          return Text('Loading');
                        }
                      }
                  )
                  : Center(child: Text('No image selected')),
          ),
          RaisedButton(
              child: Text('Select image'),
              onPressed: () {
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
        ]
    );
  }
}

