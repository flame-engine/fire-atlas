import 'dart:html';
import 'dart:convert';

import 'package:flame_fire_atlas/flame_fire_atlas.dart';

class FireAtlasStorage {
  static final Storage _localStorage = window.localStorage;

  static FireAtlas readBase64Project(String base64) {
    final jsonRaw = base64Decode(base64);

    if (jsonRaw != null) {
      return FireAtlas.deserialize(jsonRaw);
    }

    return null;
  }

  static FireAtlas loadProject(String id) {
    return readBase64Project(_localStorage['ATLAS_$id']);
  }

  static String saveProject(FireAtlas atlas) {
    final data = atlas.serialize();
    final id = 'ATLAS_${atlas.id}';

    _localStorage[id] = base64Encode(data);

    return id;
  }

  static List<String> listProjects() => _localStorage.entries
      .map((e) => e.key)
      .where((k) => k.startsWith('ATLAS_'))
      .map((k) => k.replaceFirst('ATLAS_', ''))
      .toList();
}
