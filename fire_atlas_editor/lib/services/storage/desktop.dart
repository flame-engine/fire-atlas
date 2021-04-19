import 'dart:io';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './storage.dart';

class FireAtlasStorage extends FireAtlasStorageApi {
  Future<LoadedProjectEntry> loadProject(String path) async {
    final file = File(path);
    final raw = await file.readAsBytes();
    final atlas = FireAtlas.deserialize(raw);
    return LoadedProjectEntry(path, atlas);
  }

  Future<void> saveProject(LoadedProjectEntry entry) async {
    final path = entry.path;
    if (path == null) {
      throw 'Tried to save an unsaved project';
    }
    final file = File(path);
    await file.writeAsBytes(entry.project.serialize());
  }

  Future<List<LastProjectEntry>> lastUsedProjects() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs
        .getKeys()
        .where((k) => k.startsWith('PROJECT_'))
        .map((k) => LastProjectEntry(prefs.getString(k)!, k))
        .toList();
  }

  Future<void> rememberProject(LoadedProjectEntry entry) async {
    final path = entry.path;
    if (path == null) {
      throw 'Tried to save an unsaved project';
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('PROJECT_${entry.project.id}', path);
  }

  Future<LoadedProjectEntry> selectProject() async {
    final typeGroup = XTypeGroup(label: 'fire atlas', extensions: ['fa']);
    final file = await _selectDialog(typeGroup);
    final bytes = await file.readAsBytes();
    final atlas = FireAtlas.deserialize(bytes);
    return LoadedProjectEntry(file.path, atlas);
  }

  Future<String> selectNewProjectPath(atlas) async {
    final file = await getSavePath(suggestedName: '${atlas.id}.fa');
    if (file == null) {
      throw 'Nothing selected';
    }
    return file;
  }

  Future<String> selectFile() async {
    final file = await _selectDialog();
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<XFile> _selectDialog([XTypeGroup? typeGroup]) async {
    final group = typeGroup ?? XTypeGroup();
    final file = await openFile(acceptedTypeGroups: [group]);
    if (file == null) {
      throw 'Not file selected';
    }

    return file;
  }

  @override
  Future<void> exportFile(List<int> bytes, String fileName) {
    throw 'Unsupported';
  }

  @override
  Future<void> setConfig(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CONFIG_$key', value);
  }

  @override
  Future<String> getConfig(String key, String defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CONFIG_$key') ?? defaultValue;
  }
}
