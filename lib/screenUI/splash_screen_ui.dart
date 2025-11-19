import 'package:flutter/material.dart';
import 'package:flutter_quiz_168/screenUI/page/bmr_home_ui.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BmrHomeUi(),
          ),
        );
      },
    );
    super.initState();
    // You can add any initialization logic here if needed
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/home_logo.jpg',
          width: 400,
          height: 300,
          // fit: BoxFit.none,
        ),
      ),
    );
  }
}
