part of shared;


class Transform extends Component {
  num x, y;
  String direction = '';
  Transform(this.x, this.y);
}

class Renderable extends Component {
  String name;
  Renderable(this.name);
}

class Controller extends Component {
  num distanceX = 0, distanceY = 0;
}

typedef void ButtonAction(Entity entity);
class Button extends Component {
  ButtonAction action;
  Button(this.action);
}

class ObjectLayer extends Component {}
class ScreenBackground extends Component {}

class Cooldown extends Component {
  num amount;
  Cooldown(this.amount);
}