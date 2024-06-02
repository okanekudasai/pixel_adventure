import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';

import 'components/player.dart';
import 'components/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFFB0A9E3);

  late final CameraComponent cam;
  Player player = Player(character: "Mask Dude");
  late JoystickComponent joystick;
  bool showJoystick = Platform.isAndroid || Platform.isIOS;

  @override
  FutureOr<void> onLoad() async {
    // Load all Image into cache
    await images.loadAllImages();

    final world = Level(
        player: player,
        levelName: 'Level-01',
    );

    // world라는 기준이 있어서 화면이 커지고 작아지는거에 반응하는듯
    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 368);
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 0;

    await addAll([cam, world]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 20,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        )
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    joystick.priority = 1;
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
      case JoystickDirection.upLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}