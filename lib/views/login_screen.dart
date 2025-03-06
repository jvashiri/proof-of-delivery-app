import 'dart:io';

import 'package:driver_app/app_styles.dart';
import 'package:driver_app/views/poc_pod_screen.dart';
import 'package:driver_app/views/forgot_password_screen.dart'; // Import ForgotPasswordScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool _obscureText = true;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Both email and password are required")),
      );
      return;
    }

    setState(() => loading = true);

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No internet connection. Please try again later.")),
      );
      setState(() => loading = false);
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => PocPodScreen(isOnline: true))
      );
    } catch (e) {
      String errorMessage = "Login Failed: ${e.toString()}";
      
      // Check for specific error codes and show corresponding messages
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No user found for that email.";
            break;
          case 'wrong-password':
            errorMessage = "Wrong password provided for that user.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is badly formatted.";
            break;
          default:
            errorMessage = "Incorrect Email or Password";
        }
      } else if (e is SocketException) {
        errorMessage = "Network error. Please check your internet connection.";
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App heading
              Text("Login", style: headingStyle),

              SizedBox(height: 40),

              // Email Input Field
              TextField(
                controller: emailController,
                decoration: inputDecorationin("Email"),
                style: inputStyle,
              ),
              SizedBox(height: 20),

              // Password Input Field
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                style: inputStyle,
              ),
              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: login,
                style: buttonStyle,
                child: loading
                    ? CircularProgressIndicator(color: secondaryColor) // Show loading indicator
                    : Text("Login", style: TextStyle(color: secondaryColor)),
              ),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text("Forgot Password?", style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
