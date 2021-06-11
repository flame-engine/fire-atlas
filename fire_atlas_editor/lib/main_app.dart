import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

import './screens/open_screen/open_screen.dart';
import './screens/editor_screen/editor_screen.dart';

import './store/store.dart';
import './theme.dart';

class _FireAtlasAppSlice extends Equatable {
  final ThemeMode currentTheme;

  _FireAtlasAppSlice.fromState(FireAtlasState state)
      : currentTheme = state.currentTheme;

  @override
  List<Object?> get props => [currentTheme];
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
      child: SliceWatcher<FireAtlasState, _FireAtlasAppSlice>(
        slicer: (state) => _FireAtlasAppSlice.fromState(state),
        builder: (context, store, slice) {
          return MaterialApp(
            title: 'Fire Atlas Editor',
            theme: theme,
            darkTheme: darkTheme,
            themeMode: slice.currentTheme,
            home: OpenScreen(),
            routes: {
              '/editor': (_) => EditorScreen(),
            },
          );
        },
      ),
    );
  }
}
