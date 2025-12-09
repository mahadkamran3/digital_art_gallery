import 'package:flutter/material.dart';
import 'features/feed/feed_screen.dart';
import 'features/upload/upload_screen.dart';
import 'features/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const FeedScreen(),
    const UploadScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.blueAccent),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box, color: Colors.orangeAccent),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.greenAccent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
