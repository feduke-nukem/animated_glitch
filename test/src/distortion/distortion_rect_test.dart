import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DistortionRect', () {
    test(
        'Two DistortionRect instances with the same properties should be considered equal',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 10, heightPercent: 0.5);

      expect(rect1 == rect2, isTrue);
    });

    test(
        'hashCode should return the same value for two DistortionRect instances with the same properties',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 10, heightPercent: 0.5);

      expect(rect1.hashCode == rect2.hashCode, isTrue);
    });

    test(
        'Two DistortionRect instances with different properties should not be considered equal',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 5, heightPercent: 0.5);

      expect(rect1 == rect2, isFalse);
    });

    test(
        'hashCode should return different values for two DistortionRect instances with different properties',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 5, heightPercent: 0.5);

      expect(rect1.hashCode == rect2.hashCode, isFalse);
    });
  });
}
