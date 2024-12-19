import 'package:flutter/material.dart';
import 'package:flutter_gifting_app/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Black fill color
        // border: Border(
        //   top: BorderSide(color: Colors.black, width: 2), // Black top border
        // ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex, // Highlight the selected tab
        onTap: onTap, // Call the navigation callback
        backgroundColor: AppColors.lightPurple, // Black background
        selectedItemColor: Colors.yellow, // Highlight selected icon in red
        unselectedItemColor: Colors.white, // White for unselected icons
        type: BottomNavigationBarType.fixed, // Ensure all icons are visible
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'My Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
