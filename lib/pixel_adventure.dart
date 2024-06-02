import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'levels/level.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFB0A9E3);

  late final CameraComponent cam;
  final world = Level(levelName: 'Level-02');

  @override
  FutureOr<void> onLoad() async {
    // Load all Image into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    return super.onLoad();
  }
}