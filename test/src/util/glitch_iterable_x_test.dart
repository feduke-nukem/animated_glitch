import 'package:animated_glitch/src/util/glitch_iterable_x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlitchIterableX', () {
    test('tick calls onTick for each element with correct parameters', () {
      final List<int> elements = [1, 2, 3, 4, 5];
      final List<int> indices = [];
      final List<Duration> milliseconds = [];

      void onTick(int index, Duration duration) {
        indices.add(index);
        milliseconds.add(duration);
      }

      elements.tick(onTick);

      expect(indices, equals([0, 1, 2, 3, 4]));
      expect(
          milliseconds,
          equals(
            [
              Duration(milliseconds: 100),
              Duration(milliseconds: 200),
              Duration(milliseconds: 300),
              Duration(milliseconds: 400),
              Duration(milliseconds: 500),
            ],
          ));
    });
  });
}
