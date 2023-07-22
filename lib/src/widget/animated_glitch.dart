import 'dart:async';

import 'package:animated_glitch/src/controller/animated_glitch_controller.dart';

import 'package:animated_glitch/src/color_channel/color_channel_widget.dart';
import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:animated_glitch/src/distortion/distortion_widget.dart';
import 'package:animated_glitch/src/widget/multiple_glitch_color_filtered.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';

extension on bool {
  double toFloat() => this ? 1.0 : 0.0;
}

/// {@category With shader}
/// {@category Without shader}
/// Shortcuts.
sealed class AnimatedGlitch implements Widget {
  /// Shortcut to create a [AnimatedGlitchWithoutShader].
  const factory AnimatedGlitch({
    required Widget child,
    required AnimatedGlitchController controller,
    bool showColorChannels,
    bool showDistortions,
    List<GlitchColorFilter> filters,
    Key? key,
  }) = AnimatedGlitchWithoutShader;

  /// Shortcut to create a [AnimatedGlitchWithShader].
  const factory AnimatedGlitch.shader({
    required Widget child,
    double colorChannelLevel,
    double distortionLevel,
    double glitchAmount,
    double speed,
    int chance,
    bool showDistortions,
    bool showColorChannels,
    double speedStep,
    bool isActive,
    Key? key,
  }) = AnimatedGlitchWithShader;
}

/// {@category Without shader}
/// Widget to display a glitch effect.
///
/// It is driven by the provided [AnimatedGlitchController].
final class AnimatedGlitchWithoutShader extends StatefulWidget
    implements AnimatedGlitch {
  /// The widget to display.
  final Widget child;

  /// {@macro animated_glitch_controller}
  final AnimatedGlitchController controller;

  /// Whether to display the color channels.
  final bool showColorChannels;

  /// Whether to display the distortions.
  final bool showDistortions;

  /// The color filters to apply.
  ///
  /// It is applied before the distortions and the color channels shifting.
  final List<GlitchColorFilter> filters;

  /// @nodoc
  const AnimatedGlitchWithoutShader({
    required this.child,
    required this.controller,
    this.showColorChannels = true,
    this.showDistortions = true,
    this.filters = const <GlitchColorFilter>[],
    super.key,
  });

  @override
  State<AnimatedGlitchWithoutShader> createState() =>
      _AnimatedGlitchWithoutShaderState();
}

/// @nodoc
class _AnimatedGlitchWithoutShaderState
    extends State<AnimatedGlitchWithoutShader> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final composition = widget.filters.isEmpty
        ? widget.child
        : MultipleGlitchColorFiltered(
            filters: widget.filters,
            child: widget.child,
          );

    return RepaintBoundary(
      key: _key,
      child: Stack(
        children: [
          Stack(
            children: [
              Positioned.fill(child: composition),
              if (widget.showDistortions && widget.controller.isActive)
                ...widget.controller.distortions.map(
                  (e) => DistortionWidget(
                    distortion: e,
                    child: composition,
                  ),
                ),
            ],
          ),
          if (widget.showColorChannels && widget.controller.isActive)
            ...widget.controller.colorChannels.map(
              (e) => ColorChannelWidget(
                channel: e,
                child: composition,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.controller.bind(context.size!);
        widget.controller.addListener(_rebuild);
      },
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedGlitchWithoutShader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_rebuild);

      widget.controller.bind(context.size!);
      widget.controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);

    super.dispose();
  }

  @override
  void setState(VoidCallback callback) {
    if (mounted) super.setState(callback);
  }

  void _rebuild() {
    setState(() {});
  }
}

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
  final _globalKey = GlobalKey();
  var _isDisposed = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
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
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

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
  void set onSize(ValueChanged<Size> value) {
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
        ..setFloat(7, showDistortions.toFloat())
        // uShowColorChannel
        ..setFloat(8, showColorChannels.toFloat())
        // uShiftColorChannelsY
        ..setFloat(9, isColorsShiftedVertically.toFloat())
        // uShiftColorChannelsX
        ..setFloat(10, isColorsShiftedHorizontally.toFloat())
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
