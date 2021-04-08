import 'package:flutter/widgets.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';

import 'dart:ui';

import '../vendor/micro_store/micro_store.dart';

enum MessageType {
  ERROR,
  INFO,
}

class Message {
  MessageType type;
  String message;

  Message({
    required this.type,
    required this.message,
  });
}

class ModalState {
  Widget child;
  double width;
  double? height;

  ModalState({
    required this.child,
    required this.width,
    this.height,
  });
}

class FireAtlasState {
  FireAtlas? currentAtlas;
  bool hasChanges = false;
  BaseSelection? selectedSelection;
  ModalState? modal;
  List<Message> messages = [];
  Rect? canvasSelection;
}

class Store {
  static late MicroStore<FireAtlasState> instance;
}
