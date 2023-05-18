import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// {@category Color filters}
/// A widget to apply a [BlendMode] to its child.
class BlendModeMask extends SingleChildRenderObjectWidget {
  /// Blend mode to apply.
  final BlendMode blendMode;

  /// @nodoc
  const BlendModeMask({
    required this.blendMode,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderGlitchBlendMask(blendMode);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGlitchBlendMask renderObject,
  ) {
    renderObject.blendMode = blendMode;
  }
}

class _RenderGlitchBlendMask extends RenderProxyBox {
  _RenderGlitchBlendMask(this.blendMode);

  BlendMode blendMode;

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    context.canvas.saveLayer(offset & size, Paint()..blendMode = blendMode);

    super.paint(context, offset);

    context.canvas.restore();
  }
}
