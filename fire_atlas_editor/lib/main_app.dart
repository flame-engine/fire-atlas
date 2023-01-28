import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/screens/editor_screen/editor_screen.dart';
import 'package:fire_atlas_editor/screens/open_screen/open_screen.dart';
import 'package:fire_atlas_editor/store/store.dart';
import 'package:fire_atlas_editor/theme.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class _FireAtlasAppSlice extends Equatable {
  final ThemeMode currentTheme;

  _FireAtlasAppSlice.fromState(FireAtlasState state)
      : currentTheme = state.currentTheme;

  @override
  List<Object?> get props => [currentTheme];
}

class FireAtlasApp extends StatelessWidget {
  final SlicesStore<FireAtlasState> store;

  const FireAtlasApp({
    Key? key,
    required this.store,
  }) : super(key: key);

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
            home: const OpenScreen(),
            routes: {
              '/editor': (_) => const EditorScreen(),
            },
          );
        },
      ),
    );
  }
}
