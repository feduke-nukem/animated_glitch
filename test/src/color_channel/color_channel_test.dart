import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorChannel', () {
    test(
        'Two ColorChannel instances with the same properties should be considered equal',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final channel1 = ColorChannel(color1, top: 10, left: 20);
      final channel2 = ColorChannel(color2, top: 10, left: 20);

      expect(channel1 == channel2, isTrue);
    });

    test(
        'hashCode should return the same value for two ColorChannel instances with the same properties',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final channel1 = ColorChannel(color1, top: 10, left: 20);
      final channel2 = ColorChannel(color2, top: 10, left: 20);

      expect(channel1.hashCode == channel2.hashCode, isTrue);
    });

    test(
        'Two ColorChannel instances with different properties should not be considered equal',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final channel1 = ColorChannel(color1, top: 10, left: 20);
      final channel2 = ColorChannel(color2, top: 5, left: 20);

      expect(channel1 == channel2, isFalse);
    });

    test(
        'hashCode should return different values for two ColorChannel instances with different properties',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final channel1 = ColorChannel(color1, top: 10, left: 20);
      final channel2 = ColorChannel(color2, top: 5, left: 20);

      expect(channel1.hashCode == channel2.hashCode, isFalse);
    });
  });
}
