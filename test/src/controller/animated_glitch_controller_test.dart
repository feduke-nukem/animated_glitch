import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AnimatedGlitchController controller;

  setUp(() {
    controller = AnimatedGlitchController();
  });

  group('AnimatedGlitchController', () {
    test('should start the glitch animation', () {
      controller.start();

      expect(controller.isActive, isTrue);
    });

    test('should stop the glitch animation', () {
      controller.start();
      controller.stop();

      expect(controller.isActive, isFalse);
    });

    test('should reset the glitch animation', () {
      controller.start();
      controller.reset();

      expect(controller.isActive, isFalse);
      expect(controller.colorChannels, isEmpty);
      expect(controller.distortions, isEmpty);
    });

    testWidgets('should bind to an AnimatedGlitchState', (widgetTester) async {
      final widget = AnimatedGlitch(
        child: Container(),
        controller: controller,
        filters: [
          GlitchColorFilter(
            blendMode: BlendMode.colorBurn,
            color: Colors.red,
          )
        ],
      );

      await widgetTester.pumpWidget(MaterialApp(home: widget));

      expect(controller.widgetSize, isNotNull);
    });

    testWidgets('should dispose normally ', (widgetTester) async {
      final widget = AnimatedGlitch(
        child: Container(),
        controller: controller,
        filters: [
          GlitchColorFilter(
            blendMode: BlendMode.colorBurn,
            color: Colors.red,
          )
        ],
      );

      await widgetTester.pumpWidget(MaterialApp(home: widget));

      expect(controller.widgetSize, isNotNull);

      controller.dispose();

      expect(controller.widgetSize, isNull);
      expect(controller.distortions.isEmpty, isTrue);
      expect(controller.colorChannels.isEmpty, isTrue);
    });

    test('create with chance greater than 100, throws assertion error',
        () async {
      expect(() => AnimatedGlitchController(chance: 101), throwsAssertionError);
    });

    test('should assign new distortion shift', () {
      final distortionShift = DistortionShift(count: 35);

      controller.distortionShift = distortionShift;

      expect(controller.distortionShift, distortionShift);
    });

    test('should assign new colorChannelShift', () {
      final colorChannelShift = ColorChannelShift(spread: 20);

      controller.colorChannelShift = colorChannelShift;

      expect(controller.colorChannelShift, colorChannelShift);
    });

    test('should assign new frequency', () {
      final frequency = Duration(milliseconds: 5200);

      controller.frequency = frequency;

      expect(controller.frequency, frequency);
    });

    test('should assign new level', () {
      const level = 5.2;

      controller.level = level;

      expect(controller.level, level);
    });

    test('should assign new chance', () {
      const chance = 100;

      controller.chance = chance;

      expect(controller.chance, chance);
    });
  });
}
