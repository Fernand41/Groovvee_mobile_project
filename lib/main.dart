import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:groovvee/screens/home_screen.dart';
import 'package:groovvee/screens/forgot_password_screen.dart';
import 'package:groovvee/screens/signin_screen.dart';
import 'package:groovvee/screens/signup_screen.dart';
import 'package:groovvee/screens/splash_screen.dart';
import 'package:groovvee/screens/verification_screen.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {  // context représente l’emplacement du widget dans l’application
    return MaterialApp(
      title: 'Groovvee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/verification': (context) {
          final usernameOrEmail = ModalRoute.of(context)?.settings.arguments;
          return VerificationScreen(
            usernameOrEmail:
                usernameOrEmail is String ? usernameOrEmail : '',
          );
        },
        '/login': (context) {
          final email = ModalRoute.of(context)?.settings.arguments;
          return SigninScreen(initialEmail: email is String ? email : '');
        },
        '/signup': (_) => const SignupScreen(),
      },
    );
  }
}
