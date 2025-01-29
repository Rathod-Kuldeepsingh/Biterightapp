// ignore_for_file: unused_import
//splash screen

import 'package:biterightapp/AuthenticationPage/sharepreffrences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Sharepreffrences()));
  }

  @override
  Widget build(BuildContext context) {
   // Get screen height

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content
            children: [
               Padding(
                  padding: const EdgeInsets.all(0),
                  child: Lottie.asset('asset/splash.json'),
                ),
                SizedBox(height: 20,),
                Text("BiteRight",
                style: GoogleFonts.hennyPenny(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                  )
                ),)
              
              
            ],
          ),
        ),
      ),
    );
  }
}