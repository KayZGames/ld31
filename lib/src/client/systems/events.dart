part of client;


class InputHandlingSystem extends GenericInputHandlingSystem {
  Mapper<Controller> cm;

  InputHandlingSystem() : super(Aspect.getAspectForAllOf([Controller]));


  @override
  void processEntity(Entity entity) {
    var c = cm[entity];
    if (keyState[KeyCode.W] == true && c.distanceY.abs() <= 1) {
      c.distanceY += -tileSize;
    } else if (keyState[KeyCode.S] == true && c.distanceY.abs() <= 1) {
      c.distanceY += tileSize;
    } else if (keyState[KeyCode.A] == true && c.distanceX.abs() <= 1) {
      c.distanceX += -tileSize;
    } else if (keyState[KeyCode.D] == true && c.distanceX.abs() <= 1) {
      c.distanceX += tileSize;
    }
  }
}