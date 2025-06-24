import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
// Initialize with the current user

  AuthProvider() {
    // Listen for changes in the user
    FirebaseAuth.instance.userChanges().listen((User? user) {
      notifyListeners(); // Notify listeners of state changes
    });
  }

  // Check if the user is logged in
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // Method to sign out the user
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
