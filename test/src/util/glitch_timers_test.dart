import 'dart:async';

import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlitchTimers sut;

  setUp(() {
    sut = GlitchTimers();
  });

  group('GlitchTimers', () {
    test('startPeriodic adds a Timer to the list', () {
      expect(sut.list, isEmpty);

      final callback = (Timer timer) {};
      final milliseconds = 100;

      sut.startPeriodic(
        callback: callback,
        duration: Duration(
          milliseconds: milliseconds,
        ),
      );

      expect(sut.list.length, 1);
    });

    test(
        'startPeriodic creates a Timer with the specified duration and callback',
        () {
      final callback = (Timer timer) {};
      final milliseconds = 100;

      sut.startPeriodic(
        callback: callback,
        duration: Duration(
          milliseconds: milliseconds,
        ),
      );

      final timer = sut.list.first;
      expect(timer.tick, equals(0));
      expect(timer.isActive, isTrue);
    });

    test('start adds a Timer to the list', () {
      expect(sut.list, isEmpty);

      final callback = () {};
      final milliseconds = 100;

      sut.start(
        callback: callback,
        duration: Duration(
          milliseconds: milliseconds,
        ),
      );

      expect(sut.list.length, 1);
    });

    test('start creates a Timer with the specified duration and callback', () {
      final callback = () {};
      final milliseconds = 100;

      sut.start(
        callback: callback,
        duration: Duration(
          milliseconds: milliseconds,
        ),
      );

      final timer = sut.list.first;
      expect(timer.tick, equals(0));
      expect(timer.isActive, isTrue);
    });

    test('stop cancels the specified periodic Timer', () async {
      final callback = (Timer timer) {};
      final milliseconds = 100;

      final timer = sut.startPeriodic(
        callback: callback,
        duration: Duration(milliseconds: milliseconds),
      );
      expect(sut.list.isNotEmpty, isTrue);

      sut.stop(timer);

      expect(sut.list.isEmpty, isTrue);
      expect(timer.isActive, isFalse);
    });

    test('stop cancels the specified Timer', () async {
      final callback = () {};
      final milliseconds = 100;

      final timer = sut.start(
        callback: callback,
        duration: Duration(
          milliseconds: milliseconds,
        ),
      );
      expect(sut.list.isNotEmpty, isTrue);

      sut.stop(timer);

      expect(sut.list.isEmpty, isTrue);
      expect(timer.isActive, isFalse);
    });

    test('reset cancels all Timers', () {
      final callback = () {};
      final milliseconds = 100;

      final timer1 = sut.start(
        callback: callback,
        duration: Duration(
          microseconds: milliseconds,
        ),
      );
      final timer2 = sut.startPeriodic(
        callback: (timer) {},
        duration: Duration(milliseconds: milliseconds),
      );

      expect(sut.list.length, equals(2));

      sut.reset();

      expect(timer1.isActive, isFalse);
      expect(timer2.isActive, isFalse);
      expect(sut.list.isEmpty, isTrue);
    });

    test('provided callback fires', () async {
      var count = 0;
      final callback = () {
        count++;
      };

      sut.start(
          callback: callback, duration: const Duration(milliseconds: 100));

      await Future.delayed(Duration(milliseconds: 100));

      expect(count, equals(1));
    });

    test('provided periodic callback fires', () async {
      var count = 0;
      final callback = (Timer timer) {
        count++;
      };

      sut.startPeriodic(
          callback: callback, duration: const Duration(milliseconds: 100));

      await Future.delayed(Duration(milliseconds: 100));

      expect(count, equals(1));

      await Future.delayed(Duration(milliseconds: 100));

      expect(count, equals(2));

      await Future.delayed(Duration(milliseconds: 100));

      expect(count, equals(3));
    });
  });
}
