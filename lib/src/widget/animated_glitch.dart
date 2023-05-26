import 'package:animated_glitch/src/controller/animated_glitch_controller.dart';

import 'package:animated_glitch/src/color_channel/color_channel_widget.dart';
import 'package:animated_glitch/src/core/glitch_color_filter.dart';
import 'package:animated_glitch/src/distortion/distortion_widget.dart';
import 'package:animated_glitch/src/widget/multiple_glitch_color_filtered.dart';
import 'package:flutter/material.dart';

/// {@category Color filters}
/// {@category Known issues}
/// Widget to display a glitch effect.
///
/// It is driven by the provided [AnimatedGlitchController].
class AnimatedGlitch extends StatefulWidget {
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
  const AnimatedGlitch({
    required this.child,
    required this.controller,
    this.showColorChannels = true,
    this.showDistortions = true,
    this.filters = const <GlitchColorFilter>[],
    super.key,
  });

  @override
  State<AnimatedGlitch> createState() => AnimatedGlitchState();
}

/// @nodoc
class AnimatedGlitchState extends State<AnimatedGlitch> {
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
  void didUpdateWidget(covariant AnimatedGlitch oldWidget) {
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
