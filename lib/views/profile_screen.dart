// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:driver_app/controllers/profile_controller.dart';
import 'package:driver_app/views/change_password_screen.dart';
import 'package:driver_app/app_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final email = await _controller.getUserEmail();
    setState(() {
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Email Text (No Card Background)
            Text(
              'Logged in as',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _email,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                        );
                      },
                      icon: const Icon(Icons.lock_outline),
                      label: const Text("Change Password"),
                      style: buttonStyle.copyWith(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.signOut(context),
                      icon: const Icon(Icons.logout),
                      label: const Text("Sign Out"),
                      style: buttonStyle.copyWith(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
