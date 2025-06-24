// Importing necessary Flutter and Dart packages
import 'package:flutter/material.dart';

// Importing Firebase core for initialization
import 'package:firebase_core/firebase_core.dart';

// Importing Provider for state management
import 'package:provider/provider.dart';

// Importing application-specific files
import 'package:driver_app/dashboard_screen.dart';
import 'package:driver_app/views/offline_sync.dart';
import 'package:driver_app/views/profile_screen.dart';
import 'views/login_screen.dart';
import 'views/signup.dart';
import 'views/forgot_password_screen.dart';
import 'firebase_options.dart';
import 'localAuth_provider.dart' as local_auth_provider; // Aliasing to avoid name conflicts

void main() async {
  // Ensures widget binding is initialized before Firebase is called
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase using platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Launching the Flutter app and injecting the AuthProvider using Provider package
  runApp(
    ChangeNotifierProvider(
      create: (_) => local_auth_provider.AuthProvider(), // Provides the AuthProvider instance to the widget tree
      child: const MyApp(), // Root widget of the app
    ),
  );
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in release mode

      // Dynamically sets home screen based on the login state
      home: Consumer<local_auth_provider.AuthProvider>(
        builder: (context, authProvider, _) {
          // If user is logged in, show Dashboard; otherwise, show Login screen
          return authProvider.isLoggedIn ? const DashboardScreen(isOnline: false,) : const LoginScreen();
        },
      ),

      // Declares routes used in the application for navigation
      routes: {
        '/login': (context) => const LoginScreen(),  
        '/SignUp': (context) => const SignupScreen(),                          // Login page route
        '/dashboard': (context) => const DashboardScreen(isOnline: false,), // Dashboard route
        '/forgot_password': (context) => const ForgotPasswordScreen(),    // Password recovery screen
        '/profile': (context) => const ProfileScreen(),                   // User profile screen
        '/sync': (context) => const SyncScreen(),                         // Offline sync screen
      },
    );
  }
}
