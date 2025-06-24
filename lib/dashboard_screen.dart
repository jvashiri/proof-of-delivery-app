import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';

import '../app_styles.dart';
import '../views/poc_pod_screen.dart' as pocPod;
import '../views/profile_screen.dart';
import '../views/offline_sync.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required bool isOnline});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const pocPod.PocPodScreen(isOnline: true),
    const ProfileScreen(),
    const SyncScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return kIsWeb ? 'Online POD' : 'Offline POD';
      case 1:
        return 'Profile';
      case 2:
        return 'Sync PODs';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_off),
            label: kIsWeb ? 'Online POD' : 'Offline POD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Sync',
          ),
        ],
      ),
    );
  }
}
