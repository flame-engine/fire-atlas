import 'package:flutter/material.dart';
import 'package:fire_atlas_editor/services/storage/storage.dart';

import './vendor/slices/slices.dart';
import './store/store.dart';
import './main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FireAtlasStorage();
  final themeValue =
      await storage.getConfig(kThemeMode, ThemeMode.light.toString());
  final currentTheme = themeValue == ThemeMode.light.toString()
      ? ThemeMode.light
      : ThemeMode.dark;
  final store = SlicesStore<FireAtlasState>(
    FireAtlasState.empty(
      currentTheme: currentTheme,
    ),
  );

  runApp(FireAtlasApp(store: store));
}
