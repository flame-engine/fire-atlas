import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:ui';

class LoadedProjectEntry {
  String? path;
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
 
  LoadedProjectEntry update({
    String? path,
    FireAtlas? project,
  }) {
    return LoadedProjectEntry(
        path ?? this.path,
        project ?? this.project,
    );
  }
}

class LastProjectEntry {
  String path;
  String name;

  LastProjectEntry(this.path, this.name);
}

enum MessageType {
  ERROR,
  INFO,
}

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

class FireAtlasState {
  LoadedProjectEntry? loadedProject;
  bool hasChanges = false;
  BaseSelection? selectedSelection;
  ModalState? modal;
  List<Message> messages = [];
  Rect? canvasSelection;

  FireAtlas? get currentAtlas => loadedProject?.project;
  
  void set currentAtlas(FireAtlas? atlas) {
    if (atlas == null) {
      throw "Can't set a null atlas";
    }

    final project = loadedProject;
    if (project != null) {
      loadedProject = project.update(project: atlas);
    } else {
      loadedProject = LoadedProjectEntry(null, atlas);
    }
  }
}
