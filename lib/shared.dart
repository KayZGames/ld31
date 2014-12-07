library shared;

import 'package:gamedev_helpers/gamedev_helpers_shared.dart';

part 'src/shared/components.dart';
part 'src/shared/managers.dart';

//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';

const int tileSize = 30;

GameState state = new GameState();
Inventory inventory = new Inventory();

class GameState {
  bool screenOn = false;
  bool doorsMenuOpened = false;
}

class Inventory {
  final Map<String, bool> items = {'gun': true};
}

// Dawnbringer 32 palette
class Colors {
  static const BLACK = "#000000";
  static const VALHALLE = "#222034";
  static const LOULOU = "#45283c";
  static const OILED_CEDAR = "#663931";
  static const ROPE = "#8f563b";
  static const TAHITI_GOLD = "#df7126";
  static const TWINE = "#d9a066";
  static const PANCHO = "#eec39a";
  static const GOLDEN_FIZZ = "#fbf236";
  static const ATLANTIS = "#99e550";
  static const CHRISTI = "#6abe30";
  static const ELF_GREEN = "#37946e";
  static const DELL = "#4b692f";
  static const VERDIGRIS = "#524b24";
  static const OPAL = "#323c39";
  static const DEEP_KOAMARU = "#3f3f74";
  static const VENICE_BLUE = "#306082";
  static const ROYAL_BLUE = "#5b6ee1";
  static const CORNFLOWER = "#639bff";
  static const VIKING = "#5fcde4";
  static const LIGHT_STEEL_BLUE = "#cbdbfc";
  static const WHITE = "#ffffff";
  static const HEATHER = "#9badb7";
  static const TOPAZ = "#847e87";
  static const DIM_GRAY = "#696a6a";
  static const SMOKEY_ASH = "#595652";
  static const CLAIRVOYANT = "#76428a";
  static const BROWN = "#ac3232";
  static const MANDY = "#d95763";
  static const PLUM = "#d77bba";
  static const RAIN_FOREST = "#8f974a";
  static const STINGER = "#8a6f30";
}
