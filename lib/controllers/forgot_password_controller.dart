// controllers/forgot_password_controller.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController {
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return "The email address is badly formatted.";
    }
    return null;
  }

  Future<void> resetPassword(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showSnackBar(context, "No internet connection. Please try again later.");
      loading.value = false;
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      _showSnackBar(context, "Password reset link sent to your email");
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(context, "Failed to send reset email. Please try again.");
    }

    loading.value = false;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
