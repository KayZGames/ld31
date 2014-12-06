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
    var tileX = x ~/ tileSize;
    var tileY = y ~/ tileSize;
    return tileX * tileY + tileX;
  }
}
