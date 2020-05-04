abstract class Selection {
  String id;
  int x;
  int y;
  int w;
  int h;
}

class SpriteSelection extends Selection { }

class AnimationSelection extends Selection {
  int frameCount;
  List<double> timeSteps = [];
  bool loop;
}

class FireAtlas {
  String id;
  int tileSize;
  String imageData;

  List<Selection> selections = [];
}
