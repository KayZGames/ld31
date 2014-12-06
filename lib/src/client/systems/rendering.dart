part of client;


class RenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Renderable> rm;

  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;

  RenderingSystem(this.ctx, this.sheet) : super(Aspect.getAspectForAllOf([Transform, Renderable]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var r = rm[entity];

    var src = sheet.sprites[r.name].src;
    var dst = sheet.sprites[r.name].dst;

    ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, t.x + (tileSize/2 + dst.left), t.y + (tileSize/2 + dst.top), dst.width, dst.height);
  }
}

class ScreenToCanvasRenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;

  CanvasElement screen;
  CanvasRenderingContext2D ctx;

  ScreenToCanvasRenderingSystem(this.screen, this.ctx) : super(Aspect.getAspectForAllOf([Transform, Controller]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];

    ctx.drawImageScaledFromSource(screen, -400 + t.x, -300 + t.y, 800, 600, -1.5 * tileSize, -1.5 * tileSize, 800, 600);
  }
}

class ScreenBorderRenderingSystem extends VoidEntitySystem {
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  SpriteSheet sheet;

  ScreenBorderRenderingSystem(this.ctx, this.sheet);

  @override
  void initialize() {
    buffer = new CanvasElement(width: 1920 + tileSize * 2, height: 1080 + tileSize * 2);
    var bufferCtx = buffer.context2D;
    var src = sheet.sprites['border'].src;
    for (int x = 0; x < 1920 / tileSize + 2; x++) {
      bufferCtx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, x * tileSize, 0, tileSize, tileSize);
    }
    for (int y = 1; y < 1080 / tileSize + 2; y++) {
      bufferCtx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, 0, y * tileSize, tileSize, tileSize);
    }
    for (int y = 1; y < 1080 / tileSize + 2; y++) {
      bufferCtx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, 1920 + tileSize, y * tileSize, tileSize, tileSize);
    }
    for (int x = 1; x < 1920 / tileSize + 1; x++) {
      bufferCtx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, x * tileSize, 1080 + tileSize, tileSize, tileSize);
    }
  }

  @override
  void processSystem() {
    ctx.drawImage(buffer, -tileSize, -tileSize);
  }
}

class SwitchedOffScreenRenderingSystem extends VoidEntitySystem {
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  SpriteSheet sheet;

  SwitchedOffScreenRenderingSystem(this.ctx, this.sheet);

  @override
  void initialize() {
    buffer = new CanvasElement(width: 1920, height: 1080);
    var bufferCtx = buffer.context2D;
    var src = sheet.sprites['bg_black'].src;
    for (int x = 0; x < 1920 / tileSize; x++) {
      for (int y = 0; y < 1080 / tileSize; y++) {
        bufferCtx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, x * tileSize, y * tileSize, tileSize, tileSize);
      }
    }
  }

  @override
  void processSystem() {
    ctx.drawImage(buffer, 0, 0);
  }
}