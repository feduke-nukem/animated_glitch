import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlitchColorFilter', () {
    test(
        'Two GlitchColorFilter instances with the same properties should be considered equal',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final filter1 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color1);
      final filter2 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color2);

      expect(filter1 == filter2, isTrue);
    });

    test(
        'hashCode should return the same value for two GlitchColorFilter instances with the same properties',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFF000000);
      final filter1 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color1);
      final filter2 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color2);

      expect(filter1.hashCode == filter2.hashCode, isTrue);
    });

    test(
        'Two GlitchColorFilter instances with different properties should not be considered equal',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFFFFFFFF);
      final filter1 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color1);
      final filter2 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color2);

      expect(filter1 == filter2, isFalse);
    });

    test(
        'hashCode should return different values for two GlitchColorFilter instances with different properties',
        () {
      final color1 = Color(0xFF000000);
      final color2 = Color(0xFFFFFFFF);
      final filter1 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color1);
      final filter2 =
          GlitchColorFilter(blendMode: BlendMode.srcOver, color: color2);

      expect(filter1.hashCode == filter2.hashCode, isFalse);
    });
  });
}
