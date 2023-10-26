import 'package:flutter/material.dart';
import 'package:quantum_metal_assessment/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (builder) {
                return const HomeScreen();
              }),
            );
          },
          child: const Text('Enter'),
        ),
      ),
    );
  }
}
