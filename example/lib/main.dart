import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Glitch Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
}
