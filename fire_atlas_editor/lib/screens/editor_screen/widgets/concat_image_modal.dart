import 'package:fire_atlas_editor/vendor/slices/slices.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';

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
  String? _imageData;
  Vector2? _placement;
  Rect? _selection;

  @override
  Widget build(BuildContext ctx) {
    final _store = SlicesProvider.of<FireAtlasState>(ctx);
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
                    margin: EdgeInsets.only(
                        top: 30, bottom: 10, left: 10, right: 10),
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
                        width: 100,
                        padding: EdgeInsets.only(bottom: 10),
                        label: 'Top',
                        selected: _placement?.y == -1,
                        onSelect: () {
                          setState(() {
                            _placement = Vector2(0, -1);
                            _selection = null;
                          });
                        },
                      ),
                      FButton(
                        width: 100,
                        padding: EdgeInsets.only(bottom: 10),
                        label: 'Bottom',
                        selected: _placement?.y == 1,
                        onSelect: () {
                          setState(() {
                            _placement = Vector2(0, 1);
                            _selection = null;
                          });
                        },
                      ),
                      FButton(
                        width: 100,
                        padding: EdgeInsets.only(bottom: 10),
                        label: 'Left',
                        selected: _placement?.x == -1,
                        onSelect: () {
                          setState(() {
                            _placement = Vector2(-1, 0);
                            _selection = null;
                          });
                        },
                      ),
                      FButton(
                        width: 100,
                        padding: EdgeInsets.only(bottom: 10),
                        label: 'Right',
                        selected: _placement?.x == 1,
                        onSelect: () {
                          setState(() {
                            _placement = Vector2(1, 0);
                            _selection = null;
                          });
                        },
                      ),
                      FButton(
                        width: 100,
                        padding: EdgeInsets.only(bottom: 10),
                        label: 'Selection',
                        disabled: _store.state.canvasSelection == null,
                        selected: _selection != null,
                        onSelect: () {
                          setState(() {
                            _placement = null;
                            _selection = _store.state.canvasSelection;
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
                  _store.dispatch(CloseEditorModal());
                },
              ),
              SizedBox(width: 5),
              FButton(
                disabled: _imageData == null ||
                    (_placement == null && _selection == null),
                selected: true,
                label: 'Ok',
                onSelect: () async {
                  final currentAtlas = _store.state.currentAtlas!;
                  final _newImageData = await concatenateImages(
                    currentAtlas.imageData!,
                    _imageData!,
                    _placement,
                    _selection,
                  );
                  _store.dispatch(CloseEditorModal());
                  await _store.dispatchAsync(
                    UpdateAtlasImageAction(
                      imageData: _newImageData,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
