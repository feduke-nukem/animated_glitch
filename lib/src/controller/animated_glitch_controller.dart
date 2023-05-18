import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shift.dart';
import 'package:animated_glitch/src/core/animated_glitch_notifier.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shifter.dart';
import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_shifter.dart';
import 'package:animated_glitch/src/distortion/distortion_shift.dart';
import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:animated_glitch/src/widget/animated_glitch.dart';
import 'package:flutter/material.dart';
// ignore_for_file: no-magic-number

const _maxChance = 100;
const _levelMultiplier = 1.1;

/// {@category Getting started}
/// {@category Controller}
/// {@category Known issues}
/// {@template animated_glitch_controller}
/// Controller to control the [AnimatedGlitch] widget.
///
/// Generates random glitches based on [frequency], [chance] and [level].
/// {@endtemplate}
class AnimatedGlitchController extends AnimatedGlitchNotifier {
  AnimatedGlitchController({
    this.frequency = const Duration(milliseconds: 1000),
    this.chance = 50,
    this.level = 1.0,
    this.colorChannelShifting = const ColorChannelShift(),
    this.distortionShifting = const DistortionShift(),
    bool autoStart = true,
  })  : assert(
          chance <= _maxChance,
          'Chance must not be higher than $_maxChance',
        ),
        assert(
          distortionShifting.delay == colorChannelShifting.delay,
          'To be able glitch synchronized, shiftings must have the same interval.',
        ) {
    if (autoStart) start();
  }

  final _random = GlitchRandom();
  final _timers = GlitchTimers();
  var _isActive = false;

  @visibleForTesting
  Size? widgetSize;

  /// Settings for color channel shifting.
  final ColorChannelShift colorChannelShifting;

  /// Settings for distortion shifting.
  final DistortionShift distortionShifting;

  /// Whether the controller is active.
  bool get isActive => _isActive;

  /// The frequency of the glitches.
  final Duration frequency;

  /// The chance of a glitch to occur.
  final int chance;

  /// The level of the glitches.
  final double level;

  double get _coefficient => level * _levelMultiplier;

  @override
  void dispose() {
    _timers.reset();
    widgetSize = null;

    super.dispose();
  }

  /// Starts the controller.
  void start() {
    if (_isActive) return;

    _start();
    _isActive = true;
  }

  /// Stops the controller.
  void stop() {
    _timers.reset();
    _isActive = false;
    notifyListeners();
  }

  /// Resets the controller.
  void reset() {
    _timers.reset();
    _isActive = false;
    super.colorChannels = const <ColorChannel>[];
    super.distortions = const <Distortion>[];
  }

  /// Binds the controller to the [AnimatedGlitch] widget.
  ///
  /// This is called automatically by the [AnimatedGlitch] widget.
  void bind(Size widgetSize) {
    this.widgetSize = widgetSize;
  }

  void _start() {
    _timers.startPeriodic(
      callback: (_) {
        final shouldGlitch = chance >= _random.number(_maxChance);

        if (!shouldGlitch) return;

        _startColorShift();
        _startDistortionShift();
      },
      duration: frequency,
    );
  }

  void _startColorShift() {
    final shifter = ColorChannelShifter(
      shift: colorChannelShifting,
      glitchCoefficient: _coefficient,
      random: _random,
      timers: _timers,
      onShifted: (colorChannels) => this.colorChannels = colorChannels,
    );

    return shifter();
  }

  void _startDistortionShift() {
    if (widgetSize == null) return;

    final shifter = DistortionShifter(
      shift: distortionShifting,
      widgetHeight: widgetSize!.height,
      glitchCoefficient: _coefficient,
      random: _random,
      timers: _timers,
      onShifted: (distortions) => this.distortions = distortions,
    );

    return shifter();
  }
}
