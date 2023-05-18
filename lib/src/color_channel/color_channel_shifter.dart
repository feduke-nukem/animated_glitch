import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/core/shifter.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shift.dart';
import 'package:animated_glitch/src/util/glitch_iterable_x.dart';
import 'package:flutter/material.dart';

/// Command based class to shift color channels.
class ColorChannelShifter extends Shifter<ColorChannel, ColorChannelShift> {
  ColorChannelShifter({
    required super.shift,
    required super.glitchCoefficient,
    required super.random,
    required super.timers,
    required super.onShifted,
  });

  @override
  void call() {
    shift.colors.tick(
      (index, duration) {
        final isLast = index == shift.colors.length - 1;

        final colorChannels = isLast
            ? const <ColorChannel>[]
            : shift.colors.map(
                (color) => _createShifted(
                  color: color,
                  glitchCoefficient: glitchCoefficient,
                ),
              );

        timers.start(
          callback: () => onShifted(colorChannels.toList()),
          duration: duration,
        );
      },
      interval: shift.delay,
    );
  }

  ColorChannel _createShifted({
    required Color color,
    required double glitchCoefficient,
  }) {
    final min = glitchCoefficient * -shift.spread;
    final max = glitchCoefficient * shift.spread;

    final top = random.fromMinMax(min, max);
    final left = random.fromMinMax(min, max);

    return ColorChannel(
      color,
      top: top,
      left: left,
    );
  }
}
