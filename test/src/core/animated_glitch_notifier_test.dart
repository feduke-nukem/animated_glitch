import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/core/animated_glitch_notifier.dart';
import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:animated_glitch/src/distortion/horizontal_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  late AnimatedGlitchNotifier sut;

  setUp(() {
    sut = AnimatedGlitchNotifier();
  });

  group('AnimatedGlitchNotifier', () {
    test('creates normally', () {
      expect(() => AnimatedGlitchNotifier(), returnsNormally);
    });

    test('colorChannels getter returns unmodifiable list', () {
      final colorChannels = sut.colorChannels;

      expect(colorChannels, isEmpty);

      expect(
        () => colorChannels.add(ColorChannel(Colors.black)),
        throwsUnsupportedError,
      );
    });

    test('colorChannels setter updates value and notifies listeners', () {
      final sut = AnimatedGlitchNotifier();
      final listener = FakeListener();
      sut.addListener(listener);

      final newColorChannels = [ColorChannel(Colors.red)];

      sut.colorChannels = newColorChannels;

      expect(sut.colorChannels, equals(newColorChannels));
      expect(listener.listensCount, equals(1));
    });

    test('distortions getter returns unmodifiable list', () {
      final sut = AnimatedGlitchNotifier();
      final distortions = sut.distortions;

      expect(distortions, isEmpty);
      expect(
          () => distortions.add(
                Distortion(
                  horizontalPosition: HorizontalPosition(left: 0, right: 0),
                  rect: DistortionRect(
                    top: 0,
                    heightPercent: 0,
                  ),
                ),
              ),
          throwsUnsupportedError);
    });

    test('distortions setter updates value and notifies listeners', () {
      final sut = AnimatedGlitchNotifier();
      final listener = FakeListener();
      sut.addListener(listener);

      final newDistortions = [
        Distortion(
          horizontalPosition: HorizontalPosition(left: 0, right: 0),
          rect: DistortionRect(
            top: 0,
            heightPercent: 0,
          ),
        )
      ];

      sut.distortions = newDistortions;

      expect(sut.distortions, equals(newDistortions));
      expect(listener.listensCount, equals(1));
    });
  });
}
