

import 'package:biterightapp/Articles/artcles.dart';
import 'package:biterightapp/AuthenticationPage/forgotpage.dart';
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:biterightapp/AuthenticationPage/sign-inscreen.dart';
import 'package:biterightapp/HomePage/home.dart';
import 'package:biterightapp/MainPages/dash.dart';
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
    '/home' : (context) =>Home(),
    '/mainpage':(context) => BarcodeSearchScreen(),
    '/forgot' : (context) => Emailf(),
    '/signup1' : (context) => SignUpScreen() ,
    '/login' : (context)=> LoginScreen()
    },
  ));
}

//main file
