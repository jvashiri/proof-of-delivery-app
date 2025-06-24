import 'package:driver_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/app_styles.dart';
import 'package:driver_app/dashboard_screen.dart';
import 'package:driver_app/controllers/signup_controller.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController _controller = SignUpController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool loading = false;
  bool _obscureText = true;

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    FocusScope.of(context).unfocus();

    final error = await _controller.signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (error != null) {
      _showSnackbar(error);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => const DashboardScreen(isOnline: true)),
      );
    }

    setState(() => loading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
        if (!_controller.validateEmail(value.trim())) {
          return "Enter a valid email address";
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
        if (value == null || value.trim().isEmpty) {
          return "Password is required";
        }
        if (!_controller.validatePassword(value)) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        labelStyle: inputStyle,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      style: inputStyle,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please confirm your password";
        }
        if (value != passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: signUp,
      style: buttonStyle,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: secondaryColor),
            )
          : const Text("Sign Up", style: TextStyle(color: secondaryColor)),
    );
  }

  Widget _buildLoginOption() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: const Text(
        "Already have an account? Login",
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Sign Up", style: headingStyle),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 30),
          _buildSignUpButton(),
          const SizedBox(height: 16),
          _buildLoginOption(),
        ],
      ),
    );
  }
}
