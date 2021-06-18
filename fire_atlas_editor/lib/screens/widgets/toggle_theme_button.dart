import 'package:equatable/equatable.dart';
import 'package:fire_atlas_editor/store/actions/editor_actions.dart';
import 'package:fire_atlas_editor/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

import '../../store/store.dart';

class _ToggleThemeButtonSlice extends Equatable {
  final ThemeMode currentTheme;

  _ToggleThemeButtonSlice.fromState(FireAtlasState state)
      : currentTheme = state.currentTheme;

  @override
  List<Object?> get props => [currentTheme];
}

class ToggleThemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliceWatcher<FireAtlasState, _ToggleThemeButtonSlice>(
      slicer: (state) => _ToggleThemeButtonSlice.fromState(state),
      builder: (context, store, slice) {
        return FIconButton(
          iconData: slice.currentTheme == ThemeMode.light
              ? Icons.wb_sunny
              : Icons.nightlight_round,
          onPress: () {
            store.dispatchAsync(ToggleThemeAction());
          },
          tooltip: slice.currentTheme == ThemeMode.light
              ? 'Change to dark mode'
              : 'Change to light mode',
        );
      },
    );
  }
}
