
import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:fire_atlas_editor/services/storage/storage.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

class FireAtlasStorage extends FireAtlasStorageApi{
  static final Storage _localStorage = window.localStorage;

  Future<LoadedProjectEntry> loadProject(String path) {
    final value = _localStorage[path];
    if (value == null) {
      throw 'Unknow project with id $path';
    }

    final entry = LoadedProjectEntry(
        path,
        _readBase64Project(value),
    );

    return Future.value(entry);
  }

  Future<void> saveProject(LoadedProjectEntry entry) async {
    final data = entry.project.serialize();

    if (entry.path == null) {
      entry.path = 'ATLAS_${entry.project.id}';
    }

    _localStorage[entry.path!] = base64Encode(data);
  }

  Future<List<LastProjectEntry>> lastUsedProjects() async {
    return _localStorage.entries
        .map((e) => e.key)
        .where((k) => k.startsWith('ATLAS_'))
        .map((k) {
          final name = k.replaceFirst('ATLAS_', '');
          return LastProjectEntry(k, name);
        })
    .toList();
  }

  Future<void> rememberProject(LoadedProjectEntry entry) async {
    // On web saving a project is to cache it on the localStorage, so here
    // we can just save the project
    await saveProject(entry);
  }

  FireAtlas _readBase64Project(String base64) {
    final jsonRaw = base64Decode(base64);

    return FireAtlas.deserialize(jsonRaw);
  }

  Future<LoadedProjectEntry> selectProject(_) async {
    final fileData = await selectFile(_);
    final base64 = fileData.substring(fileData.indexOf(',') + 1);
    final atlas = _readBase64Project(base64);


    return LoadedProjectEntry(
        'ATLAS_${atlas.id}',
        atlas,
    );
  }

  @override
  Future<String> selectFile(_) {
    final completer = Completer<String>();
    final uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files ?? [];
      if (files.length == 1) {
        final file = files[0];
        final reader = new FileReader();

        reader.onLoadEnd.listen((e) {
          if (reader.result != null) {
            completer.complete(reader.result! as String);
          }
        });
        reader.readAsDataUrl(file);
      }
    });

    return completer.future;
  }
}
