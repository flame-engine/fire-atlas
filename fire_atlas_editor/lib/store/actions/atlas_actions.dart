import 'package:meta/meta.dart';
import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../models/fire_atlas.dart';
import '../../services/storage.dart';

import './editor_actions.dart';

class CreateAtlasAction extends MicroStoreAction<FireAtlasState> {

  String id;
  String imageData;
  int tileSize;

  CreateAtlasAction({
    @required this.id,
    @required this.imageData,
    @required this.tileSize,
  });

  @override
  FireAtlasState perform(FireAtlasState state) {
    final atlas = FireAtlas()
        ..id = id
        ..imageData = imageData
        ..tileSize = tileSize;

    state
        ..currentAtlas = atlas
        ..hasChanges = true;

    return state;
  }
}

class UpdateAtlasAction extends MicroStoreAction<FireAtlasState> {
  final FireAtlas Function(FireAtlas) updateFn;

  UpdateAtlasAction({ this.updateFn });

  @override
  FireAtlasState perform(state) =>
    state
        ..currentAtlas = updateFn(state.currentAtlas)
        ..hasChanges = true;
        
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

class LoadAtlasAction extends MicroStoreAction<FireAtlasState> {
  String id;

  LoadAtlasAction(this.id);

  @override
  FireAtlasState perform(state) {
    final json = FireAtlasStorage.loadProject(id);

    return state
        ..currentAtlas = FireAtlas.fromJson(json);
  }
}
