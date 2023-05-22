import 'package:animated_glitch/src/widget/glitch_color_filtered.dart';
import 'package:flutter/material.dart';

/// {@category Color filters}
/// A color filter to apply to a [GlitchColorFiltered] widget.
class GlitchColorFilter {
  /// @nodoc
  const GlitchColorFilter({
    required this.blendMode,
    required this.color,
  });

  /// The color to display.
  final Color color;

  /// The blend mode to apply.
  final BlendMode blendMode;

  @override
  int get hashCode => Object.hash(color, blendMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlitchColorFilter &&
          other.color == color &&
          other.blendMode == blendMode;
}
