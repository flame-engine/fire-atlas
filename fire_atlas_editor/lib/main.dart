import 'package:flutter/material.dart';

import './vendor/micro_store/micro_store.dart';

import './screens/open_screen/open_screen.dart';
import './screens/editor_screen/editor_screen.dart';

import './store/store.dart';
import './models/fire_atlas.dart';

void main() {
  //Store.instance = MicroStore<FireAtlasState>(FireAtlasState());

  final atlas = FireAtlas()
      ..id = 'Ingredients'
      ..tileSize = 16
      ..imageData = 'data:image/png;base64,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';

  Store.instance = MicroStore<FireAtlasState>(
      FireAtlasState()
        ..currentAtlas = atlas
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flame Texture Atlas Editor',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OpenScreen(),
      routes: {
        '/editor': (_) => EditorScreen(),
      }
    );
  }
}
