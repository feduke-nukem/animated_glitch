import 'package:animated_glitch/src/distortion/horizontal_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HorizontalPosition', () {
    test(
        'Two HorizontalPosition instances with the same properties should be considered equal',
        () {
      final position1 = HorizontalPosition(left: 0.2, right: 0.8);
      final position2 = HorizontalPosition(left: 0.2, right: 0.8);

      expect(position1 == position2, isTrue);
    });

    test(
        'hashCode should return the same value for two HorizontalPosition instances with the same properties',
        () {
      final position1 = HorizontalPosition(left: 0.2, right: 0.8);
      final position2 = HorizontalPosition(left: 0.2, right: 0.8);

      expect(position1.hashCode == position2.hashCode, isTrue);
    });

    test(
        'Two HorizontalPosition instances with different properties should not be considered equal',
        () {
      final position1 = HorizontalPosition(left: 0.2, right: 0.8);
      final position2 = HorizontalPosition(left: 0.3, right: 0.7);

      expect(position1 == position2, isFalse);
    });

    test(
        'hashCode should return different values for two HorizontalPosition instances with different properties',
        () {
      final position1 = HorizontalPosition(left: 0.2, right: 0.8);
      final position2 = HorizontalPosition(left: 0.3, right: 0.7);

      expect(position1.hashCode == position2.hashCode, isFalse);
    });
  });
}
