
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Emailf extends StatefulWidget {
  const Emailf({super.key});

  @override
  State<Emailf> createState() => _EmailfState();
}

class _EmailfState extends State<Emailf> {
  final TextEditingController emailController = TextEditingController();
  String message = '';

  Future<void> sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      setState(() {
        
        _showCustomSnackBar("Reset Password link send to your Mail");
         goToThank(context);
      });
    } catch (e) {
      setState(() {
        message = 'Error: ${e.toString()}';
        _showCustomSnackBar(message);
      });
    }
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        elevation: 6,
      ),
    );
  }

  void goToThank(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                // Add Lottie animation
                Lottie.asset("asset/cd.json", width: 200),

                const SizedBox(height: 50),

                // Title
                Text(
                  "Forgot Password",
                  style: GoogleFonts.splineSans(
                          textStyle: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700)),
                ),

                const SizedBox(height: 15),

                // Subheading
                Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.splineSans(
                          textStyle: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                ),

                const SizedBox(height: 100),

                // Email Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sendPasswordResetEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Error message display (if any)
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
