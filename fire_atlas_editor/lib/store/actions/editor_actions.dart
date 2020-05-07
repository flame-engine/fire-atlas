import 'package:flutter/widgets.dart';

import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';

class OpenEditorModal extends MicroStoreAction<FireAtlasState> {
  final Widget modal;
  final double width;

  OpenEditorModal(this.modal, this.width);

  @override
  FireAtlasState perform(state) {
    state.modal = ModalState()
        ..child = modal
        ..width = width;

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

