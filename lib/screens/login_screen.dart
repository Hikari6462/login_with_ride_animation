import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: Center(
        child: SizedBox(
          height: 800,
          width: 800,
          child: RiveAnimation.asset('assets/oso.riv', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
