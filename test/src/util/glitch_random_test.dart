import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlitchRandom sut;

  setUp(() => sut = GlitchRandom());

  group('GlitchRandom', () {
    test('fromMinMax returns a value within the specified range', () {
      final minValue = 10.0;
      final maxValue = 20.0;

      final result = sut.fromMinMax(minValue, maxValue);

      expect(result, greaterThanOrEqualTo(minValue));
      expect(result, lessThanOrEqualTo(maxValue));
    });

    test('horizontalPosition returns a valid HorizontalPosition', () {
      final minValue = -10.0;
      final maxValue = 10.0;

      final result = sut.horizontalPosition(minValue, maxValue);

      expect(result.left, greaterThanOrEqualTo(0.0));
      expect(result.right, greaterThanOrEqualTo(0.0));
      expect(
          result.left + result.right, lessThanOrEqualTo(maxValue - minValue));
    });

    test('number returns a value less than the specified maximum', () {
      final maxValue = 100;

      final result = sut.number(maxValue);

      expect(result, lessThan(maxValue));
    });
  });
}
