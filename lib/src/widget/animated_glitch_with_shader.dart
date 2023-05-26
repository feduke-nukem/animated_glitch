import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

extension on bool {
  double toFloat() => this ? 1.0 : 0.0;
}

class AnimatedGlitchWithShader extends StatefulWidget {
  final double distortionSpreadReduce;
  final double colorChannelSpreadReduce;
  final double glitchAmount;
  final double frequency;
  final int chance;
  final bool showDistortion;
  final bool showColorChannel;
  final Widget child;

  const AnimatedGlitchWithShader({
    required this.chance,
    required this.colorChannelSpreadReduce,
    required this.distortionSpreadReduce,
    required this.frequency,
    required this.glitchAmount,
    required this.showColorChannel,
    required this.showDistortion,
    required this.child,
    super.key,
  });

  @override
  State<AnimatedGlitchWithShader> createState() =>
      _AnimatedGlitchWithShaderState();
}

class _AnimatedGlitchWithShaderState extends State<AnimatedGlitchWithShader>
    with SingleTickerProviderStateMixin {
  double _time = 0.0;

  late final _ticker = createTicker((elapsed) {
    setState(() {
      _time += 0.0042;
    });
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ShaderBuilder(
        (context, shader, child) => AnimatedSampler(
          (image, size, canvas) {
            shader
              // uTime
              ..setFloat(0, _time)
              // uResolution x
              ..setFloat(1, size.width)
              // uResolution y
              ..setFloat(2, size.height)
              // uDistortionOffsetDivisor
              ..setFloat(3, widget.distortionSpreadReduce)
              // uColorChannelOffsetDivisor
              ..setFloat(4, widget.colorChannelSpreadReduce)
              // uGlitchAmount
              ..setFloat(5, widget.glitchAmount)
              // uFrequency
              ..setFloat(6, widget.frequency)
              // uChance
              ..setFloat(7, widget.chance.toDouble())
              // uShowDistortion
              ..setFloat(8, widget.showDistortion.toFloat())
              // uShowColorChannel
              ..setFloat(9, widget.showColorChannel.toFloat())
              // uShiftColorChannelsY
              ..setFloat(10, 0)
              // uShiftColorChannelsY
              ..setFloat(11, 1)
              // uChannel0
              ..setImageSampler(0, image);
            canvas.save();
            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
            canvas.restore();
          },
          child: child!,
        ),
        assetKey: 'packages/animated_glitch/shader/glitch.frag',
        child: widget.child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
