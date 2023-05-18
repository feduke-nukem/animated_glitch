import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:animated_glitch/src/distortion/horizontal_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Distortion', () {
    test(
        'Two Distortion instances with the same properties should be considered equal',
        () {
      final rect = DistortionRect(top: 10, heightPercent: 0.5);
      final position = HorizontalPosition(left: 0, right: 0.5);
      final distortion1 = Distortion(rect: rect, horizontalPosition: position);
      final distortion2 = Distortion(rect: rect, horizontalPosition: position);

      expect(distortion1 == distortion2, isTrue);
    });

    test(
        'hashCode should return the same value for two Distortion instances with the same properties',
        () {
      final rect = DistortionRect(top: 10, heightPercent: 0.5);
      final position = HorizontalPosition(left: 0, right: 0.5);
      final distortion1 = Distortion(rect: rect, horizontalPosition: position);
      final distortion2 = Distortion(rect: rect, horizontalPosition: position);

      expect(distortion1.hashCode == distortion2.hashCode, isTrue);
    });

    test(
        'Two Distortion instances with different properties should not be considered equal',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 5, heightPercent: 0.5);
      final position1 = HorizontalPosition(left: 0, right: 0.5);
      final position2 = HorizontalPosition(left: 0, right: 0.75);
      final distortion1 =
          Distortion(rect: rect1, horizontalPosition: position1);
      final distortion2 =
          Distortion(rect: rect2, horizontalPosition: position2);

      expect(distortion1 == distortion2, isFalse);
    });

    test(
        'hashCode should return different values for two Distortion instances with different properties',
        () {
      final rect1 = DistortionRect(top: 10, heightPercent: 0.5);
      final rect2 = DistortionRect(top: 5, heightPercent: 0.5);
      final position1 = HorizontalPosition(left: 0, right: 0.5);
      final position2 = HorizontalPosition(left: 0, right: 0.75);
      final distortion1 =
          Distortion(rect: rect1, horizontalPosition: position1);
      final distortion2 =
          Distortion(rect: rect2, horizontalPosition: position2);

      expect(distortion1.hashCode == distortion2.hashCode, isFalse);
    });
  });
}
