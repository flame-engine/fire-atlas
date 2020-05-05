import 'package:meta/meta.dart';
import '../../vendor/micro_store/micro_store.dart';
import '../../store/store.dart';
import '../../models/fire_atlas.dart';

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
    state.currentAtlas.selections.add(selection);

    return state;
  }
}
