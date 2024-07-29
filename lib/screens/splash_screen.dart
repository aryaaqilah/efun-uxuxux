import 'package:flutter/material.dart';
import 'package:photo_editor/screens/start_screen.dart'; // Import the home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the HomeScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/start');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF49919D),
      body: Center(
        child: Image.asset(
            'assets/logo/logo-white.png'), // Ensure this image exists in your assets
      ),
    );
  }
}
