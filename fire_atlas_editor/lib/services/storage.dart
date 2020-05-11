import 'dart:html';
import 'dart:convert';

import 'package:flame_fire_atlas/flame_fire_atlas.dart';

class FireAtlasStorage {
  static final Storage _localStorage = window.localStorage;

  static FireAtlas loadProject(String id) {
    final jsonRaw = base64Decode(_localStorage['ATLAS_$id']);

    if (jsonRaw != null) {
      return FireAtlas.deserialize(jsonRaw);
    }

    return null;
  }

  static void saveProject(FireAtlas atlas) {
    final data = atlas.serialize();

    _localStorage['ATLAS_${atlas.id}'] = base64Encode(data);
  }

  static List<String> listProjects() =>
    _localStorage.entries
        .map((e) => e.key)
        .where((k) => k.startsWith('ATLAS_'))
        .map((k) => k.replaceFirst('ATLAS_', ''))
        .toList();
}

