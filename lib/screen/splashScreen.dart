import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator:
      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Themer.gradient1, // Start color
              Themer.gradient2, // End color
            ],
            begin: Alignment.topLeft,  // Starting point of gradient
            end: Alignment.bottomRight, // Ending point of gradient
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/document2.png', height: 170, width: 170),
        ),
      ),
    );
  }
}