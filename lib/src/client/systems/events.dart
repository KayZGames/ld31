part of client;


class InputHandlingSystem extends GenericInputHandlingSystem {
  Mapper<Controller> cm;
  Mapper<Transform> tm;

  InputHandlingSystem()
      : super(Aspect.getAspectForAllOf([Controller, Transform]));

  @override
  void processEntity(Entity entity) {
    var c = cm[entity];
    if (isStanding(c)) {
      var t = tm[entity];
      if (keyState[KeyCode.W] == true) {
        c.distanceY += -tileSize;
        t.direction = 'up';
      } else if (keyState[KeyCode.S] == true) {
        c.distanceY += tileSize;
        t.direction = 'down';
      } else if (keyState[KeyCode.A] == true) {
        c.distanceX += -tileSize;
        t.direction = 'left';
      } else if (keyState[KeyCode.D] == true) {
        c.distanceX += tileSize;
        t.direction = 'right';
      }
    }
    if (keyState[KeyCode.J] == true) {
      c.useItem = true;
    } else {
      c.useItem = false;
    }
  }

  bool isStanding(Controller c) => c.distanceX == 0 && c.distanceY == 0;
}
