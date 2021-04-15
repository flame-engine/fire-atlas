import 'package:fire_atlas_editor/store/store.dart';

import './storage.dart';

class FireAtlasStorage extends FireAtlasStorageApi {
  Future<LoadedProjectEntry> loadProject(String path) {
    throw 'Unsupported';
  }

  Future<void> saveProject(LoadedProjectEntry entry) {
    throw 'Unsupported';
  }

  Future<List<LastProjectEntry>> lastUsedProjects() {
    throw 'Unsupported';
  }

  Future<void> rememberProject(LoadedProjectEntry entry) {
    throw 'Unsupported';
  }

  Future<LoadedProjectEntry> selectProject(_) {
    throw 'Unsupported';
  }

  Future<String> selectFile(_) {
    throw 'Unsupported';
  }

  @override
  Future<void> exportFile(List<int> bytes, String fileName) {
    throw 'Unsupported';
  }
}
