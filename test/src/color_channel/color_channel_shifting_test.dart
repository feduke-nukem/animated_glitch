import 'package:animated_glitch/src/color_channel/color_channel_shift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorChannelShifting', () {
    test('should have the correct hashCode', () {
      const colorChannelShifting1 = ColorChannelShift();
      const colorChannelShifting2 = ColorChannelShift();

      expect(colorChannelShifting1.hashCode, colorChannelShifting2.hashCode);
    });

    test('should be equal to another ColorChannelShifting with the same values',
        () {
      const colorChannelShifting1 = ColorChannelShift();
      const colorChannelShifting2 = ColorChannelShift();

      expect(colorChannelShifting1, colorChannelShifting2);
    });

    test(
        'should not be equal to another ColorChannelShifting with different values',
        () {
      const colorChannelShifting1 = ColorChannelShift();
      const colorChannelShifting2 = ColorChannelShift(
        colors: [Colors.red, Colors.green],
        delay: Duration(milliseconds: 200),
        spread: 5,
      );

      expect(colorChannelShifting1, isNot(colorChannelShifting2));
    });
  });
}
