import 'package:flutter/widgets.dart';
import '../vendor/micro_store/micro_store.dart';
import '../models/fire_atlas.dart';

class ModalState {
  Widget child;
  double width;
}

class FireAtlasState {
  FireAtlas currentAtlas;
  Selection selectedSelection;
  ModalState modal;
}

class Store {
  static MicroStore<FireAtlasState> instance;
}
