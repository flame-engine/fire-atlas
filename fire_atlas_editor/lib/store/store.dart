import 'package:equatable/equatable.dart';
import 'package:slices/slices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:ui';

class Nullable<T> {
  final T? value;

  Nullable(this.value);
}

@immutable
class LoadedProjectEntry {
  final String? path;
  final FireAtlas project;

  LoadedProjectEntry(this.path, this.project);

  LastProjectEntry toLastProjectEntry() {
    final currentPath = path;
    if (currentPath == null) {
      throw 'Unable to transform an unsaved project to last project entry';
    }
    return LastProjectEntry(
      currentPath,
      project.id,
    );
  }

  LoadedProjectEntry copyWith({
    String? path,
    FireAtlas? project,
  }) {
    return LoadedProjectEntry(
      path ?? this.path,
      project ?? this.project,
    );
  }
}

@immutable
class LastProjectEntry {
  final String path;
  final String name;

  LastProjectEntry(this.path, this.name);
}

enum MessageType {
  ERROR,
  INFO,
}

@immutable
class Message extends Equatable {
  final MessageType type;
  final String message;

  Message({
    required this.type,
    required this.message,
  });

  @override
  List<Object?> get props => [type, message];
}

@immutable
class ModalState extends Equatable {
  final Widget child;
  final double width;
  final double? height;

  ModalState({
    required this.child,
    required this.width,
    this.height,
  });

  @override
  List<Object?> get props => [child, width, height];
}

class FireAtlasState extends SlicesState {
  final Nullable<LoadedProjectEntry> loadedProject;
  final Nullable<BaseSelection> _selectedSelection;
  final Nullable<Rect> _canvasSelection;
  final Nullable<ModalState> _modal;
  final bool hasChanges;
  final List<Message> messages;
  final ThemeMode currentTheme;

  FireAtlasState({
    this.hasChanges = false,
    this.messages = const [],
    required this.loadedProject,
    required Nullable<BaseSelection> selectedSelection,
    required Nullable<Rect> canvasSelection,
    required Nullable<ModalState> modal,
    required this.currentTheme,
  })  : _selectedSelection = selectedSelection,
        _canvasSelection = canvasSelection,
        _modal = modal;

  FireAtlasState.empty({required this.currentTheme})
      : loadedProject = Nullable(null),
        _selectedSelection = Nullable(null),
        _canvasSelection = Nullable(null),
        _modal = Nullable(null),
        hasChanges = false,
        messages = [];

  FireAtlasState copyWith({
    Nullable<LoadedProjectEntry>? loadedProject,
    Nullable<BaseSelection>? selectedSelection,
    Nullable<ModalState>? modal,
    Nullable<Rect>? canvasSelection,
    List<Message>? messages,
    bool? hasChanges,
    ThemeMode? currentTheme,
  }) {
    return FireAtlasState(
      loadedProject: loadedProject ?? this.loadedProject,
      hasChanges: hasChanges ?? this.hasChanges,
      messages: messages ?? this.messages,
      selectedSelection: selectedSelection ?? this._selectedSelection,
      modal: modal ?? this._modal,
      canvasSelection: canvasSelection ?? this._canvasSelection,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }

  FireAtlas? get currentAtlas => loadedProject.value?.project;
  BaseSelection? get selectedSelection => _selectedSelection.value;
  ModalState? get modal => _modal.value;
  Rect? get canvasSelection => _canvasSelection.value;
}
