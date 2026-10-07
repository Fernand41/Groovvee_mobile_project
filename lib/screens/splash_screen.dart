import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _background = AssetImage('assets/splash_screen.png');

  @override
  void initState() {
    super.initState();
    // On attend le premier frame pour pouvoir utiliser le context
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    // Précharge les images pour éviter tout flash blanc
    await Future.wait([
      precacheImage(_background, context),
    ]);

    // Retire le splash natif : cette page prend le relais
    FlutterNativeSplash.remove();

    // Ici : vérification du token, chargement de la config, etc.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond plein écran
          Image(image: _background, fit: BoxFit.cover),
          Text("HI", style: TextStyle(color: Colors.black),)
        ],
      ),
    );
  }
}