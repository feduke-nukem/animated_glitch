## Getting started
## Installation
In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  animated_glitch: <latest_version>
```

In your library add the following import:

```dart
import 'package:animated_glitch/animated_glitch.dart'; 
```

## Setup and usage
Wrap your desired widget with [AnimatedGlitch](https://pub.dev/documentation/animated_glitch/latest/animated_glitch/AnimatedGlitch-class.html):

```dart
final _controller = AnimatedGlitchController(
  frequency: const Duration(milliseconds: 200),
  level: 1.2,
  distortionShifting: const DistortionShift(count: 3),
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

<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/c9480e42-dc71-4293-828d-cc1efe291866" alt="blue" height="400"/>
