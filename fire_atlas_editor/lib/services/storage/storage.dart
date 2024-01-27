import 'package:fire_atlas_editor/store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'desktop.dart';

const kThemeMode = 'THEME_MODE';

abstract class FireAtlasStorageApi {
  Future<LoadedProjectEntry> loadProject(String path);
  Future<void> saveProject(LoadedProjectEntry entry);
  Future<List<LastProjectEntry>> lastUsedProjects();
  Future<void> rememberProject(LoadedProjectEntry entry);
  Future<String> selectNewProjectPath(FireAtlas atlas);
  Future<LoadedProjectEntry> selectProject();
  Future<(String, String)> selectFile();
  Future<void> exportFile(List<int> bytes, String fileName);
  Future<void> setConfig(String key, String value);
  Future<String> getConfig(String key, String defaultValue);
}
