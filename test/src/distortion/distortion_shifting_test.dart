import 'package:animated_glitch/src/distortion/distortion_shift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DistortionShifting', () {
    test('should have the correct hashCode', () {
      const distortionShifting1 = DistortionShift();
      const distortionShifting2 = DistortionShift();

      expect(distortionShifting1.hashCode, distortionShifting2.hashCode);
    });

    test('should be equal to another DistortionShifting with the same values',
        () {
      const distortionShifting1 = DistortionShift();
      const distortionShifting2 = DistortionShift();

      expect(distortionShifting1, distortionShifting2);
    });

    test(
        'should not be equal to another DistortionShifting with different values',
        () {
      const distortionShifting1 = DistortionShift();
      const distortionShifting2 = DistortionShift(
        count: 3,
        delay: Duration(milliseconds: 200),
        hideDelay: Duration(milliseconds: 500),
      );

      expect(distortionShifting1, isNot(distortionShifting2));
    });
  });
}
