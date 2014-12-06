part of shared;


class Transform extends Component {
  num x, y;
  Transform(this.x, this.y);
}

class Renderable extends Component {
  String name;
  Renderable(this.name);
}

class Controller extends Component {
  num distanceX = 0, distanceY = 0;
}