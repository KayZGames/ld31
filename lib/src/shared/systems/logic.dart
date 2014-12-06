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
