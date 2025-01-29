
import 'package:biterightapp/AuthenticationPage/sharepreffrences.dart';
import 'package:biterightapp/AuthenticationPage/sign-inscreen.dart';
import 'package:biterightapp/HomePage/home.dart';
import 'package:biterightapp/SplashPage/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    routes: {
   
    },
  ));
}

// ignore: camel_case_types
