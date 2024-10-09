import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/store.dart';

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
  Future<(String, String, String)> selectFile() {
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
  Future<String> getConfig(String key, String defaultValue) {
    throw 'Unsupported';
  }

  @override
  Future<String?> getProjectLastImageFile(String projectId) {
    throw 'Unsupported';
  }

  @override
  Future<String> readImageData(String path) {
    throw 'Unsupported';
  }

  @override
  Future<void> rememberProjectImageFile(String projectId, String imageFile) {
    throw 'Unsupported';
  }
}
