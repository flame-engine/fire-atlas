import 'package:flutter/widgets.dart';

import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';

class SetCanvasSelection extends MicroStoreAction<FireAtlasState> {
  Rect selection;

  SetCanvasSelection(this.selection);

  @override
  FireAtlasState perform(state) {
    state.canvasSelection = selection;

    return state;
  }
}

class OpenEditorModal extends MicroStoreAction<FireAtlasState> {
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

class CloseEditorModal extends MicroStoreAction<FireAtlasState> {
  @override
  FireAtlasState perform(state) {
    state.modal = null;

    return state;
  }
}

class CreateMessageAction extends MicroStoreAction<FireAtlasState> {
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

class DismissMessageAction extends MicroStoreAction<FireAtlasState> {
  final Message message;

  DismissMessageAction({
    required this.message,
  });

  @override
  FireAtlasState perform(state) =>
      state..messages.removeWhere((m) => m.message == message.message);
}
