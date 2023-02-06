import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/rendering.dart';
import 'package:slices/slices.dart';

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
  Future<FireAtlasState> perform(_, FireAtlasState state) async {
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
  Future<FireAtlasState> perform(_, FireAtlasState state) async {
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
  final List<BaseSelection> selections;

  SetSelectionAction({
    required BaseSelection selection,
  }) : selections = [selection];

  SetSelectionAction.multiple({
    required this.selections,
  });

  @override
  FireAtlasState perform(_, FireAtlasState state) {
    final atlas = state.currentAtlas;
    if (atlas != null && selections.isNotEmpty) {
      for (final selection in selections) {
        atlas.selections[selection.id] = selection;
      }

      return state.copyWith(
        hasChanges: true,
        selectedSelection: Nullable(selections.last),
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
  FireAtlasState perform(_, FireAtlasState state) {
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
  Future<FireAtlasState> perform(
    SlicesStore<FireAtlasState> store,
    FireAtlasState state,
  ) async {
    final project = state.loadedProject.value;
    if (project != null) {
      try {
        final storage = FireAtlasStorage();

        final path =
            project.path ?? await storage.selectNewProjectPath(project.project);

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
        debugPrint(e.toString());
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

class RenameAtlasAction extends AsyncSlicesAction<FireAtlasState> {
  final String newAtlasId;

  RenameAtlasAction({required this.newAtlasId});

  @override
  Future<FireAtlasState> perform(
    SlicesStore<FireAtlasState> store,
    FireAtlasState state,
  ) async {
    final atlas = state.currentAtlas;
    if (atlas == null) {
      return state;
    }

    atlas.id = newAtlasId;
    return state.copyWith(
      hasChanges: true,
      loadedProject: Nullable(
        state.loadedProject.value?.copyWith(
          project: atlas,
        ),
      ),
    );
  }
}

class LoadAtlasAction extends AsyncSlicesAction<FireAtlasState> {
  final String path;

  LoadAtlasAction(this.path);

  @override
  Future<FireAtlasState> perform(_, FireAtlasState state) async {
    final storage = FireAtlasStorage();
    final loaded = await storage.loadProject(path);

    await loaded.project.loadImage(clearImageData: false);

    return state.copyWith(loadedProject: Nullable(loaded));
  }
}
