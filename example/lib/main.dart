import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';

void main() => Future<void>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      // TODO(plugfox): remove this line and replace with proper image loading
      await $initImage('assets/cyberpunk.jpg');
      runApp(const App());
    });

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Animated Glitch Demo',
        showPerformanceOverlay: true,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 1000,
            itemBuilder: (context, index) => const AnimatedGlitchWithShader(
              chance: 50,
              colorChannelSpreadReduce: 30,
              distortionSpreadReduce: 20,
              frequency: 1,
              level: 0.7,
              glitchAmount: 3,
              showColorChannel: true,
              showDistortion: true,
              // TODO(plugfox): replace with proper image
              child: SizedBox.shrink(),
              /* child: Image.asset(
                'assets/cyberpunk.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ), */
            ),
          ),
        ),
      );
}
