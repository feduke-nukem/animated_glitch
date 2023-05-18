import 'dart:async';

import 'package:flutter/material.dart';

/// Class to manage timers.
class GlitchTimers {
  /// @nodoc
  @visibleForTesting
  final list = <Timer>[];

  /// Starts a periodic timer with the given [duration] and [callback].
  Timer startPeriodic({
    required void Function(Timer timer) callback,
    required Duration duration,
  }) {
    final timer = Timer.periodic(
      duration,
      callback,
    );
    list.add(timer);

    return timer;
  }

  /// Starts a timer with the given [duration] and [callback].
  Timer start({
    required void Function() callback,
    required Duration duration,
  }) {
    late final Timer timer;

    timer = Timer(
      duration,
      () {
        callback();
        stop(timer);
      },
    );

    list.add(timer);

    return timer;
  }

  /// @nodoc
  @visibleForTesting
  void stop(Timer timer) {
    timer.cancel();
    list.remove(timer);
  }

  /// Cancels all timers.
  void reset() {
    for (final timer in list) {
      timer.cancel();
    }
    list.clear();
  }
}
