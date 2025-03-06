import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:driver_app/screens/poc_pod_screen.dart';
import 'package:driver_app/app_styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  /// Function to change password
  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    User? user = _auth.currentUser;
    if (user == null) {
      _showSnackbar("User not found. Please sign in again.");
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showSnackbar("New password must be at least 6 characters.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackbar("New password and confirm password do not match.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(_newPasswordController.text);

      _showSnackbar("Password changed successfully. Please log in again.");
      await _auth.signOut();

      // Redirect to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'wrong-password') {
        _showSnackbar("Old password is incorrect.");
      } else if (e.code == 'weak-password') {
        _showSnackbar("New password is too weak.");
      } else if (e.code == 'user-mismatch' || e.code == 'user-not-found') {
        _showSnackbar("User session expired. Please log in again.");
        await _auth.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showSnackbar("Error: ${e.message}");
      }
    } catch (e) {
      _showSnackbar("An unexpected error occurred: ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Function to show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Reusable text field for password input
  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 5),
        Container(
          decoration: inputDecoration,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(border: InputBorder.none),
            style: inputStyle,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Old Password", _oldPasswordController, obscureText: true),
            _buildTextField("New Password", _newPasswordController, obscureText: true),
            _buildTextField("Confirm New Password", _confirmPasswordController, obscureText: true),

            SizedBox(height: 20),

            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _changePassword,
                      icon: Icon(Icons.lock),
                      label: Text("Change Password"),
                      style: buttonStyle,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
