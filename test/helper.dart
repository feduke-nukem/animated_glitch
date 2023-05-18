import 'dart:async';

import 'package:animated_glitch/src/distortion/horizontal_position.dart';
import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:flutter/services.dart';

class FakeListener {
  int listensCount = 0;

  void call() => listensCount++;
}

class FakeGlitchRandom implements GlitchRandom {
  @override
  double fromMinMax(double min, double max) => 10;

  @override
  HorizontalPosition horizontalPosition(double min, double max) =>
      HorizontalPosition(left: 10, right: 10);

  @override
  int number(int max) => 10;
}

class FakeGlitchTimers implements GlitchTimers {
  final Map<Duration, List<VoidCallback>> startInvokedWith = {};

  @override
  List<Timer> get list => [];

  @override
  void reset() {}

  @override
  Timer startPeriodic({
    required void Function(Timer timer) callback,
    required Duration duration,
  }) {
    final timer = FakeTimer();
    callback(timer);

    return timer;
  }

  @override
  void stop(Timer timer) {}

  @override
  Timer start({
    required VoidCallback callback,
    required Duration duration,
  }) {
    (startInvokedWith.putIfAbsent(duration, () => [])).add(callback);
    callback();

    return FakeTimer();
  }
}

class FakeTimer implements Timer {
  @override
  void cancel() {}

  @override
  bool get isActive => false;

  @override
  int get tick => 0;
}
