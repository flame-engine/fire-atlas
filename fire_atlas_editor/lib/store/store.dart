import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:ui';

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
  FireAtlas? currentAtlas;
  bool hasChanges = false;
  BaseSelection? selectedSelection;
  ModalState? modal;
  List<Message> messages = [];
  Rect? canvasSelection;
}
