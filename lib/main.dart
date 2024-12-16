import 'package:document_manager/screen/login.dart';
import 'package:document_manager/screen/onboardingScreen.dart';
import 'package:document_manager/screen/splashScreen.dart';
import 'package:flutter/material.dart';

import 'comms/helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
     // theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
     // routes: Helper.routes,
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => SplashScreen(), // Define your main screen here
      },


   //   home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
