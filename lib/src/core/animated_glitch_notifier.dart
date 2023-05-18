import 'package:animated_glitch/src/color_channel/color_channel.dart';
import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:flutter/material.dart';

/// {@category Controller}
/// Class to notify listeners of [colorChannels] and [distortions] changes.
class AnimatedGlitchNotifier with ChangeNotifier {
  var _colorChannels = <ColorChannel>[];
  var _distortions = <Distortion>[];

  /// @nodoc
  List<ColorChannel> get colorChannels => List.unmodifiable(_colorChannels);

  /// @nodoc
  @protected
  @visibleForTesting
  set colorChannels(List<ColorChannel> value) {
    if (value == _colorChannels) return;

    _colorChannels = value;
    notifyListeners();
  }

  /// @nodoc
  List<Distortion> get distortions => List.unmodifiable(_distortions);

  /// @nodoc
  @protected
  @visibleForTesting
  set distortions(List<Distortion> value) {
    if (value == _distortions) return;

    _distortions = value;
    notifyListeners();
  }
}
