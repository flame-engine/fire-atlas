import 'package:flutter/widgets.dart';
import '../vendor/micro_store/micro_store.dart';
import '../models/fire_atlas.dart';

enum MessageType {
  ERROR, INFO,
}

class Message {
  MessageType type;
  String message;
}

class ModalState {
  Widget child;
  double width;
  double height;
}

class FireAtlasState {
  FireAtlas currentAtlas;
  bool hasChanges = false;
  Selection selectedSelection;
  ModalState modal;
  List<Message> messages = [];
}

class Store {
  static MicroStore<FireAtlasState> instance;
}
