import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RegExp _emailRegex =
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  bool validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return _emailRegex.hasMatch(value.trim());
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return "No internet connection. Please try again later.";
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        await _ensureUserDocument(user);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No user found for that email.";
        case 'wrong-password':
          return "Wrong password provided.";
        default:
          return "Incorrect Email or Password.";
      }
    } on SocketException {
      return "Network error. Please check your internet connection.";
    } catch (_) {
      return "Login failed. Please try again.";
    }
  }

  Future<void> _ensureUserDocument(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final photoURL = (user.photoURL != null && user.photoURL!.isNotEmpty)
          ? user.photoURL
          : null;

      await docRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        if (photoURL != null) 'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> uploadProfilePicture(File imageFile, String uid) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uid.jpg');

      final uploadTask = await ref.putFile(imageFile);
      final url = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({
        'photoURL': url,
      });

      return url;
    } catch (e) {
      if (kDebugMode) {
        print("Upload failed: $e");
      }
      return null;
    }
  }
}
