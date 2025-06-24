import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/change_password_model.dart';

class ChangePasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword(
    ChangePasswordModel model,
    BuildContext context,
    VoidCallback onStart,
    VoidCallback onComplete,
  ) async {
    onStart();

    final user = _auth.currentUser;
    if (user == null) {
      _showSnackbar(context, "User not found. Please sign in again.");
      onComplete();
      return;
    }

    final error = model.validationError();
    if (error != null) {
      _showSnackbar(context, error);
      onComplete();
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: model.oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(model.newPassword);

      _showSnackbar(context, "Password changed successfully. Please log in again.");
      await _auth.signOut();

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackbar(context, "Old password is incorrect.");
      } else if (e.code == 'weak-password') {
        _showSnackbar(context, "New password is too weak.");
      } else if (['user-mismatch', 'user-not-found'].contains(e.code)) {
        _showSnackbar(context, "User session expired. Please log in again.");
        await _auth.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        _showSnackbar(context, "Error: ${e.message}");
      }
      onComplete();
    } catch (e) {
      _showSnackbar(context, "Unexpected error: $e");
      onComplete();
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
