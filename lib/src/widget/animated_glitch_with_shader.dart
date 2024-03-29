import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'animated_glitch.dart';

/// {@category With shader}
/// Shader version of [AnimatedGlitchWithoutShader].
final class AnimatedGlitchWithShader extends StatefulWidget
    implements AnimatedGlitch {
  /// The color channel level.
  final double colorChannelLevel;

  /// The distortion level.
  final double distortionLevel;

  /// The amount of glitch.
  final double glitchAmount;

  /// The speed of the glitch.
  final double speed;

  /// The chance of the glitch.
  final int chance;

  /// Whether to display the distortions.
  final bool showDistortions;

  /// Whether to display the color channels.
  final bool showColorChannels;

  /// The widget to display.
  final Widget child;

  /// The time increment.
  ///
  /// You may think of it as a second speed value but with more precision.
  final double speedStep;

  /// Whether the glitch is active.
  final bool isActive;

  /// Whether color channels are shifted by Y.
  final bool isColorsShiftedVertically;

  /// Whether color channels are shifted by x.
  final bool isColorsShiftedHorizontally;

  /// @nodoc.
  const AnimatedGlitchWithShader({
    required this.child,
    this.chance = 50,
    double speed = 100,
    double distortionLevel = 3.5,
    double colorChannelLevel = 2.3,
    this.showColorChannels = true,
    this.showDistortions = true,
    this.glitchAmount = 3,
    this.speedStep = 0.0042,
    this.isActive = true,
    this.isColorsShiftedVertically = false,
    this.isColorsShiftedHorizontally = true,
    super.key,
    // https://stackoverflow.com/questions/38986208/webgl-loop-index-cannot-be-compared-with-non-constant-expression
  })  : assert(
          glitchAmount <= 10,
          'glitchAmount must be less than or equal to 10',
        ),
        assert(speed >= 0 && speed <= 100, 'speed must be between 0 and 100'),
        assert(
          chance >= 0 && chance <= 100,
          'chance must be between 0 and 100',
        ),
        assert(
          distortionLevel >= 0 && distortionLevel <= 100,
          'distortionLevel must be between 0 and 100',
        ),
        assert(
          colorChannelLevel >= 0 && colorChannelLevel <= 100,
          'colorChannelLevel must be between 0 and 100',
        ),
        this.speed = speed / 100,
        this.colorChannelLevel = colorChannelLevel / 100,
        this.distortionLevel = distortionLevel / 100;

  @override
  State<AnimatedGlitchWithShader> createState() =>
      _AnimatedGlitchWithShaderState();
}

class _AnimatedGlitchWithShaderState extends State<AnimatedGlitchWithShader>
    with SingleTickerProviderStateMixin {
  late final _ticker = createTicker(_updateShaderPainter);

  static final Future<ui.FragmentShader> _shaderFuture = () async {
    const shader = 'packages/animated_glitch/shader/glitch.frag';
    final program = await ui.FragmentProgram.fromAsset(shader);

    return program.fragmentShader();
  }();

  late final _data = ValueNotifier(
    _ShaderPainterData(
      size: Size.zero,
      time: 0.0,
    ),
  );
  final _childRepaintBoundaryKey = GlobalKey();
  var _isDisposed = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          RepaintBoundary(
            key: _childRepaintBoundaryKey,
            child: _SizeWidget(
              onSize: (value) =>
                  _data.value = _data.value.copyWith(size: value),
              child: widget.child,
            ),
          ),
          FutureBuilder(
            future: _shaderFuture,
            builder: (_, snapshot) => CustomPaint(
              painter: _AnimatedGlitchPainterShader(
                data: _data,
                shader: snapshot.data,
                colorChannelLevel: widget.colorChannelLevel,
                distortionLevel: widget.distortionLevel,
                speed: widget.speed,
                chance: widget.chance,
                showDistortions: widget.showDistortions,
                showColorChannels: widget.showColorChannels,
                glitchAmount: widget.glitchAmount,
                isColorsShiftedHorizontally: widget.isColorsShiftedHorizontally,
                isColorsShiftedVertically: widget.isColorsShiftedVertically,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.isActive) _ticker.start();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedGlitchWithShader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive != widget.isActive) _reflectIsActive();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _data.value.image?.dispose();
    _data.dispose();
    _isDisposed = true;
    super.dispose();
  }

  void _reflectIsActive() => widget.isActive ? _ticker.start() : _ticker.stop();

  void _updateShaderPainter(Duration duration) async {
    final boundary = _childRepaintBoundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;

    final image = await boundary.toImage(
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );

    if (_isDisposed) {
      image.dispose();

      return;
    }

    _data.value = _data.value.copyWith(
      time: _data.value.time + widget.speedStep,
      image: image,
    );
  }
}

class _SizeWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSize;

  const _SizeWidget({
    required super.child,
    required this.onSize,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeWidget(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSizeWidget renderObject,
  ) =>
      renderObject._onSize = onSize;
}

class _RenderSizeWidget extends RenderProxyBox {
  _RenderSizeWidget(this._onSize);

  ValueChanged<Size> _onSize;
  set onSize(ValueChanged<Size> value) {
    if (_onSize == value) return;
    _onSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    _onSize(size);
  }
}

class _ShaderPainterData {
  const _ShaderPainterData({
    required this.size,
    required this.time,
    this.image,
  });

  final Size size;
  final double time;
  final ui.Image? image;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ShaderPainterData &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          image == other.image &&
          size == other.size;

  @override
  int get hashCode => time.hashCode ^ image.hashCode ^ size.hashCode;

  _ShaderPainterData copyWith({
    Size? size,
    double? time,
    ui.Image? image,
  }) {
    return _ShaderPainterData(
      size: size ?? this.size,
      time: time ?? this.time,
      image: image ?? this.image,
    );
  }
}

class _AnimatedGlitchPainterShader extends CustomPainter {
  _AnimatedGlitchPainterShader({
    required this.data,
    required this.shader,
    required this.colorChannelLevel,
    required this.distortionLevel,
    required this.speed,
    required this.chance,
    required this.showDistortions,
    required this.showColorChannels,
    required this.glitchAmount,
    required this.isColorsShiftedHorizontally,
    required this.isColorsShiftedVertically,
  }) : super(repaint: data);

  ui.Image? _lastImage;
  final ValueListenable<_ShaderPainterData> data;
  final double colorChannelLevel;
  final double distortionLevel;
  final double glitchAmount;
  final double speed;
  final int chance;
  final bool showDistortions;
  final bool showColorChannels;
  final ui.FragmentShader? shader;
  final bool isColorsShiftedVertically;
  final bool isColorsShiftedHorizontally;

  @override
  void paint(Canvas canvas, Size _) {
    final time = data.value.time;
    final image = data.value.image;
    final size = data.value.size;

    if (_lastImage != image) {
      _lastImage?.dispose();
      _lastImage = image;
    }

    if (image == null) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Colors.transparent,
      );

      return;
    }
    if (shader == null) {
      canvas.drawImage(
        image,
        Offset.zero,
        Paint()..color = Colors.transparent,
      );

      return;
    }

    final paint = Paint()
      ..shader = (shader!
        // uTime
        ..setFloat(0, time)
        // uResolution x
        ..setFloat(1, size.width)
        // uResolution y
        ..setFloat(2, size.height)
        // uDistortionLevel
        ..setFloat(3, distortionLevel)
        // uColorChannelLevel
        ..setFloat(4, colorChannelLevel)
        // uSpeed
        ..setFloat(5, speed)
        // uChance
        ..setFloat(6, chance.toDouble())
        // uShowDistortion
        ..setFloat(7, showDistortions ? 1.0 : 0.0)
        // uShowColorChannel
        ..setFloat(8, showColorChannels ? 1.0 : 0.0)
        // uShiftColorChannelsY
        ..setFloat(9, isColorsShiftedVertically ? 1.0 : 0.0)
        // uShiftColorChannelsX
        ..setFloat(10, isColorsShiftedHorizontally ? 1.0 : 0.0)
        // uGlitchAmount
        ..setFloat(11, glitchAmount)
        // uChannel0
        ..setImageSampler(0, image));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_AnimatedGlitchPainterShader oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.shader != shader ||
      oldDelegate.isColorsShiftedHorizontally != isColorsShiftedHorizontally ||
      oldDelegate.isColorsShiftedVertically != isColorsShiftedVertically ||
      oldDelegate.distortionLevel != distortionLevel ||
      oldDelegate.colorChannelLevel != colorChannelLevel ||
      oldDelegate.speed != speed ||
      oldDelegate.chance != chance ||
      oldDelegate.showDistortions != showDistortions ||
      oldDelegate.showColorChannels != showColorChannels ||
      oldDelegate.glitchAmount != glitchAmount;
}
