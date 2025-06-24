import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validateEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }
}
