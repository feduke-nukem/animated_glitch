import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:animated_glitch/src/widget/blend_mode_mask.dart';
import 'package:animated_glitch/src/widget/glitch_color_filtered.dart';
import 'package:animated_glitch/src/widget/multiple_glitch_color_filtered.dart';
import 'package:flutter/material.dart';

/// Widget to display a color channel.
class ColorChannelWidget extends StatelessWidget {
  /// The widget to display.
  final Widget child;

  /// The color channel to display.
  final ColorChannel channel;

  /// @nodoc
  const ColorChannelWidget({
    required this.channel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: channel.left,
      top: channel.top,
      child: BlendModeMask(
        blendMode: BlendMode.lighten,
        child: GlitchColorFiltered(
          colorFilter: GlitchColorFilter(
            blendMode: BlendMode.modulate,
            color: channel.color,
          ),
          child: child,
        ),
      ),
    );
  }
}
