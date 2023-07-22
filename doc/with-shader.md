#### Setup and usage

First of all, it is necessary to add a shader asset to your `pubspec.yaml`:

```yaml
flutter:
  shaders: 
    - 'packages/animated_glitch/shader/glitch.frag'
```

This version doesn't require any external controller, you just need to pass the desired arguments with specific values, and you are ready to go:

```dart
return Scaffold(
  body: AnimatedGlitch.shader(
    child: Image.asset(
      'assets/cyberpunk.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    ),
  ),
);
```

Output:

![ezgif-3-fd23eb8b23](https://github.com/feduke-nukem/animated_glitch/assets/72284940/ee44856d-f689-48ac-8aee-2ebdfce91666)


```dart
return Scaffold(
  body: AnimatedGlitch.shader(
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
```

Output:

![ezgif-3-cf54a870dc](https://github.com/feduke-nukem/animated_glitch/assets/72284940/89e36753-90ea-449f-bbd9-1eacf91310c9)


#### Color filters

There is no need for anything special in the version with Shader, you can simply use `ColorFiltered`:

```dart
return Scaffold(
  body: AnimatedGlitch.shader(
    child: ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.color),
      child: Image.asset(
        'assets/cyberpunk.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    ),
  ),
);
```

Output:

![ezgif-3-67648a42b4](https://github.com/feduke-nukem/animated_glitch/assets/72284940/9c2a718e-39f4-4c72-b07a-e5dc4ff7d689)

