import 'package:driver_app/views/signup.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/app_styles.dart';
import 'package:driver_app/dashboard_screen.dart';
import 'package:driver_app/views/forgot_password_screen.dart';
import 'package:driver_app/controllers/login_controller.dart'; 
// Import your SignUpForm here

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = LoginController(); // Use controller

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool _obscureText = true;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    final error = await _controller.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (error != null) {
      _showSnackbar(error);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen(isOnline: true)),
        (route) => false,
      );
    }

    setState(() => loading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecorationin("Email"),
      style: inputStyle,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Email is required";
        }
        if (!_controller.validateEmail(value)) {
          return "The email address is badly formatted.";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: inputStyle,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      style: inputStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: login,
      style: buttonStyle,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: secondaryColor),
            )
          : const Text("Login", style: TextStyle(color: secondaryColor)),
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
        );
      },
      child: const Text("Forgot Password?", style: TextStyle(color: primaryColor)),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        );
      },
      child: const Text("Don't have an account? Sign Up", style: TextStyle(color: primaryColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Login", style: headingStyle),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 30),
          _buildLoginButton(),
          const SizedBox(height: 16),
          _buildForgotPasswordLink(),
          _buildSignUpButton(),  // Added here
        ],
      ),
    );
  }
}
