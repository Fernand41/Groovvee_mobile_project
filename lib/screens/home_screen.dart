import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( // scaffold est un widget qui crée la page de lapplication avec le appbar, le body, le drawer, etc.
      body: Center(child: Text('Accueil')),
    );
  }
}