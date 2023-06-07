import 'dart:collection';

import 'package:animated_glitch/src/core/shifter.dart';
import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:animated_glitch/src/distortion/distortion_shift.dart';
import 'package:flutter/material.dart';

/// Implementation of [Shifter] for [Distortion].
class DistortionShifter extends Shifter<Distortion, DistortionShift> {
  DistortionShifter({
    required super.shift,
    required this.widgetHeight,
    required super.glitchCoefficient,
    required super.random,
    required super.timers,
    required super.onShifted,
  });

  final distortions = Queue<Distortion>();
  final double widgetHeight;

  @override
  void call() {
    for (var i = 1; i <= shift.count; i++) {
      final duration = shift.delay * i;

      _shift(duration);
    }
  }

  void _shift(Duration duration) {
    timers.start(
      callback: onShiftTimer,
      duration: duration,
    );
  }

  /// @nodoc
  @visibleForTesting
  void onShiftTimer() {
    final distortion = createShifted();
    distortions.add(distortion);
    onShifted(distortions.toList());

    hideShifted();
  }

  /// @nodoc
  @visibleForTesting
  Distortion createShifted() {
    const marginSpreadStep = 25;
    const leftBound = 5;
    const rightBound = 30;

    return Distortion(
      rect: DistortionRect(
        top: random.fromMinMax(0, widgetHeight * glitchCoefficient),
        heightPercent: random.fromMinMax(
          glitchCoefficient * leftBound,
          glitchCoefficient * rightBound,
        ),
      ),
      horizontalPosition: random.horizontalPosition(
        glitchCoefficient * -marginSpreadStep,
        glitchCoefficient * marginSpreadStep,
      ),
    );
  }

  /// @nodoc
  @visibleForTesting
  void hideShifted() {
    timers.start(
      callback: onHideTimer,
      duration: shift.hideDelay,
    );
  }

  /// @nodoc
  @visibleForTesting
  void onHideTimer() {
    distortions.removeFirst();
    onShifted(distortions.toList());
  }
}
