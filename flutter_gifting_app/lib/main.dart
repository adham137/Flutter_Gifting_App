import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/my_pledged_gifts_screen.dart';
import 'screens/parent_page.dart';

import '../utils/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //if (FirebaseAuth.instance.currentUser == null)
  await Firebase.initializeApp();

  // Get current user
  UserManager.updateUserId(FirebaseAuth.instance.currentUser?.uid);

  runApp(HedieatyApp());

}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hediety App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // Define initial route based on Firebase authentication state
      initialRoute: UserManager.currentUserId == null
          ? '/sign-in'
          : '/parent',
      routes: {
        '/parent': (context) => ParentPage(),
        //'/home': (context) => HomeScreen(),
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
        '/pledged-gifts': (context) => MyPledgedGiftsPage(),
      },
    );
  }
}
