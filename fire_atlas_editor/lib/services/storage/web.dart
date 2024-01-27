import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

class FireAtlasStorage extends FireAtlasStorageApi {
  static final Storage _localStorage = window.localStorage;

  @override
  Future<LoadedProjectEntry> loadProject(String path) async {
    final value = _localStorage[path];
    if (value == null) {
      throw 'Unknown project with id $path';
    }

    final entry = LoadedProjectEntry(
      path,
      _readBase64Project(value),
    );

    return entry;
  }

  @override
  Future<void> saveProject(LoadedProjectEntry entry) async {
    final path = entry.path;
    if (path == null) {
      throw 'Tried to save project without path';
    }

    final data = entry.project.serialize();

    _localStorage[path] = base64Encode(data);
  }

  @override
  Future<List<LastProjectEntry>> lastUsedProjects() async {
    return _localStorage.keys.where((k) => k.startsWith('ATLAS_')).map((k) {
      final name = k.replaceFirst('ATLAS_', '');
      return LastProjectEntry(k, name);
    }).toList();
  }

  @override
  Future<void> rememberProject(LoadedProjectEntry entry) async {
    // On web saving a project is to cache it on the localStorage, so here
    // we can just save the project
    await saveProject(entry);
  }

  @override
  Future<LoadedProjectEntry> selectProject() async {
    final fileData = await selectFile();
    final base64 = fileData.$2.substring(fileData.$2.indexOf(',') + 1);
    final atlas = _readBase64Project(base64);

    return LoadedProjectEntry(
      'ATLAS_${atlas.id}',
      atlas,
    );
  }

  @override
  Future<String> selectNewProjectPath(FireAtlas atlas) async {
    return 'ATLAS_${atlas.id}';
  }

  @override
  Future<(String, String)> selectFile() {
    final completer = Completer<(String, String)>();
    final uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files ?? [];
      if (files.length == 1) {
        final file = files[0];
        final reader = FileReader();

        reader.onLoadEnd.listen((e) {
          final result = reader.result;
          if (result != null) {
            completer.complete((file.name, result as String));
          }
        });
        reader.readAsDataUrl(file);
      }
    });

    return completer.future;
  }

  @override
  Future<void> exportFile(List<int> bytes, String fileName) async {
    final uint8List = Uint8List.fromList(bytes);
    final blob = Blob(<Uint8List>[uint8List]);
    final url = Url.createObjectUrl(blob);

    final element = document.createElement('a');
    element.setAttribute('href', url);
    element.setAttribute('download', fileName);

    element.click();
  }

  @override
  Future<void> setConfig(String key, String value) async {
    _localStorage['CONFIG_$key'] = value;
  }

  @override
  Future<String> getConfig(String key, String defaultValue) async {
    return _localStorage['CONFIG_$key'] ?? defaultValue;
  }

  FireAtlas _readBase64Project(String base64) {
    final jsonRaw = base64Decode(base64);

    return FireAtlas.deserialize(jsonRaw);
  }
}
