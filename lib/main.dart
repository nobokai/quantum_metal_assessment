import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_metal_assessment/providers/rates.dart';
import 'package:quantum_metal_assessment/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyRate(),
      child: MaterialApp(
        title: 'Quantum Metal Assessment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
