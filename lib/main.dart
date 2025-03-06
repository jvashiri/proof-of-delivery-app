import 'package:driver_app/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/poc_pod_screen.dart'; // Import PocPodScreen here
import 'views/profile_screen.dart'; // Import ProfileScreen here
import 'views/sync_screen.dart'; // Import SyncScreen here
import 'views/forgot_password_screen.dart'; // Import ForgotPasswordScreen here
import 'firebase_options.dart'; // Firebase options for initialization
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : BottomNavWrapper(), // Check if user is logged in
      routes: {
        '/login': (context) => LoginScreen(),
        '/poc_pod': (context) => PocPodScreen(isOnline: true),
        '/profile': (context) => ProfileScreen(), // Define route for ProfileScreen
        '/sync': (context) => SyncScreen(), // Define route for SyncScreen
        '/forgot_password': (context) => ForgotPasswordScreen(), // Define route for ForgotPasswordScreen
        '/dashboard': (context) => BottomNavWrapper(), // Define route for DashboardScreen
      },
    );
  }
}

class BottomNavWrapper extends StatefulWidget {
  @override
  _BottomNavWrapperState createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0; // Set the initial index to 0 for offline mode

  // List of screens to display based on the selected tab
  final List<Widget> _screens = [
    PocPodScreen(isOnline: false), // First screen (Offline POC/POD)
    PocPodScreen(isOnline: true),  // Second screen (Online POC/POD)
    ProfileScreen(),               // Third screen (Profile)
    SyncScreen(),                  // Fourth screen (Sync Data)
  ];

  // Handle navigation change
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Function to get the app bar title based on the selected index
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Offline POD';
      case 1:
        return 'Online POD';
      case 2:
        return 'SETTINGS';
      case 3:
        return 'SYNC DATA';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_currentIndex)), // Set title based on index
        centerTitle: true,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 165, 30, 30),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped, // Handle item tap
        backgroundColor: Colors.white, // Set background color
        selectedItemColor: primaryColor, // Set selected item color
        unselectedItemColor: Colors.grey, // Set unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_off),
            label: 'Offline POD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Online POD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'SETTINGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'SYNC DATA',
          ),
        ],
      ),
    );
  }
}
