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
  });
}
