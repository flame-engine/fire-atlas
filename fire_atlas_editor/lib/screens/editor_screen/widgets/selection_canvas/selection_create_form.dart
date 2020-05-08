import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../widgets/text.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/input_text_row.dart';

import '../../../../utils/validators.dart';
import '../../../../store/store.dart';
import '../../../../store/actions/atlas_actions.dart';
import '../../../../store/actions/editor_actions.dart';
import '../../../../models/fire_atlas.dart';

class SelectionCreateForm extends StatefulWidget {
  final Offset selectionStart;
  final Offset selectionEnd;
  final VoidCallback onComplete;

  SelectionCreateForm({
    @required this.selectionStart,
    @required this.selectionEnd,
    @required this.onComplete,
  });

  @override
  State createState() => _SelectionCreateFormState();
}

enum SelectionType {
  SPRITE,
  ANIMATION,
}

class _SelectionCreateFormState extends State<SelectionCreateForm> {

  SelectionType _selectionType;

  final selectionNameController = TextEditingController();
  final frameCountController = TextEditingController();
  final stepTimeController = TextEditingController();

  void _chooseSelectionType(SelectionType _type) {
    setState(() {
      _selectionType = _type;
    });
  }

  T _fillSelectionBaseValues <T extends Selection> (T selection) {
    final w = (widget.selectionEnd.dx - widget.selectionStart.dx).toInt();
    final h = (widget.selectionEnd.dy - widget.selectionStart.dy).toInt();

    return selection
        ..id = selectionNameController.text 
        ..x = widget.selectionStart.dx.toInt()
        ..y = widget.selectionStart.dy.toInt()
        ..w = w
        ..h = h;
  }

  void _createSprite() {
    if (selectionNameController.text.isNotEmpty) {
      Store.instance.dispatch(
          AddSelectionAction(
              selection: _fillSelectionBaseValues(SpriteSelection())
          )
      );

      widget.onComplete();
    } else {
      Store.instance.dispatch(
          CreateMessageAction(
              type: MessageType.ERROR,
              message: 'You must inform the selection name',
          ),
      );
    }
  }

  void _createAnimation() {
    if (selectionNameController.text.isNotEmpty &&
        frameCountController.text.isNotEmpty &&
        stepTimeController.text.isNotEmpty) {

      if (!isValidNumber(frameCountController.text)) {
        Store.instance.dispatch(
            CreateMessageAction(
                type: MessageType.ERROR,
                message: 'Frame count is not a valid number',
            ),
        );

        return;
      }

      if (!isValidNumber(stepTimeController.text)) {
        Store.instance.dispatch(
            CreateMessageAction(
                type: MessageType.ERROR,
                message: 'Step time is not a valid number',
            ),
        );

        return;
      }

      Store.instance.dispatch(
          AddSelectionAction(
              selection: _fillSelectionBaseValues<AnimationSelection>(AnimationSelection())
              ..frameCount = int.parse(frameCountController.text)
              ..stepTime = int.parse(stepTimeController.text) / 1000
              // Add a field to this
              ..loop = true
          )
      );

      widget.onComplete();
    } else {
      Store.instance.dispatch(
          CreateMessageAction(
              type: MessageType.ERROR,
              message: 'All fields are required',
          ),
      );
    }
  }

  @override
  Widget build(ctx) {
    List<Widget> children = [];

    children
        ..add(SizedBox(height: 5))
        ..add(FTitle(title: 'New selection item'))
        ..add(
            InputTextRow(
                label: 'Selection name:',
                inputController: selectionNameController,
            ),
        )
        ..add(SizedBox(height: 10))
        ..add(Text('Selection type'))
        ..add(SizedBox(height: 10));

    children.add(
        Container(
            width: 200,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FButton(
                      label: 'Sprite',
                      selected: _selectionType == SelectionType.SPRITE,
                      onSelect: () => _chooseSelectionType(SelectionType.SPRITE),
                  ),
                  FButton(
                      label: 'Animation',
                      selected: _selectionType == SelectionType.ANIMATION,
                      onSelect: () => _chooseSelectionType(SelectionType.ANIMATION),
                  ),
                ]
            )
        ),
    );

    if (_selectionType == SelectionType.SPRITE) {
      children
          ..add(SizedBox(height: 20))
          ..add(
              FButton(
                  label: 'Create sprite',
                  onSelect: _createSprite,
              )
          );
    } else if (_selectionType == SelectionType.ANIMATION) {
      children
          ..add(SizedBox(height: 10))
          ..add(
              InputTextRow(
                  label: 'Frame count:',
                  inputController: frameCountController,
              ),
            )
          ..add(SizedBox(height: 10));

      children
          ..add(
              InputTextRow(
                  label: 'Step time (in millis):',
                  inputController: stepTimeController,
              ),
            )
          ..add(SizedBox(height: 20));

      children.add(
          FButton(
              label: 'Create animation',
              onSelect: _createAnimation,
          )
      );
    }

    return Container(
        width: 400,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
            children: children,
        )
    );

  }
}
