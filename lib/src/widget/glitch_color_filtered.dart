import 'dart:ui' as ui;

import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// {@category Color filters}
///
/// A widget that applies a [GlitchColorFilter] to its child.
class GlitchColorFiltered extends SingleChildRenderObjectWidget {
  /// The color filter to apply.
  final GlitchColorFilter colorFilter;

  /// @nodoc
  const GlitchColorFiltered({
    required this.colorFilter,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderGlitchColorFiltered(colorFilter);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGlitchColorFiltered renderObject,
  ) {
    renderObject.colorFilter = colorFilter;
  }
}

class _RenderGlitchColorFiltered extends RenderProxyBox {
  _RenderGlitchColorFiltered(this.colorFilter);

  GlitchColorFilter colorFilter;

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()
        ..colorFilter = ColorFilter.mode(
          colorFilter.color,
          colorFilter.blendMode,
        ),
    );

    super.paint(context, offset);

    context.canvas.restore();
  }
}
