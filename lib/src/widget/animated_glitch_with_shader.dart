import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

extension on bool {
  double toFloat() => this ? 1.0 : 0.0;
}

class AnimatedGlitchWithShader extends StatefulWidget {
  final double distortionSpreadReduce;
  final double colorChannelSpreadReduce;
  final double level;
  final int glitchAmount;
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
    required this.level,
    required this.showColorChannel,
    required this.showDistortion,
    required this.child,
    required this.glitchAmount,
    super.key,
    // https://stackoverflow.com/questions/38986208/webgl-loop-index-cannot-be-compared-with-non-constant-expression
  }) : assert(glitchAmount <= 10,
            'glitchAmount must be less than or equal to 10');

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
              // uLevel
              ..setFloat(5, widget.level)
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
              // uGlitchAmount
              ..setFloat(12, widget.glitchAmount.toDouble())
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
