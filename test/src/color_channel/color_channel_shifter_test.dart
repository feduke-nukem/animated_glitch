import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shifter.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shift.dart';
import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

const _glitchCoefficient = 0.5;
void main() {
  late GlitchRandom random;
  late GlitchTimers timers;
  late List<Color> colors;
  late List<List<ColorChannel>> shiftedColors;

  setUp(() {
    random = FakeGlitchRandom();
    timers = GlitchTimers();
    colors = [];
    shiftedColors = [];
  });

  group('ColorChannelShifter', () {
    ColorChannel _createShifted({
      required Color color,
      required double glitchCoefficient,
    }) {
      const double _spreadStep = 10;

      final min = glitchCoefficient * -_spreadStep;
      final max = glitchCoefficient * _spreadStep;

      final top = random.fromMinMax(min, max);
      final left = random.fromMinMax(min, max);

      return ColorChannel(
        color,
        top: top,
        left: left,
      );
    }

    void onShifted(List<ColorChannel> channels) {
      shiftedColors.add(channels);
    }

    setUp(() {
      colors = [
        Colors.red,
        Colors.green,
        Colors.blue,
      ];
      shiftedColors = [];
    });

    test('should shift color channels correctly', () async {
      final shifter = ColorChannelShifter(
        shift: ColorChannelShift(colors: colors),
        glitchCoefficient: _glitchCoefficient,
        random: random,
        timers: timers,
        onShifted: onShifted,
      );

      shifter.call();

      await Future.delayed(const Duration(milliseconds: 1500));

      // Verify that the correct number of shifts occurred
      expect(shiftedColors.length, colors.length);

      // Verify the shifted color channels for each color
      for (var i = 0; i < colors.length; i++) {
        final expectedChannels = i == colors.length - 1
            ? const <ColorChannel>[]
            : colors
                .map(
                  (color) => _createShifted(
                    color: color,
                    glitchCoefficient: _glitchCoefficient,
                  ),
                )
                .toList();

        expect(shiftedColors[i], equals(expectedChannels));
      }
    });
  });
}
