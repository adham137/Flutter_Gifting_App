import 'package:flutter/material.dart';
import 'my_pledged_gifts_screen.dart';
import 'my_events_screen.dart'; 
import 'home_screen.dart'; 
import 'my_profile_screen.dart';

import '../components/bottom_nav_bar.dart';
//import 'profile_page.dart'; // Replace with actual page files

class ParentPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ParentPage> {
  int _currentIndex = 0;

  // List of pages corresponding to the bottom navigation tabs
  final List<Widget> _pages = [
    HomeScreen(),
    MyEventsScreen(),
    MyPledgedGiftsPage(),
    ProfilePage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Show the selected page
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex, // Pass the current index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
