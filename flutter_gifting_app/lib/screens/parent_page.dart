import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'my_pledged_gifts_screen.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'my_profile_screen.dart';

import '../utils/user_manager.dart ';

import '../components/bottom_nav_bar.dart';

class ParentPage extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  int _currentIndex = 0;
  // String? _userId; // To store the current user ID
  // bool _isLoading = true; // To track if the user ID is being fetched

  // // Initialize the user ID
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCurrentUserId();
  // }

  

  // Future<void> _fetchCurrentUserId() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception('No user is currently signed in.');
  //     }
  //     setState(() {
  //       UserManager.updateUserId(user.uid);
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     // Handle errors (e.g., navigate to login screen)
  //     print('Error fetching user ID: $e');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   // Show a loading spinner while fetching the user ID
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    // if (_userId == null) {
    //   // Handle case where user ID could not be fetched (e.g., show an error)
    //   return Scaffold(
    //     body: Center(
    //       child: Text('Failed to load user data. Please try again later.'),
    //     ),
    //   );
    // }

    // List of pages corresponding to the bottom navigation tabs
    final List<Widget> _pages = [
      HomeScreen(),
      EventsScreen(),
      MyPledgedGiftsPage(),
      ProfilePage(),
    ];

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
