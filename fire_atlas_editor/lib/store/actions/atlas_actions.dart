import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import '../../services/storage.dart';

import './editor_actions.dart';

class CreateAtlasAction extends AsyncMicroStoreAction<FireAtlasState> {
  String id;
  String imageData;
  double tileWidth;
  double tileHeight;

  CreateAtlasAction({
    required this.id,
    required this.imageData,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<FireAtlasState> perform(FireAtlasState state) async {
    final atlas = FireAtlas(
      id: id,
      imageData: imageData,
      tileHeight: tileHeight,
      tileWidth: tileWidth,
    );

    await atlas.loadImage(clearImageData: false);

    state
      ..currentAtlas = atlas
      ..hasChanges = true;

    return state;
  }
}

class UpdateAtlasImageAction extends AsyncMicroStoreAction<FireAtlasState> {
  final String imageData;

  UpdateAtlasImageAction({required this.imageData});

  @override
  Future<FireAtlasState> perform(state) async {
    if (state.currentAtlas != null) {
      final atlas = state.currentAtlas!;

      state.hasChanges = true;
      atlas.imageData = imageData;
      await atlas.loadImage(clearImageData: false);
    }

    return state;
  }
}

class SetSelectionAction extends MicroStoreAction<FireAtlasState> {
  BaseSelection selection;

  SetSelectionAction({
    required this.selection,
  });

  @override
  FireAtlasState perform(FireAtlasState state) {
    final atlas = state.currentAtlas;
    if (atlas != null) {
      atlas.selections[selection.info.id] = selection;
      state.selectedSelection = selection;
      state.hasChanges = true;
    }

    return state;
  }
}

class SelectSelectionAction extends MicroStoreAction<FireAtlasState> {
  BaseSelection? selection;

  SelectSelectionAction({
    this.selection,
  });

  @override
  FireAtlasState perform(FireAtlasState state) {
    state.selectedSelection = selection;

    return state;
  }
}

class RemoveSelectedSelectionAction extends MicroStoreAction<FireAtlasState> {
  @override
  FireAtlasState perform(FireAtlasState state) {
    final atlas = state.currentAtlas;
    final selected = state.selectedSelection;

    if (atlas != null && selected != null) {
      atlas.selections.remove(selected.info.id);
      state.selectedSelection = null;
      state.hasChanges = true;
    }

    return state;
  }
}

class SaveAction extends MicroStoreAction<FireAtlasState> {
  @override
  FireAtlasState perform(FireAtlasState state) {
    if (state.currentAtlas != null) {
      FireAtlasStorage.saveProject(state.currentAtlas!);

      state.hasChanges = false;

      store.dispatch(CreateMessageAction(
        message: 'Atlas saved!',
        type: MessageType.INFO,
      ));
    }
    return state;
  }
}

class LoadAtlasAction extends AsyncMicroStoreAction<FireAtlasState> {
  String id;

  LoadAtlasAction(this.id);

  @override
  Future<FireAtlasState> perform(state) async {
    final atlas = FireAtlasStorage.loadProject(id);

    await atlas.loadImage(clearImageData: false);

    return state..currentAtlas = atlas;
  }
}
