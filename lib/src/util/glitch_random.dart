import 'dart:math' as math;
import 'package:animated_glitch/src/distortion/horizontal_position.dart';

/// Utility class to generate random values.
class GlitchRandom {
  final _random = math.Random();

  /// Generates a random double value between [min] and [max].
  double fromMinMax(double min, double max) {
    return _random.nextDouble() * (max - min) + min;
  }

  /// Generates a random [HorizontalPosition] value between [min] and [max].
  HorizontalPosition horizontalPosition(double min, double max) {
    final side = _random.nextDouble() * (max - min) + min;

    return side < 0
        ? HorizontalPosition(left: 0, right: side * -1)
        : HorizontalPosition(left: side, right: 0);
  }

  /// Generates a random int value between 0 and [max].
  int number(int max) => _random.nextInt(max);
}
