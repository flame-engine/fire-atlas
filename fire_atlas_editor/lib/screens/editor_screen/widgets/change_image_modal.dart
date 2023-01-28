import 'package:fire_atlas_editor/store/actions/atlas_actions.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/widgets/button.dart';
import 'package:fire_atlas_editor/widgets/image_selection_container.dart';
import 'package:fire_atlas_editor/widgets/text.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class ChangeImageModal extends StatefulWidget {
  const ChangeImageModal({Key? key}) : super(key: key);

  @override
  State createState() => _ChangeImageModalState();
}

class _ChangeImageModalState extends State<ChangeImageModal> {
  String? _imageData;

  @override
  Widget build(BuildContext ctx) {
    final _store = SlicesProvider.of<FireAtlasState>(ctx);
    return Container(
      child: Column(
        children: [
          const FSubtitleTitle(title: 'Update image'),
          Expanded(
            child: ImageSelectionContainer(
              margin: const EdgeInsets.all(30),
              imageData: _imageData,
              onSelectImage: (imageData) {
                Flame.images.clearCache();
                setState(() {
                  _imageData = imageData;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FButton(
                label: 'Cancel',
                onSelect: () {
                  _store.dispatch(CloseEditorModal());
                },
              ),
              FButton(
                disabled: _imageData == null,
                selected: true,
                label: 'Ok',
                onSelect: () {
                  _store.dispatch(CloseEditorModal());
                  _store.dispatchAsync(
                    UpdateAtlasImageAction(
                      imageData: _imageData!,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
