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