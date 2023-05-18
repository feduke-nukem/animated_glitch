import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:animated_glitch/src/widget/glitch_color_filtered.dart';
import 'package:flutter/material.dart';

/// {@category Color filters}
///
/// A widget that applies multiple [GlitchColorFilter]s to its [child].
class MultipleGlitchColorFiltered extends StatelessWidget {
  /// The widget to display.
  final Widget child;

  /// The color filters to apply.
  final List<GlitchColorFilter> filters;

  /// @nodoc
  const MultipleGlitchColorFiltered({
    required this.filters,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var result = child;

    for (final filter in filters) {
      result = GlitchColorFiltered(
        colorFilter: filter,
        child: result,
      );
    }

    return result;
  }
}
