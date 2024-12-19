import 'package:flutter/material.dart';

import 'my_pledged_gifts_screen.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'my_profile_screen.dart';

import '../components/bottom_nav_bar.dart';

class ParentPage extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreenView(),
      EventsScreen(),
      MyPledgedGiftsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe if navigation is only via BottomNavBar
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          color: Colors.black, // Ensure a solid background
          child: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
