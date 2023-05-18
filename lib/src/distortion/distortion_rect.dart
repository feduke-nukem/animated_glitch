import 'package:animated_glitch/src/distortion/distortion_widget.dart';
import 'package:flutter/rendering.dart';

/// A class that represents a distortion rect.
///
/// It is used in [DistortionWidget] to apply [CustomClipper] to the widget.
class DistortionRect {
  const DistortionRect({
    required this.top,
    required this.heightPercent,
  });

  /// The top position of the distortion rect.
  final double top;

  /// The height percent of the distortion rect.
  final double heightPercent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistortionRect &&
          other.top == top &&
          other.heightPercent == heightPercent;

  @override
  int get hashCode => Object.hash(top, heightPercent);
}
