import 'package:flutter/widgets.dart';

import '../../vendor/slices/slices.dart';
import '../../store/store.dart';

class SetCanvasSelection extends SlicesAction<FireAtlasState> {
  Rect selection;

  SetCanvasSelection(this.selection);

  @override
  FireAtlasState perform(state) {
    state.canvasSelection = selection;

    return state;
  }
}

class OpenEditorModal extends SlicesAction<FireAtlasState> {
  final Widget modal;
  final double width;
  final double? height;

  OpenEditorModal(this.modal, this.width, [this.height]);

  @override
  FireAtlasState perform(state) {
    state.modal = ModalState(
      child: modal,
      width: width,
      height: height,
    );

    return state;
  }
}

class CloseEditorModal extends SlicesAction<FireAtlasState> {
  @override
  FireAtlasState perform(state) {
    state.modal = null;

    return state;
  }
}

class CreateMessageAction extends SlicesAction<FireAtlasState> {
  final MessageType type;
  final String message;

  CreateMessageAction({
    required this.type,
    required this.message,
  });

  @override
  FireAtlasState perform(state) {
    final existent = state.messages.where((m) => m.message == message);

    if (existent.isEmpty) {
      final messageObj = Message(
        type: type,
        message: message,
      );

      state.messages.add(messageObj);
    }

    return state;
  }
}

class DismissMessageAction extends SlicesAction<FireAtlasState> {
  final Message message;

  DismissMessageAction({
    required this.message,
  });

  @override
  FireAtlasState perform(state) =>
      state..messages.removeWhere((m) => m.message == message.message);
}
