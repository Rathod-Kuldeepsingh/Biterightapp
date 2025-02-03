// Assuming you have a homepage screen
//signing page
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _signUp() async {
    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        _showCustomSnackBar('Passwords do not match!');
        return;
      }

      if (!_validatePassword(password)) {
        _showCustomSnackBar(
            'Password must be at least 6 characters long, contain one uppercase letter and one special character!');
        return;
      }

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      await userCredential.user!.updateDisplayName(name);
      await FirebaseFirestore.instance.collection('kuldeep').add({
        'fullname': name,
        'email': email,
       
      });
      await userCredential.user!.sendEmailVerification();
      _showCustomSnackBar('Verification email sent to $email');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _showCustomSnackBar('Error: ${e.toString()}');
    }
    
  }
  

  bool _validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[\W_]).{6,}$');
    return passwordRegex.hasMatch(password);
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


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Getting the screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Make the entire screen scrollable
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  children: [
                    Lottie.asset("asset/cd.json", width: screenWidth * 0.6),
                    Text(
                      "Start your journey with just a few steps!",
                      style: GoogleFonts.splineSans(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.04, fontWeight: FontWeight.w400)),
                    )
                  ],
                ),
              ),
              // Name input field
              SizedBox(
                height: screenHeight * 0.02,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: const Color.fromRGBO(0, 0, 0, 1)),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),

              // Email input field
              TextField(
                controller: _emailController,
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
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Password input field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 10),

              // Confirm Password input field
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black),
                obscureText: !_isConfirmPasswordVisible,
              ),
             
              const SizedBox(height: 50),

              // Sign Up button
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen()), // Navigate to the home page
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
