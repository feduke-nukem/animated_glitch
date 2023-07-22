import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:animated_glitch/src/distortion/horizontal_position.dart';

/// {@category Controller}
/// Information for [_AnimatedGlitchBasic] to display a distortion.
class Distortion {
  /// @nodoc
  const Distortion({
    required this.rect,
    required this.horizontalPosition,
  });

  /// The distortion rect.
  final DistortionRect rect;

  /// The horizontal position of the distortion rect.
  final HorizontalPosition horizontalPosition;

  @override
  int get hashCode => Object.hash(rect, horizontalPosition);

  operator ==(Object other) =>
      identical(this, other) ||
      other is Distortion &&
          other.rect == rect &&
          other.horizontalPosition == horizontalPosition;
}
