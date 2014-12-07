part of shared;


class ControllerMovementSystem extends EntityProcessingSystem {
  Mapper<Controller> cm;
  Mapper<Transform> tm;

  ControllerMovementSystem()
      : super(Aspect.getAspectForAllOf([Transform, Controller]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var c = cm[entity];

    var movement = getMovement(c.distanceX);
    t.x += movement;
    c.distanceX -= movement;

    movement = getMovement(c.distanceY);
    t.y += movement;
    c.distanceY -= movement;

    if (t.x < -tileSize) {
      t.x = -tileSize;
    }
    if (t.y < -tileSize) {
      t.y = -tileSize;
    }
    if (t.x > 1920) {
      t.x = 1920;
    }
    if (t.y > 1080) {
      t.y = 1080;
    }
  }

  num getMovement(num distance) {
    num absoluteDistance = min(world.delta * 0.2, distance.abs()).toInt();
    return distance >= 0 ? absoluteDistance : -absoluteDistance;
  }
}


class ButtonInteractionSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Button> bm;
  ButtonManager buttonManager;

  ButtonInteractionSystem() : super(Aspect.getAspectForAllOf([Transform, Controller]).exclude([Cooldown]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];

    var tileIndex = buttonManager.getTileIndex(t.x, t.y);
    var button = buttonManager.buttons[tileIndex];
    if (button != null) {
      bm[button].action(button);
      entity.addComponent(new Cooldown(500));
      entity.changedInWorld();
    }
  }
}

class CooldownSystem extends EntityProcessingSystem {
  Mapper<Cooldown> cm;
  CooldownSystem() : super(Aspect.getAspectForAllOf([Cooldown]));

  @override
  void processEntity(Entity entity) {
    var c = cm[entity];

    c.amount -= world.delta;
    if (c.amount <= 0) {
      entity.removeComponent(Cooldown);
      entity.changedInWorld();
    }
  }
}


class ItemUseSystem extends EntityProcessingSystem {
  Mapper<Controller> cm;
  Mapper<Transform> tm;
  Mapper<EquippedItem> im;

  ItemUseSystem() : super(Aspect.getAspectForAllOf([Controller, Transform, EquippedItem]));

  @override
  void processEntity(Entity entity) {
    var c = cm[entity];
    var item = im[entity];
    if (c.useItem && item.cooldown <= 0) {
      var t = tm[entity];
      if (item.item == Item.gun) {
        // TODO materialize stuff
        var x = 0;
        var y = 0;
        if ('up' == t.direction) {
          y = -1;
        } else if ('down' == t.direction) {
          y = 1;
        } else if ('left' == t.direction) {
          x = -1;
        } else if ('right' == t.direction) {
          x = 1;
        }
        world.createAndAddEntity([new Transform(t.x, t.y), new GunEffect(x, y), new ExpirationTimer(200, 200)]);
      }
      item.cooldown = 1000;
    } else {
      item.cooldown -= world.delta;
    }
  }
}

class ExpirationSystem extends EntityProcessingSystem {
  Mapper<ExpirationTimer> etm;

  ExpirationSystem() : super(Aspect.getAspectForAllOf([ExpirationTimer]));

  @override
  void processEntity(Entity entity) {
    var et = etm[entity];

    et.amount -= world.delta;
    if (et.amount <= 0) {
      entity.deleteFromWorld();
    }
  }
}