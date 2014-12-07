part of shared;


class Transform extends Component {
  num x, y;
  String direction;
  Transform(this.x, this.y, {this.direction: ''});
}

class Renderable extends Component {
  String name;
  Renderable(this.name);
}

class Controller extends Component {
  num distanceX = 0, distanceY = 0;
  bool useItem = false;
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

class ExpirationTimer extends Component {
  num maxAmount, amount;
  ExpirationTimer(this.maxAmount, this.amount);
}

class EquippedItem extends Component {
  int item;
  num cooldown = 0;
  EquippedItem(this.item);
}

class GunEffect extends Component {
  int x, y;
  GunEffect(this.x, this.y);
}

typedef bool MaterializationCondition();
class ItemMaterializer extends Component {
  String item;
  MaterializationCondition condition;
  ItemMaterializer(this.item, this.condition);
}