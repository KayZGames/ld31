part of shared;

class ButtonManager extends Manager {
  Mapper<Transform> tm;
  Mapper<Button> bm;
  Map<int, Entity> buttons = new Map<int, Entity>();

  @override
  void added(Entity entity) {
    if (bm.has(entity)) {
      var t = tm[entity];
      buttons[getTileIndex(t.x, t.y)] = entity;
    }
  }

  int getTileIndex(num x, num y) {
    var tileX = 1 + x ~/ tileSize;
    var tileY = 1 + y ~/ tileSize;
    return tileY * (1920 ~/ tileSize + 2) + tileX;
  }
}
