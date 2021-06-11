import 'package:slices/slices.dart';
import '../../store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import '../../services/storage/storage.dart';

import './editor_actions.dart';

class CreateAtlasAction extends AsyncSlicesAction<FireAtlasState> {
  final String id;
  final String imageData;
  final double tileWidth;
  final double tileHeight;

  CreateAtlasAction({
    required this.id,
    required this.imageData,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<FireAtlasState> perform(_, state) async {
    final atlas = FireAtlas(
      id: id,
      imageData: imageData,
      tileHeight: tileHeight,
      tileWidth: tileWidth,
    );

    await atlas.loadImage(clearImageData: false);

    return state.copyWith(
      hasChanges: true,
      loadedProject: Nullable(
        LoadedProjectEntry(null, atlas),
      ),
    );
  }
}

class UpdateAtlasImageAction extends AsyncSlicesAction<FireAtlasState> {
  final String imageData;

  UpdateAtlasImageAction({required this.imageData});

  @override
  Future<FireAtlasState> perform(_, state) async {
    if (state.currentAtlas != null) {
      final atlas = state.currentAtlas!;

      atlas.imageData = imageData;
      await atlas.loadImage(clearImageData: false);

      return state.copyWith(
        hasChanges: true,
        loadedProject: Nullable(
          state.loadedProject.value?.copyWith(project: atlas),
        ),
      );
    }

    return state;
  }
}

class SetSelectionAction extends SlicesAction<FireAtlasState> {
  final BaseSelection selection;

  SetSelectionAction({
    required this.selection,
  });

  @override
  FireAtlasState perform(_, state) {
    final atlas = state.currentAtlas;
    if (atlas != null) {
      atlas.selections[selection.id] = selection;

      return state.copyWith(
        hasChanges: true,
        selectedSelection: Nullable(selection),
        loadedProject: Nullable(
          state.loadedProject.value?.copyWith(project: atlas),
        ),
      );
    }

    return state;
  }
}

class SelectSelectionAction extends SlicesAction<FireAtlasState> {
  final BaseSelection? selection;

  SelectSelectionAction({
    this.selection,
  });

  @override
  FireAtlasState perform(_, FireAtlasState state) {
    return state.copyWith(
      selectedSelection: Nullable(selection),
    );
  }
}

class RemoveSelectedSelectionAction extends SlicesAction<FireAtlasState> {
  @override
  FireAtlasState perform(_, state) {
    final atlas = state.currentAtlas;
    final selected = state.selectedSelection;

    if (atlas != null && selected != null) {
      atlas.selections.remove(selected.id);
      return state.copyWith(
        hasChanges: true,
        selectedSelection: Nullable(null),
        loadedProject: Nullable(
          state.loadedProject.value?.copyWith(project: atlas),
        ),
      );
    }

    return state;
  }
}

class SaveAction extends AsyncSlicesAction<FireAtlasState> {
  @override
  Future<FireAtlasState> perform(store, state) async {
    final project = state.loadedProject.value;
    if (project != null) {
      try {
        final storage = FireAtlasStorage();

        final path = project.path == null
            ? await storage.selectNewProjectPath(project.project)
            : project.path;

        final newState = state.copyWith(
          hasChanges: false,
          loadedProject: Nullable(
            state.loadedProject.value?.copyWith(path: path),
          ),
        );

        await storage.saveProject(newState.loadedProject.value!);
        await storage.rememberProject(newState.loadedProject.value!);

        store.dispatch(
          CreateMessageAction(
            message: 'Atlas saved!',
            type: MessageType.INFO,
          ),
        );

        return newState;
      } catch (e) {
        print(e);
        store.dispatch(
          CreateMessageAction(
            message: 'Error trying to save project!',
            type: MessageType.ERROR,
          ),
        );
      }
    }
    return state;
  }
}

class LoadAtlasAction extends AsyncSlicesAction<FireAtlasState> {
  final String path;

  LoadAtlasAction(this.path);

  @override
  Future<FireAtlasState> perform(_, state) async {
    final storage = FireAtlasStorage();
    final loaded = await storage.loadProject(path);

    await loaded.project.loadImage(clearImageData: false);

    return state.copyWith(loadedProject: Nullable(loaded));
  }
}
