#### Controller
To control glitches, you will need to create an [AnimatedGlitchController](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController-class.html):

```dart
final controller = AnimatedGlitchController();
```

Controller has several key methods such as `start`, `stop` and `reset`.

```dart
final controller = AnimatedGlitchController();

controller.start();
controller.stop();
controller.reset();
```

You can specify (and mutate) optional values such as:
- [frequency](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController/frequency.html): Determines the interval at which glitches occur (mutable).
- [chance](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController/chance.html): Determines the probability of a glitch appearing (mutable).
- [level](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController/level.html): Determines the extent to which `Distortions` and `ColorChannels` are shifted, based on the provided glitching level (mutable).
- [distortionShift](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/DistortionShift-class.html): Determines the number of generated `Distortions` and the delays for appearing and disappearing (mutable).
- [colorChannelShift](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/ColorChannelShift-class.html): `ColorChannels` are generated based on this. The number of "channel shifts" is equal to the length of the provided colors list. The value of delay specifies the duration after which the sequence of the ColorChannels will appear one by one (mutable).
- [autoStart](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController/autoStart.html): The controller will automatically start generating glitches upon creation.

```dart
final controller = AnimatedGlitchController(
  frequency: const Duration(milliseconds: 500),
  level: 2.2,
  distortionShift: const DistortionShift(count: 20),
  colorChannelShift: const ColorChannelShift(
    colors: [
      Colors.purple,
      Colors.indigoAccent,
      Colors.orange,
    ],
  ),
);
``` 

Output:

<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/74b90ddb-6279-4b9c-b101-62740c4cbb9e" height="400"/>
