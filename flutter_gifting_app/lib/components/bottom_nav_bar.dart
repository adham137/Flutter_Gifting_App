import 'package:flutter/material.dart';
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.group, color: Colors.black,),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event, color: Colors.black,),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard, color: Colors.black,),
          label: 'My Gifts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black,),
          label: 'Profile',
        ),
      ],
    );
  }
}