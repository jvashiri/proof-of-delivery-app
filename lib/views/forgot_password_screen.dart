import 'package:driver_app/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email to reset password")),
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
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to your email")),
      );
      Navigator.pop(context); // Go back to the login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send password reset email: ${e.toString()}")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App heading
              Text("Reset Password", style: headingStyle),

              SizedBox(height: 40),

              // Email Input Field
              TextField(
                controller: emailController,
                decoration: inputDecorationin("Email"),
                style: inputStyle,
              ),
              SizedBox(height: 20),

              // Reset Password Button
              ElevatedButton(
                onPressed: resetPassword,
                style: buttonStyle,
                child: loading
                    ? CircularProgressIndicator(color: secondaryColor) // Show loading indicator
                    : Text("Send Reset Link", style: TextStyle(color: secondaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
