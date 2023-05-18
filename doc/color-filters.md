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

<img src="https://github.com/feduke-nukem/animated_glitch/assets/72284940/13069c44-1328-4bfd-ba2a-cf4bf5949097" alt="blue" height="400"/>
