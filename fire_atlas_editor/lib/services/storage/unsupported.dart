import 'package:fire_atlas_editor/store/store.dart';

import './storage.dart';

class FireAtlasStorage extends FireAtlasStorageApi {
  @override
  Future<LoadedProjectEntry> loadProject(String path) {
    throw 'Unsupported';
  }

  @override
  Future<void> saveProject(LoadedProjectEntry entry) {
    throw 'Unsupported';
  }

  @override
  Future<List<LastProjectEntry>> lastUsedProjects() {
    throw 'Unsupported';
  }

  @override
  Future<void> rememberProject(LoadedProjectEntry entry) {
    throw 'Unsupported';
  }

  @override
  Future<LoadedProjectEntry> selectProject() {
    throw 'Unsupported';
  }

  @override
  Future<String> selectFile() {
    throw 'Unsupported';
  }

  @override
  Future<String> selectNewProjectPath(_) {
    throw 'Unsupported';
  }

  @override
  Future<void> exportFile(List<int> bytes, String fileName) {
    throw 'Unsupported';
  }

  @override
  Future<void> setConfig(String key, String value) {
    throw 'Unsupported';
  }

  @override
  Future<String> getConfig(String key, String defaulValue) {
    throw 'Unsupported';
  }
}
