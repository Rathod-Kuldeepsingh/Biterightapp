//sharepreferences
import 'package:biterightapp/HomePage/home.dart';
import 'package:biterightapp/OnboardingPage/onboardingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sharepreffrences extends StatelessWidget {
  const Sharepreffrences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder:(context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
       return const Center(
        child: CircularProgressIndicator(),
       );
      }
      else if(snapshot.hasError){
       return const Center(child: Text("Error"),);

      }
      else{
       if(snapshot.data == null){
        return const OnboardingScreen();
       
       }
       else{

        return Home();
        
       }
      }
    },),
    );
  }
}