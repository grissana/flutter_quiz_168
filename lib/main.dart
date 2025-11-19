// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_quiz_168/screenUI/splash_screen_ui.dart';
// import 'package:flutter_quiz_168/screenUI/splash_screen_ui.dart';
// import 'package:flutter_quiz_168/test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://gbaeowyevjulwpvrahen.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdiYWVvd3lldmp1bHdwdnJhaGVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NTA4MDYsImV4cCI6MjA3OTEyNjgwNn0.z_cVCEeDVBcnAckkTl520__G_a8H7sHoU2hsMRkfiOA',
  );

  runApp(flutter_quiz_168());
}

class flutter_quiz_168 extends StatefulWidget {
  const flutter_quiz_168({super.key});

  @override
  State<flutter_quiz_168> createState() => _flutter_quiz_168State();
}

class _flutter_quiz_168State extends State<flutter_quiz_168> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenUi(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
