import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sign out the user and redirect to login
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error signing out: ${e.toString()}")),
      );
    }
  }

  /// Get user email
  Future<String> getUserEmail() async {
    final user = _auth.currentUser;
    return user?.email ?? 'No email found';
  }

  /// Upload profile image to Firebase Storage and update Firestore with the URL
  Future<void> uploadProfileImage(File image, BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ User not logged in.")),
      );
      return;
    }

    if (!image.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Selected image does not exist.")),
      );
      return;
    }

    final ref = _storage.ref().child("profile_images/${user.uid}.jpg");

    try {
      // Upload the image with contentType metadata
      await ref.putFile(
        image,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final imageUrl = await ref.getDownloadURL();

      // Save the image URL to Firestore
      await _firestore.collection("users").doc(user.uid).set({
        "profileImage": imageUrl,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile picture updated.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to upload image: $e")),
      );
    }
  }

  /// Fetch profile image URL from Firestore
  Future<String?> getProfileImageUrl() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    return doc.data()?["profileImage"];
  }
}
