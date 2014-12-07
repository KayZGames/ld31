part of client;


class RenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Renderable> rm;

  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;

  RenderingSystem(this.ctx, this.sheet, Aspect aspect) : super(aspect.allOf([Transform, Renderable]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var r = rm[entity];

    var sprite = '${r.name}${t.direction}';
    var src = sheet.sprites[sprite].src;
    var dst = sheet.sprites[sprite].dst;

    ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, t.x + tileSize/2 + dst.left, t.y + tileSize/2 + dst.top, dst.width, dst.height);
  }
}

class ObjectLayerRenderingSystem extends RenderingSystem {
  ObjectLayerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet) : super(ctx, sheet, Aspect.getAspectForAllOf([ObjectLayer]));
}
class ButtonLayerRenderingSystem extends RenderingSystem {
  ButtonLayerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet) : super(ctx, sheet, Aspect.getAspectForAllOf([Button]).exclude([ScreenBackground]));
}
class ScreenBackgroundLayerRenderingSystem extends RenderingSystem {
  ScreenBackgroundLayerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet) : super(ctx, sheet, Aspect.getAspectForAllOf([ScreenBackground]));

  @override
  bool checkProcessing() => state.screenOn;
}

class ScreenToCanvasRenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;

  CanvasElement screen;
  CanvasRenderingContext2D ctx;

  ScreenToCanvasRenderingSystem(this.screen, this.ctx) : super(Aspect.getAspectForAllOf([Transform, Controller]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];

    ctx.drawImageScaledFromSource(screen, -400 + t.x + 1.5 * tileSize, -300 + t.y + 1.5 * tileSize, 800, 600, 0, 0, 800, 600);
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

  @override
  bool checkProcessing() => !state.screenOn;
}

class PreviewContainerRenderingSystem extends VoidEntitySystem {
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  SpriteSheet sheet;

  PreviewContainerRenderingSystem(this.ctx, this.sheet);

  @override
  void initialize() {
    buffer = new CanvasElement(width: 1920, height: 1080);
    buffer.context2D..fillStyle = Colors.DIM_GRAY
                    ..fillRect(0, 1080 - 5 * tileSize, 1920, 3 * tileSize)
                    ..fillRect(0, 0, 1920, 2 * tileSize)
                    ..fillRect(0, 0, tileSize, 1080 - 2 * tileSize)
                    ..fillRect(1920 - tileSize, 0, 1920, 1080 - 2 * tileSize)
                    ..fillStyle = Colors.TWINE
                    ..fillRect(0, 1080 - 2 * tileSize - 2, 1920, 2)
                    ..fillRect(tileSize, 1080 - 5 * tileSize, 1920 - 2 * tileSize, 2)
                    ..fillRect(0, 0, 2, 1080 - 2 * tileSize)
                    ..fillRect(tileSize, 2 * tileSize - 2, 1920 - 2 * tileSize, 2)
                    ..fillRect(0, 0, 1920, 2)
                    ..fillRect(tileSize - 2, 2 * tileSize, 2, 1080 - 7 * tileSize)
                    ..fillRect(1920 - tileSize, 2 * tileSize, 2, 1080 - 7 * tileSize)
                    ..fillRect(1920 - 2, 0, 2, 1080 - 2 * tileSize);

  }

  @override
  void processSystem() {
    ctx.drawImage(buffer, 0, 0);
    var src = sheet.sprites['screen_0'].src;
    ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, tileSize, 2 * tileSize, 1920 - 2 * tileSize, 1080 - 7 * tileSize);
  }

  @override
  bool checkProcessing() => state.screenOn;
}

class DoorsMenuRenderingSystem extends VoidEntitySystem {
  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;

  DoorsMenuRenderingSystem(this.ctx, this.sheet);

  @override
  void processSystem() {
    var src = sheet.sprites['doors_menu'].src;
    var dst = sheet.sprites['doors_menu'].dst;
    ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, tileSize, 1080 - 2 * tileSize - dst.height, dst.width, dst.height);
  }

  @override
  bool checkProcessing() => state.screenOn && state.doorsMenuOpened;
}

class InventoryRenderingSystem extends VoidEntitySystem {
  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;

  InventoryRenderingSystem(this.ctx, this.sheet);

  @override
  void processSystem() {
    var src =  sheet.sprites['inventory'].src;
    var dst =  sheet.sprites['inventory'].dst;
    ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, 400 - 150, 600 - 1.5 * tileSize, dst.width, dst.height);
    drawItem('gun', 0);
    drawItem('magnifier', 1);
  }

  void drawItem(String name, int position) {
    if (inventory.items[name] == true) {
      var src =  sheet.sprites[name].src;
      var dst =  sheet.sprites[name].dst;
      ctx.drawImageScaledFromSource(sheet.image, src.left, src.top, src.width, src.height, tileSize * position + 400 - 150 + dst.left + tileSize / 2, 600 - tileSize + dst.top, dst.width, dst.height);
    }
  }
}

class GunEffectRenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<ExpirationTimer> etm;
  Mapper<GunEffect> gem;

  CanvasRenderingContext2D ctx;

  GunEffectRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform, GunEffect, ExpirationTimer]));


  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var et = etm[entity];
    var ge = gem[entity];

    var startX = t.x + ge.x * tileSize/2 + tileSize/2;
    var startY = t.y + ge.y * tileSize/2 + tileSize/2;
    var startAngle = ge.x.abs() * (PI/2 - ge.x * PI/2) + ge.y.abs() * (PI - ge.y * PI/2) - PI/4;
    var endAngle = startAngle + 2 * PI/4;

    ctx..save()
       ..fillStyle = Colors.GOLDEN_FIZZ
       ..globalAlpha = et.amount / et.maxAmount
       ..beginPath()
       ..moveTo(startX, startY)
       ..lineTo(startX + tileSize * 8 * cos(startAngle), startY + tileSize * 8 * sin(startAngle))
       ..arc(startX, startY, tileSize * 8, startAngle, endAngle)
       ..lineTo(startX, startY)
       ..fill()
       ..closePath()
       ..restore();
  }
}