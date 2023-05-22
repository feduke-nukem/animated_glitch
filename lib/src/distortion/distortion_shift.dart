// ignore_for_file: no-magic-number

import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_shifter.dart';

/// {@category Controller}
/// The shifting settings to be used by [DistortionShifter] to
/// generate [Distortion].
class DistortionShift {
  const DistortionShift({
    this.count = 2,
    this.delay = const Duration(milliseconds: 100),
    this.hideDelay = const Duration(milliseconds: 300),
  });

  /// The number of distortions to generate.
  final int count;

  /// The delay between each distortion.
  final Duration delay;

  /// The delay to hide the distortion.
  final Duration hideDelay;

  @override
  int get hashCode => Object.hash(count, delay, hideDelay);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistortionShift &&
          other.count == count &&
          other.delay == delay &&
          other.hideDelay == hideDelay;
}
