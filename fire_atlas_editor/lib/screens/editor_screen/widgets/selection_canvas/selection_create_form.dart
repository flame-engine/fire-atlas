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

  SelectionCreateForm({
    @required this.selectionStart,
    @required this.selectionEnd,
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

  void _chooseSelectionType(SelectionType _type) {
    setState(() {
      _selectionType = _type;
    });
  }

  @override
  Widget build(ctx) {
    List<Widget> children = [];

    children
        ..add(SizedBox(height: 5))
        ..add(Text('Create new selection item'));

    children
        ..add(SizedBox(height: 50))
        ..add(Text('Selection name:'))
        ..add(Divider())
        ..add(Container(
              width: 200,
              child: TextField(controller: selectionNameController)
        ));

    children
        ..add(SizedBox(height: 50))
        ..add(Text('Selection type'))
        ..add(Divider());

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
                          selection: SpriteSelection()
                          ..id = selectionNameController.text 
                          ..x = widget.selectionStart.dx.toInt()
                          ..y = widget.selectionStart.dy.toInt()
                          ..w = (widget.selectionEnd.dx - widget.selectionStart.dx).toInt()
                          ..h = (widget.selectionEnd.dy - widget.selectionStart.dy).toInt()
                      )
                  );

                  Navigator.of(ctx).pop();
                }
              }
          )
      );
    }

    return FContainer(
        width: 400,
        child: Column(
            children: children,
        )
    );

  }
}
