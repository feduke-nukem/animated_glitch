import 'package:animated_glitch/src/distortion/distortion.dart';
import 'package:animated_glitch/src/distortion/distortion_rect.dart';
import 'package:flutter/material.dart';

/// Widget that applies [Distortion] to its child.
class DistortionWidget extends StatelessWidget {
  /// Distortion to apply.
  final Distortion distortion;

  /// The widget to display.
  final Widget child;

  /// @nodoc
  const DistortionWidget({
    required this.distortion,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: distortion.horizontalPosition.left,
      right: distortion.horizontalPosition.right,
      child: ClipPath(
        clipper: _DistortionClipper(distortion.rect),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: child,
      ),
    );
  }
}

class _DistortionClipper extends CustomClipper<Path> {
  const _DistortionClipper(this.rect);

  final DistortionRect rect;

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(
        Rect.fromLTWH(
          0,
          rect.top,
          size.width,
          size.height / rect.heightPercent,
        ),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
