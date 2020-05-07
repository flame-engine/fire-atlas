import 'package:meta/meta.dart';
import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../models/fire_atlas.dart';
import '../../services/storage.dart';

class SetAtlasAction extends MicroStoreAction<FireAtlasState> {

  String id;
  String imageData;
  int tileSize;

  SetAtlasAction({
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

    state.currentAtlas = atlas;

    return state;
  }
}

class AddSelectionAction extends MicroStoreAction<FireAtlasState> {

  Selection selection;

  AddSelectionAction({
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

class SaveAction extends MicroStoreAction<FireAtlasState> {

  @override
  FireAtlasState perform(FireAtlasState state) {
    FireAtlasStorage.saveProject(state.currentAtlas);

    state.hasChanges = false;

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
