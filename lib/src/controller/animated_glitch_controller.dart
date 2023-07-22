import 'package:animated_glitch/animated_glitch.dart';
import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/core/animated_glitch_notifier.dart';
import 'package:animated_glitch/src/color_channel/color_channel_shifter.dart';
import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_shifter.dart';
import 'package:animated_glitch/src/util/glitch_random.dart';
import 'package:animated_glitch/src/util/glitch_timers.dart';
import 'package:flutter/material.dart';

const _maxChance = 100;
const _levelMultiplier = 1.1;

/// {@category Without shader}
/// {@template animated_glitch_controller}
/// Controller to control the [AnimatedGlitchWithoutShader] widget.
///
/// Generates random glitches based on [frequency], [chance] and [level].
/// {@endtemplate}
class AnimatedGlitchController extends AnimatedGlitchNotifier {
  AnimatedGlitchController({
    Duration frequency = const Duration(milliseconds: 1000),
    int chance = 50,
    double level = 1.0,
    ColorChannelShift colorChannelShift = const ColorChannelShift(),
    DistortionShift distortionShift = const DistortionShift(),
    bool autoStart = true,
  })  : assert(
          chance <= _maxChance,
          'Chance must not be higher than $_maxChance',
        ),
        assert(
          distortionShift.delay == colorChannelShift.delay,
          'To be able glitch synchronized, shiftings must have the same interval.',
        ),
        _chance = chance,
        _frequency = frequency,
        _level = level,
        _colorChannelShift = colorChannelShift,
        _distortionShift = distortionShift {
    if (autoStart) start();
  }

  final _random = GlitchRandom();
  final _timers = GlitchTimers();

  bool _isActive = false;
  double _level;
  Duration _frequency;
  int _chance;
  ColorChannelShift _colorChannelShift;
  DistortionShift _distortionShift;

  @visibleForTesting
  Size? widgetSize;

  /// Settings for color channel shifting.
  ColorChannelShift get colorChannelShift => _colorChannelShift;
  set colorChannelShift(ColorChannelShift value) {
    if (_colorChannelShift == value) return;

    _colorChannelShift = value;
    notifyListeners();
  }

  /// Settings for distortion shifting.
  DistortionShift get distortionShift => _distortionShift;
  set distortionShift(DistortionShift value) {
    if (_distortionShift == value) return;

    _distortionShift = value;
    notifyListeners();
  }

  /// Whether the controller is active.
  bool get isActive => _isActive;

  /// The frequency of the glitches.
  Duration get frequency => _frequency;
  set frequency(Duration value) {
    if (_frequency == value) return;

    _frequency = value;
    _restart();
  }

  /// The chance of a glitch to occur.
  int get chance => _chance;
  set chance(int value) {
    if (_chance == value) return;

    _chance = value;
  }

  /// The level of the glitches.
  double get level => _level;
  set level(double value) {
    if (_level == value) return;

    _level = value;
  }

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

  /// Binds the controller to the [AnimatedGlitchWithoutShader] widget.
  ///
  /// This is called automatically by the [AnimatedGlitchWithoutShader] widget.
  void bind(Size widgetSize) {
    this.widgetSize = widgetSize;
  }

  void _start() {
    _timers.startPeriodic(
      callback: (_) {
        final shouldGlitch = _chance >= _random.number(_maxChance);

        if (!shouldGlitch) return;

        _startColorShift();
        _startDistortionShift();
      },
      duration: frequency,
    );
  }

  void _startColorShift() {
    return ColorChannelShifter(
      shift: _colorChannelShift,
      glitchCoefficient: _coefficient,
      random: _random,
      timers: _timers,
      onShifted: (colorChannels) => this.colorChannels = colorChannels,
    ).call();
  }

  void _startDistortionShift() {
    if (widgetSize == null) return;

    return DistortionShifter(
      shift: _distortionShift,
      widgetHeight: widgetSize!.height,
      glitchCoefficient: _coefficient,
      random: _random,
      timers: _timers,
      onShifted: (distortions) => this.distortions = distortions,
    ).call();
  }

  void _restart() {
    stop();
    start();
  }
}
