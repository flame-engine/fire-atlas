import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class SetCanvasSelection extends SlicesAction<FireAtlasState> {
  final Rect selection;

  SetCanvasSelection(this.selection);

  @override
  FireAtlasState perform(_, FireAtlasState state) {
    return state.copyWith(
      canvasSelection: Nullable(selection),
    );
  }
}

class OpenEditorModal extends SlicesAction<FireAtlasState> {
  final Widget modal;
  final double width;
  final double? height;

  OpenEditorModal(this.modal, this.width, [this.height]);

  @override
  FireAtlasState perform(_, FireAtlasState state) {
    return state.copyWith(
      modal: Nullable(
        ModalState(
          child: modal,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class CloseEditorModal extends SlicesAction<FireAtlasState> {
  @override
  FireAtlasState perform(_, FireAtlasState state) {
    return state.copyWith(modal: Nullable(null));
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
  FireAtlasState perform(_, FireAtlasState state) {
    final existent = state.messages.where((m) => m.message == message);

    final newList = state.messages.toList();
    if (existent.isEmpty) {
      final messageObj = Message(
        type: type,
        message: message,
      );

      newList.add(messageObj);
    }

    return state.copyWith(messages: newList);
  }
}

class DismissMessageAction extends SlicesAction<FireAtlasState> {
  final Message message;

  DismissMessageAction({
    required this.message,
  });

  @override
  FireAtlasState perform(_, FireAtlasState state) {
    final newList = state.messages.toList();
    newList.removeWhere((m) => m.message == message.message);

    return state.copyWith(messages: newList);
  }
}

class ToggleThemeAction extends AsyncSlicesAction<FireAtlasState> {
  @override
  Future<FireAtlasState> perform(
    SlicesStore<FireAtlasState> store,
    FireAtlasState state,
  ) async {
    final newTheme =
        state.currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    final storage = FireAtlasStorage();
    await storage.setConfig(kThemeMode, newTheme.toString());

    return state.copyWith(currentTheme: newTheme);
  }
}
