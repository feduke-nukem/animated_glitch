#### Setup and usage
Wrap your desired widget with [AnimatedGlitch](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitch-class.html):

```dart
final _controller = AnimatedGlitchController(
  frequency: const Duration(milliseconds: 200),
  level: 1.2,
  distortionShift: const DistortionShift(count: 3),
);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: AnimatedGlitch(
      filters: [
        GlitchColorFilter(
          blendMode: BlendMode.color,
          color: Colors.blue.shade900,
        )
      ],
      controller: _controller,
      child: Image.asset(
        'assets/cyberpunk.jpg',
        fit: BoxFit.cover,
      ),
    ),
  );
}
```

Output: 

<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/c9480e42-dc71-4293-828d-cc1efe291866" height="400"/>

You can wrap any kind of widget, and the `glitch effect` will be applied as well.:
```dart
final _controller = AnimatedGlitchController(
  frequency: const Duration(milliseconds: 200),
  level: 1.2,
  distortionShift: const DistortionShift(count: 3),
);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: AnimatedGlitch(
      controller: _controller,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.purple,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.person,
            size: 400.0,
          )
        ],
      ),
    ),
  );
}
```

Output:


<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/d5c8b177-1c01-41d4-9efa-4e0449492ad9" height="400"/>

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

#### Color filters
You can provide specific color filters that will be applied before the `ColorChannels` are shifted:

```dart
return Scaffold(
  body: AnimatedGlitch(
    filters: const [
      GlitchColorFilter(
        blendMode: BlendMode.color,
        color: Colors.grey,
      ),
      GlitchColorFilter(
        blendMode: BlendMode.colorBurn,
        color: Colors.orange,
      )
    ],
    controller: _controller,
    child: Image.asset(
      'assets/cyberpunk.jpg',
      fit: BoxFit.cover,
    ),
  ),
);
```

Output:


<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/681cc620-c49d-4b81-9b76-99ba9d6f6434" height="400"/>
## Known issues

- Due to frequent rebuilds, some junks may occur when scrolling. To minimize this behavior, you can try stopping the [AnimatedGlitchController](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitchController-class.html) when scrolling begins and starting it again when scrolling ends.
This approach may help:

```dart
final _controllers = List.generate(
  20,
  (_) => AnimatedGlitchController(
    frequency: const Duration(milliseconds: 200),
    level: 1.2,
    distortionShift: const DistortionShift(count: 3),
  ),
);
final images = List.generate(
  20,
  (_) => Image.asset(
    'assets/cyberpunk.jpg',
    fit: BoxFit.cover,
  ),
);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        itemCount: images.length,
        itemBuilder: (_, index) => SizedBox(
          height: 200,
          child: AnimatedGlitch(
            controller: _controllers[index],
            child: images[index],
          ),
        ),
      ),
    ),
  );
}

bool _onNotification(Notification notification) {
  if (notification is ScrollStartNotification) {
    for (final controller in _controllers) {
      controller.stop();
    }

    return true;
  }
  if (notification is ScrollEndNotification) {
    for (final controller in _controllers) {
      controller.start();
    }

    return true;
  }

  return false;
}
```