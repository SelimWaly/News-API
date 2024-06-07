import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/select_country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: StartupScreen(),
      routes: {
        '/selectCountry': (context) => CountryPickerScreen(),
      },
    );
  }
}

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1, milliseconds: 500),
          () => Navigator.pushReplacementNamed(context, '/selectCountry'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'News App',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
