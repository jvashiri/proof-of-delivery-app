import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/views/change_password_screen.dart'; // Import ChangePasswordScreen
import 'package:driver_app/app_styles.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Function to sign out
  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  /// Build Profile Content
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),

          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                );
              },
              icon: Icon(Icons.lock),
              label: Text("Change Password"),
              style: buttonStyle,
            ),
          ),

          SizedBox(height: 40),

          Center(
            child: ElevatedButton.icon(
              onPressed: _signOut,
              icon: Icon(Icons.exit_to_app),
              label: Text("Sign Out"),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar is now handled directly within the ProfileScreen widget
    return Scaffold(
     /* appBar: AppBar(
        title: Text("Profile Settings"),
        backgroundColor: primaryColor, // Custom color for the app bar
        automaticallyImplyLeading: false, // Disables back button
      ),*/
      backgroundColor: Colors.grey[200],
      body: _buildProfileContent(),
    );
  }
}
