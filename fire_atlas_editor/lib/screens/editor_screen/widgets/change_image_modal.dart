import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import '../../../store/store.dart';
import '../../../store/actions/editor_actions.dart';
import '../../../store/actions/atlas_actions.dart';

import '../../../widgets/text.dart';
import '../../../widgets/button.dart';
import '../../../widgets/image_selection_container.dart';

class ChangeImageModal extends StatefulWidget {
  @override
  State createState() => _ChangeImageModalState();
}

class _ChangeImageModalState extends State<ChangeImageModal> {
  String _imageData;

  @override
  Widget build(BuildContext ctx) {
    return Container(
        child: Column(
            children: [
              FSubtitleTitle(title: 'Update image'),
              Expanded(
                  child: ImageSelectionContainer(
                      margin: EdgeInsets.all(30),
                      imageData: _imageData,
                      onSelectImage: (imageData) {
                        Flame.images.clearCache();
                        setState(() {
                          _imageData = imageData;
                        });
                      }
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
                        }
                    ),
                    FButton(
                        disabled: _imageData == null,
                        selected: true,
                        label: 'Ok',
                        onSelect: () {
                          Store.instance.dispatchAsync(
                              UpdateAtlasImageAction(
                                  imageData: _imageData,
                              ),
                          );
                          Store.instance.dispatch(CloseEditorModal());
                        }
                    ),
                  ],
              ),
              SizedBox(height: 20),
            ],
        ),
    );
  }
}
