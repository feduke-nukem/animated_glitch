import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';

/// Information for [AnimatedGlitchWithoutShader] to display a color channel.
class ColorChannel {
  const ColorChannel(
    this.color, {
    this.top = 0,
    this.left = 0,
  });

  /// The color to display.
  final Color color;

  /// The top offset.
  final double top;

  /// The left offset.
  final double left;

  @override
  int get hashCode => Object.hash(color, top, left);

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorChannel &&
          other.color == color &&
          other.top == top &&
          other.left == left;
}
