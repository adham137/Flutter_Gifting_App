import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Highlight the selected tab
      onTap: onTap, // Call the navigation callback
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.group, color: Colors.black),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event, color: Colors.black),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard, color: Colors.black),
          label: 'My Gifts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: "Profile"
          
        ),
      ],
    );
  }
}
