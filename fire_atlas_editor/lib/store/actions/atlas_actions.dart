import '../../vendor/slices/slices.dart';
import '../../store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import '../../services/storage/storage.dart';

import './editor_actions.dart';

class CreateAtlasAction extends AsyncSlicesAction<FireAtlasState> {
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

class UpdateAtlasImageAction extends AsyncSlicesAction<FireAtlasState> {
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

class SetSelectionAction extends SlicesAction<FireAtlasState> {
  BaseSelection selection;

  SetSelectionAction({
    required this.selection,
  });

  @override
  FireAtlasState perform(FireAtlasState state) {
    final atlas = state.currentAtlas;
    if (atlas != null) {
      atlas.selections[selection.id] = selection;
      state.selectedSelection = selection;
      state.hasChanges = true;
    }

    return state;
  }
}

class SelectSelectionAction extends SlicesAction<FireAtlasState> {
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

class RemoveSelectedSelectionAction extends SlicesAction<FireAtlasState> {
  @override
  FireAtlasState perform(FireAtlasState state) {
    final atlas = state.currentAtlas;
    final selected = state.selectedSelection;

    if (atlas != null && selected != null) {
      atlas.selections.remove(selected.id);
      state.selectedSelection = null;
      state.hasChanges = true;
    }

    return state;
  }
}

class SaveAction extends SlicesAction<FireAtlasState> {
  @override
  FireAtlasState perform(FireAtlasState state) {
    final project = state.loadedProject;
    if (project != null) {
      final storage = FireAtlasStorage();
      storage.saveProject(project);

      state.hasChanges = false;

      store.dispatch(CreateMessageAction(
        message: 'Atlas saved!',
        type: MessageType.INFO,
      ));
    }
    return state;
  }
}

class LoadAtlasAction extends AsyncSlicesAction<FireAtlasState> {
  String path;

  LoadAtlasAction(this.path);

  @override
  Future<FireAtlasState> perform(state) async {
    final storage = FireAtlasStorage();
    final loaded = await storage.loadProject(path);

    await loaded.project.loadImage(clearImageData: false);

    return state..loadedProject = loaded;
  }
}
