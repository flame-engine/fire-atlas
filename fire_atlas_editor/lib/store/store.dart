import 'package:equatable/equatable.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:slices/slices.dart';

class Nullable<T> {
  final T? value;

  Nullable(this.value);
}

@immutable
class LoadedProjectEntry {
  final String? path;
  final String? lastUsedImage;
  final FireAtlas project;

  const LoadedProjectEntry(
    this.path,
    this.project,
    this.lastUsedImage,
  );

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
    String? lastUsedImage,
    FireAtlas? project,
  }) {
    return LoadedProjectEntry(
      path ?? this.path,
      project ?? this.project,
      lastUsedImage ?? this.lastUsedImage,
    );
  }
}

@immutable
class LastProjectEntry {
  final String path;
  final String name;

  const LastProjectEntry(this.path, this.name);
}

enum MessageType {
  ERROR,
  INFO,
}

@immutable
class Message extends Equatable {
  final MessageType type;
  final String message;

  const Message({
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

  const ModalState({
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
    required this.loadedProject,
    required Nullable<BaseSelection> selectedSelection,
    required Nullable<Rect> canvasSelection,
    required Nullable<ModalState> modal,
    required this.currentTheme,
    this.hasChanges = false,
    this.messages = const [],
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
      selectedSelection: selectedSelection ?? _selectedSelection,
      modal: modal ?? _modal,
      canvasSelection: canvasSelection ?? _canvasSelection,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }

  FireAtlas? get currentAtlas => loadedProject.value?.project;
  BaseSelection? get selectedSelection => _selectedSelection.value;
  ModalState? get modal => _modal.value;
  Rect? get canvasSelection => _canvasSelection.value;
}
