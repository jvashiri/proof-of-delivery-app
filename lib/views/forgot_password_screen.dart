// views/forgot_password_screen.dart
import 'package:driver_app/app_styles.dart';
import 'package:driver_app/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordController _controller = ForgotPasswordController();

  @override
  void dispose() {
    _controller.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Reset Password", style: headingStyle),
                  const SizedBox(height: 32),

                  // Email Field
                  TextFormField(
                    controller: _controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: inputStyle,
                    decoration: inputDecorationin("Email"),
                    validator: _controller.validateEmail,
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () => _controller.resetPassword(context, _formKey),
                    style: buttonStyle,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _controller.loading,
                      builder: (context, loading, _) {
                        return loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: secondaryColor,
                                ),
                              )
                            : const Text("Send Reset Link", style: TextStyle(color: secondaryColor));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
