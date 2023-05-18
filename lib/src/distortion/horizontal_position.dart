import 'package:flutter/material.dart';

/// Horizontal position of a distortion.
///
/// Basically, it is used in [Positioned] widget to position the distortion.
class HorizontalPosition {
  /// @nodoc
  const HorizontalPosition({
    required this.left,
    required this.right,
  });

  /// The left position of the distortion.
  final double left;

  /// The right position of the distortion.
  final double right;

  @override
  int get hashCode => Object.hash(left, right);

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorizontalPosition && other.left == left && other.right == right;
}
