import 'package:flutter/material.dart';
import 'package:driver_app/app_styles.dart';
import '../models/change_password_model.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _controller = ChangePasswordController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChangePassword() {
    final model = ChangePasswordModel(
      oldPassword: _oldPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    _controller.changePassword(
      model,
      context,
      () => setState(() => _isLoading = true),
      () => setState(() => _isLoading = false),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 5),
          Container(
            decoration: inputDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: const InputDecoration(border: InputBorder.none),
              style: inputStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Old Password", _oldPasswordController, obscure: true),
            _buildTextField("New Password", _newPasswordController, obscure: true),
            _buildTextField("Confirm New Password", _confirmPasswordController, obscure: true),
            const SizedBox(height: 20),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _onChangePassword,
                      icon: const Icon(Icons.lock),
                      label: const Text("Change Password"),
                      style: buttonStyle,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
