import 'package:flutter/material.dart';

import './screens/open_screen/open_screen.dart';
import './screens/editor_screen/editor_screen.dart';

void main() {
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
