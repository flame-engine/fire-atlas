import 'package:meta/meta.dart';
import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import '../../services/storage.dart';

import './editor_actions.dart';

class CreateAtlasAction extends AsyncMicroStoreAction<FireAtlasState> {

  String id;
  String imageData;
  int tileSize;

  CreateAtlasAction({
    @required this.id,
    @required this.imageData,
    @required this.tileSize,
  });

  @override
  Future<FireAtlasState> perform(FireAtlasState state) async {
    final atlas = FireAtlas()
        ..id = id
        ..imageData = imageData
        ..tileSize = tileSize;

    await atlas.load(clearImageData: false);

    state
        ..currentAtlas = atlas
        ..hasChanges = true;

    return state;
  }
}

class UpdateAtlasImageAction extends AsyncMicroStoreAction<FireAtlasState> {
  final String imageData;

  UpdateAtlasImageAction({ this.imageData });

  @override
  Future<FireAtlasState> perform(state) async {
    state
        ..currentAtlas.imageData = imageData
        ..hasChanges = true;

    await state.currentAtlas.load(clearImageData: false);

    return state;
  }
}

class SetSelectionAction extends MicroStoreAction<FireAtlasState> {

  Selection selection;

  SetSelectionAction({
    @required this.selection,
  });

  @override
  FireAtlasState perform(FireAtlasState state) {
    state.currentAtlas.selections[selection.id] = selection;
    state.selectedSelection = selection;
    state.hasChanges = true;

    return state;
  }
}

class SelectSelectionAction extends MicroStoreAction<FireAtlasState> {

  Selection selection;

  SelectSelectionAction({
    @required this.selection,
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
    state.currentAtlas.selections.remove(state.selectedSelection.id);
    state.selectedSelection = null;
    state.hasChanges = true;

    return state;
  }
}

class SaveAction extends MicroStoreAction<FireAtlasState> {

  @override
  FireAtlasState perform(FireAtlasState state) {
    FireAtlasStorage.saveProject(state.currentAtlas);

    state.hasChanges = false;

    store.dispatch(CreateMessageAction(
        message: 'Atlas saved!',
        type: MessageType.INFO,
    ));

    return state;
  }

}

class LoadAtlasAction extends AsyncMicroStoreAction<FireAtlasState> {
  String id;

  LoadAtlasAction(this.id);

  @override
  Future<FireAtlasState> perform(state) async {
    final atlas = FireAtlasStorage.loadProject(id);

    await atlas.load(clearImageData: false);

    return state..currentAtlas = atlas;
  }
}
