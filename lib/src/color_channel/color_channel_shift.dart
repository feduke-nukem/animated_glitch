import 'package:flutter/material.dart';

// ignore_for_file: no-magic-number

/// Settings to shift color channels.
class ColorChannelShift {
  const ColorChannelShift({
    this.colors = const [
      Colors.red,
      Colors.green,
      Colors.blue,
    ],
    this.delay = const Duration(milliseconds: 100),
    this.spread = 10,
  });

  /// Colors to shift.
  final List<Color> colors;

  /// Delay between shifts.
  final Duration delay;

  /// Spread of the shift.
  final int spread;

  @override
  int get hashCode => Object.hash(colors, delay);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorChannelShift &&
          other.colors == colors &&
          other.delay == delay;
}
