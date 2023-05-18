import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:flutter/foundation.dart';

/// Base class for shifting values.
abstract class Shifter<T, S> {
  const Shifter({
    required this.random,
    required this.timers,
    required this.glitchCoefficient,
    required this.onShifted,
    required this.shift,
  });

  /// @nodoc
  @protected
  final GlitchRandom random;

  /// @nodoc
  @protected
  final GlitchTimers timers;

  /// @nodoc
  @protected
  final double glitchCoefficient;

  /// @nodoc
  @protected
  final ValueChanged<List<T>> onShifted;

  /// Settings to use.
  final S shift;

  /// Shifts values.
  void call();
}
