import 'package:flutter/material.dart';

import './vendor/slices/slices.dart';

import './screens/open_screen/open_screen.dart';
import './screens/editor_screen/editor_screen.dart';

import './store/store.dart';

void main() {
  final store = SlicesStore<FireAtlasState>(FireAtlasState());

  runApp(FireAtlasApp(store: store));
}

class FireAtlasApp extends StatelessWidget {
  final SlicesStore<FireAtlasState> store;

  FireAtlasApp({
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return SlicesProvider(
      store: store,
      child: MaterialApp(
        title: 'Fire Atlas Editor',
        theme: ThemeData(
          primaryColor: Color(0XFFD20101),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Color(0XFFDB5B42),
        ),
        home: OpenScreen(),
        routes: {
          '/editor': (_) => EditorScreen(),
        },
      ),
    );
  }
}
