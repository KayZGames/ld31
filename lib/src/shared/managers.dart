part of shared;

int getTileIndex(num x, num y) {
  if (x < -tileSize || y < -tileSize || x > 1920 || y > 1080) return null;
  var tileX = 1 + x ~/ tileSize;
  var tileY = 1 + y ~/ tileSize;
  return tileY * (1920 ~/ tileSize + 2) + tileX;
}

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
}

class ItemMaterializationManager extends Manager {
  Mapper<Transform> tm;
  Mapper<ItemMaterializer> imm;

  Map<int, Entity> itemMats = new Map<int, Entity>();

  @override
  void added(Entity entity) {
    if (imm.has(entity)) {
      var t = tm[entity];
      itemMats[getTileIndex(t.x, t.y)] = entity;
    }
  }

  void materialize(num xStart, num yStart, int directionX, int directionY) {
    xStart = xStart + directionX * tileSize;
    yStart = yStart + directionY * tileSize;

    var pattern = [0, 1, 2, 3, 4, 5, 4, 2];
    if (directionX == 1) {
      for (num x = xStart; x < xStart + directionX * 8 * tileSize; x += tileSize) {
        var distance = (x - xStart).abs() ~/ tileSize;
        for (num y = yStart - tileSize * pattern[distance]; y <= yStart + tileSize * pattern[distance]; y += tileSize) {
          materializeItem(x, y);
        }
      }
    }
    if (directionX == -1) {
      for (num x = xStart; x > xStart + directionX * 8 * tileSize; x -= tileSize) {
        var distance = (x - xStart).abs() ~/ tileSize;
        for (num y = yStart - tileSize * pattern[distance]; y <= yStart + tileSize * pattern[distance]; y += tileSize) {
          materializeItem(x, y);
        }
      }
    }
    if (directionY == 1) {
      for (num y = yStart; y < yStart + directionY * 8 * tileSize; y += tileSize) {
        var distance = (y - yStart).abs() ~/ tileSize;
        for (num x = xStart - tileSize * pattern[distance]; x <= xStart + tileSize * pattern[distance]; x += tileSize) {
          materializeItem(x, y);
        }
      }
    }
    if (directionY == -1) {
      for (num y = yStart; y > yStart + directionY * 8 * tileSize; y -= tileSize) {
        var distance = (y - yStart).abs() ~/ tileSize;
        for (num x = xStart - tileSize * pattern[distance]; x <= yStart + tileSize * pattern[distance]; x += tileSize) {
          materializeItem(x, y);
        }
      }
    }
  }

  void materializeItem(num x, num y) {
    var tileIndex = getTileIndex(x, y);
    var itemMat = itemMats[tileIndex];
    if (null != itemMat) {
      var im = imm[itemMat];
      if (im.condition()) {
        var t = tm[itemMat];
        world.createAndAddEntity([new Transform(t.x, t.y), new Renderable(im.item), new ObjectLayer(), new Item(im.item)]);
        itemMat.deleteFromWorld();
        itemMats.remove(tileIndex);

        world.createAndAddEntity([new Sound('materialization')]);
      }
    }
  }
}

class ItemManager extends Manager {
  Mapper<Transform> tm;
  Mapper<Item> im;
  Map<int, Entity> items = new Map<int, Entity>();

  @override
  void added(Entity entity) {
    if (im.has(entity)) {
      var t = tm[entity];
      items[getTileIndex(t.x, t.y)] = entity;
    }
  }

  void collectItem(num x, num y) {
    var tileIndex = getTileIndex(x, y);
    var entity = items.remove(tileIndex);
    if (null != entity) {
      var item = im[entity];
      inventory.items[item.name] = true;
      entity.deleteFromWorld();

      world.createAndAddEntity([new Sound('pickup')]);
    }
  }
}