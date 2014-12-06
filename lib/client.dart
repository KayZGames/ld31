library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;

import 'package:ld31/shared.dart';
export 'package:ld31/shared.dart';

import 'package:canvas_query/canvas_query.dart';
export 'package:canvas_query/canvas_query.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';

//part 'src/client/systems/name.dart';
part 'src/client/systems/events.dart';
part 'src/client/systems/rendering.dart';


class Game extends GameBase {

  Game() : super.noAssets('ld31', 'canvas', 800, 600);

  void createEntities() {
    // addEntity([Component1, Component2]);
  }

  List<EntitySystem> getSystems() {
    return [
            new TweeningSystem(),
            new CanvasCleaningSystem(canvas),
            new FpsRenderingSystem(ctx),
            new AnalyticsSystem(AnalyticsSystem.GITHUB, 'ld31')
    ];
  }
}
