import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../widgets/container.dart';
import '../../../../widgets/button.dart';

import '../../../../store/store.dart';
import '../../../../store/actions/atlas_actions.dart';
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

  @override
  Widget build(ctx) {
    List<Widget> children = [];

    children
        ..add(SizedBox(height: 5))
        ..add(Text('Create new selection item'));

    children
        ..add(SizedBox(height: 20))
        ..add(
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Selection name:'),
                  Container(
                      width: 200,
                      child: TextField(controller: selectionNameController)
                  )
                ]
            )
        );

    children
        ..add(SizedBox(height: 50))
        ..add(Text('Selection type'));

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
      children.add(
          FButton(
              label: 'Create sprite',
              onSelect: () {

                if (selectionNameController.text.isNotEmpty) {
                  Store.instance.dispatch(
                      AddSelectionAction(
                          selection: _fillSelectionBaseValues(SpriteSelection())
                      )
                  );

                  widget.onComplete();
                }
              }
          )
      );
    } else if (_selectionType == SelectionType.ANIMATION) {
      children
          ..add(
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Frame count:'),
                    Container(
                        width: 200,
                        child: TextField(controller: frameCountController)
                    )
                  ]
              )
            )
          ..add(SizedBox(height: 10));

      children
          ..add(
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Step time (in millis):'),
                    Container(
                        width: 200,
                        child: TextField(controller: stepTimeController)
                    )
                  ]
              )
            )
          ..add(SizedBox(height: 10));

      children.add(
          FButton(
              label: 'Create animation',
              onSelect: () {

                if (selectionNameController.text.isNotEmpty &&
                    // Check if is number
                    frameCountController.text.isNotEmpty &&
                    stepTimeController.text.isNotEmpty) {
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
                }
              }
          )
      );
    }

    return Container(
        width: 400,
        child: Column(
            children: children,
        )
    );

  }
}
