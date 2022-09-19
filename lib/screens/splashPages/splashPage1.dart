import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectagc/screens/navigationPage/navigationPage.dart';

const tt = "#182983";

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavigationPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 160,
            ),
            Center(
              child: Image.asset(
                "assets/images/agc2.png",
                height: 250,
                width: 250,
                fit: BoxFit.cover,
                semanticLabel: 'Logo of entreprise AGC',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                '20 ans de fidélité déjà, nous vous disons merci',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
