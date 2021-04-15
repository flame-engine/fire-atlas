export 'unsupported.dart'
    if (dart.library.html) 'web.dart'
    if (dart.library.io) 'mobile.dart';

import 'package:fire_atlas_editor/store/store.dart';
import 'package:flutter/material.dart';

abstract class FireAtlasStorageApi {
  Future<LoadedProjectEntry> loadProject(String path);
  Future<void> saveProject(LoadedProjectEntry entry);
  Future<List<LastProjectEntry>> lastUsedProjects();
  Future<void> rememberProject(LoadedProjectEntry entry);
  Future<LoadedProjectEntry> selectProject(BuildContext context);
  Future<String> selectFile(BuildContext context);
}
