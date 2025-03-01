


// ignore_for_file: unused_import

import 'package:biterightapp/About/about.dart';
import 'package:biterightapp/Articles/articals.dart';
import 'package:biterightapp/AuthenticationPage/forgotpage.dart';
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:biterightapp/AuthenticationPage/sign-inscreen.dart';
import 'package:biterightapp/Feedback/Feedback.dart';
import 'package:biterightapp/History/history.dart';
import 'package:biterightapp/HomePage/home.dart';
import 'package:biterightapp/MainPages/dash.dart';
import 'package:biterightapp/MainPages/product.dart';
import 'package:biterightapp/Profile/profile.dart';
import 'package:biterightapp/SplashPage/splashscreen.dart';
import 'package:biterightapp/Suppport/Support.dart';
import 'package:biterightapp/home2/compare.dart';
import 'package:biterightapp/home2/h2.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//  final product1 = {'product_name': 'Product 1', 'nutriments': {'energy-kcal': 100, 'fat': 10}};
//  final product2 = {'product_name': 'Product 2', 'nutriments': {'energy-kcal': 120, 'fat': 8}};


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    routes: {
    '/productDetail': (context) => ProductDetailScreen(product: {}),
    '/history': (context) => HistoryPage(),
    '/home' : (context) => Home(),
    '/mainpage':(context) => BarcodeSearchScreen(),
    '/forgot' : (context) => Emailf(),
    '/signup1' : (context) => SignUpScreen() ,
    '/login' : (context)=> LoginScreen(),
    '/feedback' : (context)=> FeedbackScreen(),
    '/about' : (context) => AboutUsPage(),
    '/support': (context) => SupportHelpPage(),
    '/compare': (context) => ProductComparisonScreen()

    },
  ));
}

//main file
