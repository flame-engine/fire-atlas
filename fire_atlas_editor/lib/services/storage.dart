import 'dart:html';
import 'dart:convert';

import '../models/fire_atlas.dart';

class FireAtlasStorage {
  static final Storage _localStorage = window.localStorage;

  static Map<String, dynamic> loadProject(String id) {
    final jsonRaw = _localStorage['ATLAS_$id'];

    if (jsonRaw != null) {
      return jsonDecode(jsonRaw);
    }

    return null;
  }

  static void saveProject(FireAtlas atlas) {
    final data = jsonEncode(atlas.toJson());

    _localStorage['ATLAS_${atlas.id}'] = data;
  }

  static List<String> listProjects() =>
    _localStorage.entries
        .map((e) => e.key)
        .where((k) => k.startsWith('ATLAS_'))
        .map((k) => k.replaceFirst('ATLAS_', ''))
        .toList();
}

