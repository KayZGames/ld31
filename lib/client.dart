library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;

import 'package:ld31/shared.dart';
export 'package:ld31/shared.dart';

import 'package:canvas_query/canvas_query.dart';
export 'package:canvas_query/canvas_query.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart' hide Colors;
export 'package:gamedev_helpers/gamedev_helpers.dart' hide Colors;

//part 'src/client/systems/name.dart';
part 'src/client/systems/events.dart';
part 'src/client/systems/rendering.dart';


class Game extends GameBase {

  CanvasElement screen;
  CanvasRenderingContext2D screenCtx;

  Game() : super('ld31', 'canvas', 800, 600, bodyDefsName: null) {
    screen = new CanvasElement(width: 1920 + tileSize * 2, height: 1080 + tileSize * 2);
    screenCtx = screen.context2D;
    screenCtx.translate(tileSize, tileSize);
  }

  void createEntities() {
    addEntity([new Transform(0, 0), new Renderable('player'), new Controller(), new ObjectLayer()]);
    addEntity([new Transform(1920 - tileSize, 1080), new Renderable('button_off'), new Button(toggleScreen)]);
    addEntity([new Transform(0, 1080 - 2 * tileSize), new Renderable('doors_taskbar'), new ScreenBackground()]);
  }

  void toggleScreen(Entity entity) {
    Renderable r = entity.getComponentByClass(Renderable);
    if (r.name == 'button_off') {
      r.name = 'button_on';
      state.screenOn = true;
    } else {
      r.name = 'button_off';
      state.screenOn = false;
    }
  }

  List<EntitySystem> getSystems() {
    return [
            new TweeningSystem(),

            new InputHandlingSystem(),
            new ControllerMovementSystem(),
            new ButtonInteractionSystem(),
            new CooldownSystem(),

            new CanvasCleaningSystem(canvas),
            new ScreenBorderRenderingSystem(screenCtx, spriteSheet),
            new SwitchedOffScreenRenderingSystem(screenCtx, spriteSheet),
            new ScreenBackgroundLayerRenderingSystem(screenCtx, spriteSheet),
            new PreviewContainerRenderingSystem(screenCtx),
            new ButtonLayerRenderingSystem(screenCtx, spriteSheet),
            new ObjectLayerRenderingSystem(screenCtx, spriteSheet),
            new ScreenToCanvasRenderingSystem(screen, ctx),

            new FpsRenderingSystem(ctx),
            new AnalyticsSystem(AnalyticsSystem.GITHUB, 'ld31')
    ];
  }

  onInit() {
    world.addManager(new ButtonManager());
  }
}
