import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/core/shifter.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shift.dart';
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
    final isSingle = shift.colors.length == 1;
    final colors = isSingle ? shift.colors + shift.colors : shift.colors;

    for (var i = 0; i < colors.length; i++) {
      final elementNumber = i + 1;
      final duration = shift.delay * elementNumber;
      final isLast = i == colors.length - 1;

      final colorChannels =
          !isLast ? shift.colors.map(_createShifted) : const <ColorChannel>[];

      timers.start(
        callback: () => onShifted(colorChannels.toList()),
        duration: duration,
      );
    }
  }

  ColorChannel _createShifted(Color color) {
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
