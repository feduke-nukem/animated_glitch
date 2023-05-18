import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_shifter.dart';
import 'package:animated_glitch/src/distortion/distortion_shift.dart';
import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

const _glitchCoefficient = 0.5;

void main() {
  late GlitchRandom random;
  late FakeGlitchTimers timers;
  late List<List<Distortion>> shiftedDistortions;

  setUp(() {
    random = FakeGlitchRandom();
    timers = FakeGlitchTimers();
    shiftedDistortions = [];
  });

  group('DistortionShifter', () {
    int count = 0;
    double widgetHeight = 0;

    void onShifted(List<Distortion> distortions) {
      shiftedDistortions.add(distortions);
    }

    setUp(() {
      count = 3;
      widgetHeight = 200.0;
      shiftedDistortions = [];
    });

    test('should shift distortions correctly', () {
      final shift = DistortionShift(count: count);
      // Multiply by 2 because each shift has a start and end
      // Firstly, the distortion is shown and then it is hidden
      final expectedCount = count * 2;
      final shifter = DistortionShifter(
        shift: shift,
        widgetHeight: widgetHeight,
        glitchCoefficient: _glitchCoefficient,
        random: random,
        timers: timers,
        onShifted: onShifted,
      );

      shifter.call();

      // Verify that the correct number of shifts occurred
      expect(shiftedDistortions.length, equals(expectedCount));

      // Verify the shifted distortions for each shift
      for (int i = 1; i <= count; i++) {
        final milliseconds = i * 100;
        expect(
          contains(
            shifter.onShiftTimer,
          ).matches(
            timers.startInvokedWith[Duration(milliseconds: milliseconds)],
            {},
          ),
          isTrue,
        );

        expect(
          contains(shifter.onHideTimer).matches(
            timers.startInvokedWith[shift.hideDelay],
            {},
          ),
          isTrue,
        );
      }
    });
  });
}
