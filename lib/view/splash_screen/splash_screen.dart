import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:deeznotes/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("deeZ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          AnimatedTextKit(totalRepeatCount: 1,isRepeatingAnimation: false, animatedTexts: [
            TyperAnimatedText("Notez",
                speed: const Duration(milliseconds: 450),
                textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
          ])
        ]),
      ),
    );
  }
}
