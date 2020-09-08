import 'package:flutter/material.dart';
import 'package:flame/position.dart';

import '../../../store/store.dart';
import '../../../store/actions/editor_actions.dart';
import '../../../store/actions/atlas_actions.dart';

import '../../../services/images.dart';

import '../../../widgets/text.dart';
import '../../../widgets/button.dart';
import '../../../widgets/image_selection_container.dart';

class ConcatImageModal extends StatefulWidget {
  @override
  State createState() => _ConcatImageModalState();
}

class _ConcatImageModalState extends State<ConcatImageModal> {
  String _imageData;
  Position _position;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      child: Column(
        children: [
          FSubtitleTitle(title: 'Add image'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ImageSelectionContainer(
                    margin: EdgeInsets.all(30),
                    imageData: _imageData,
                    onSelectImage: (imageData) {
                      setState(() {
                        _imageData = imageData;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      FSubtitleTitle(title: 'Position'),
                      FButton(
                        label: 'Top',
                        selected: _position?.y == -1,
                        onSelect: () {
                          setState(() {
                            _position = Position(0, -1);
                          });
                        },
                      ),
                      FButton(
                        label: 'Bottom',
                        selected: _position?.y == 1,
                        onSelect: () {
                          setState(() {
                            _position = Position(0, 1);
                          });
                        },
                      ),
                      FButton(
                        label: 'Left',
                        selected: _position?.x == -1,
                        onSelect: () {
                          setState(() {
                            _position = Position(-1, 0);
                          });
                        },
                      ),
                      FButton(
                        label: 'Right',
                        selected: _position?.x == 1,
                        onSelect: () {
                          setState(() {
                            _position = Position(1, 0);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                  label: 'Cancel',
                  onSelect: () {
                    Store.instance.dispatch(CloseEditorModal());
                  }),
              FButton(
                  disabled: _imageData == null || _position == null,
                  selected: true,
                  label: 'Ok',
                  onSelect: () async {
                    final _newImageData = await concatenateImages(
                      Store.instance.state.currentAtlas.imageData,
                      _imageData,
                      _position,
                    );
                    Store.instance.dispatchAsync(
                      UpdateAtlasImageAction(
                        imageData: _newImageData,
                      ),
                    );
                    Store.instance.dispatch(CloseEditorModal());
                  }),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
