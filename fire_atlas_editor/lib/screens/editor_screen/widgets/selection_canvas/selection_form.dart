import 'package:slices/slices.dart';
import 'package:flutter/material.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import '../../../../widgets/text.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/input_text_row.dart';

import '../../../../utils/validators.dart';
import '../../../../store/store.dart';
import '../../../../store/actions/atlas_actions.dart';
import '../../../../store/actions/editor_actions.dart';

class SelectionForm extends StatefulWidget {
  final Offset? selectionStart;
  final Offset? selectionEnd;

  final AnimationSelection? editingSelection;

  SelectionForm({
    this.selectionStart,
    this.selectionEnd,
    this.editingSelection,
  });

  @override
  State createState() => _SelectionFormState();
}

enum SelectionType {
  SPRITE,
  ANIMATION,
}

class _SelectionFormState extends State<SelectionForm> {
  SelectionType? _selectionType;

  final selectionNameController = TextEditingController();
  final frameCountController = TextEditingController();
  final stepTimeController = TextEditingController();
  bool _animationLoop = true;

  @override
  initState() {
    super.initState();

    if (widget.editingSelection != null) {
      final selection = widget.editingSelection!;
      selectionNameController.text = selection.id;
      frameCountController.text = selection.frameCount.toString();
      stepTimeController.text = (selection.stepTime * 1000).toInt().toString();

      _selectionType = SelectionType.ANIMATION;
    }
  }

  void _chooseSelectionType(SelectionType _type) {
    setState(() {
      _selectionType = _type;
    });
  }

  Selection _fillSelectionBaseValues() {
    if (widget.selectionEnd == null) throw 'Selection end is null';
    if (widget.selectionStart == null) throw 'Selection start is null';

    final selectionEnd = widget.selectionEnd!;
    final selectionStart = widget.selectionStart!;

    final w = (selectionEnd.dx - selectionStart.dx).toInt();
    final h = (selectionEnd.dy - selectionStart.dy).toInt();

    return Selection(
      id: selectionNameController.text,
      x: selectionStart.dx.toInt(),
      y: selectionStart.dy.toInt(),
      w: w,
      h: h,
    );
  }

  void _createSprite() {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    if (selectionNameController.text.isNotEmpty) {
      final info = _fillSelectionBaseValues();
      _store.dispatch(
        SetSelectionAction(
          selection: SpriteSelection(info: info),
        ),
      );

      _store.dispatch(CloseEditorModal());
    } else {
      _store.dispatch(
        CreateMessageAction(
          type: MessageType.ERROR,
          message: 'You must inform the selection name',
        ),
      );
    }
  }

  void _createAnimation() {
    final _store = SlicesProvider.of<FireAtlasState>(context);
    if (selectionNameController.text.isNotEmpty &&
        frameCountController.text.isNotEmpty &&
        stepTimeController.text.isNotEmpty) {
      if (!isValidNumber(frameCountController.text)) {
        _store.dispatch(
          CreateMessageAction(
            type: MessageType.ERROR,
            message: 'Frame count is not a valid number',
          ),
        );

        return;
      }

      if (!isValidNumber(stepTimeController.text)) {
        _store.dispatch(
          CreateMessageAction(
            type: MessageType.ERROR,
            message: 'Step time is not a valid number',
          ),
        );

        return;
      }
      final frameCount = int.parse(frameCountController.text);
      final stepTime = int.parse(stepTimeController.text) / 1000;

      final selectionToSave = widget.editingSelection == null
          ? AnimationSelection(
              info: _fillSelectionBaseValues(),
              frameCount: frameCount,
              stepTime: stepTime,
              loop: _animationLoop,
            )
          : widget.editingSelection!
        ..frameCount = frameCount
        ..stepTime = stepTime
        ..loop = _animationLoop;

      _store.dispatch(
        SetSelectionAction(selection: selectionToSave),
      );

      _store.dispatch(CloseEditorModal());
    } else {
      _store.dispatch(
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
      ..add(FTitle(
          title:
              '${widget.editingSelection == null ? 'New' : 'Edit'} selection item'))
      ..add(
        InputTextRow(
          label: 'Selection name:',
          inputController: selectionNameController,
          enabled: widget.editingSelection == null,
          autofocus: true,
        ),
      )
      ..add(SizedBox(height: 10));

    if (widget.editingSelection == null) {
      children
        ..add(Text('Selection type'))
        ..add(SizedBox(height: 10))
        ..add(
          Container(
              width: 200,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FButton(
                      label: 'Sprite',
                      selected: _selectionType == SelectionType.SPRITE,
                      onSelect: () =>
                          _chooseSelectionType(SelectionType.SPRITE),
                    ),
                    FButton(
                      label: 'Animation',
                      selected: _selectionType == SelectionType.ANIMATION,
                      onSelect: () =>
                          _chooseSelectionType(SelectionType.ANIMATION),
                    ),
                  ])),
        );
    }

    if (_selectionType == SelectionType.SPRITE) {
      children
        ..add(SizedBox(height: 20))
        ..add(FButton(
          label: 'Create sprite',
          onSelect: _createSprite,
        ));
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

      children
        ..add(FLabel(label: 'Loop animation', fontSize: 12))
        ..add(Checkbox(
            value: _animationLoop,
            onChanged: (v) {
              if (v != null) {
                setState(() => _animationLoop = v);
              }
            }))
        ..add(SizedBox(height: 20));

      children.add(FButton(
        label:
            '${widget.editingSelection == null ? 'Create' : 'Save'} animation',
        onSelect: _createAnimation,
      ));
    }

    return Container(
        width: 400,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: children,
        ));
  }
}
