import 'package:flutter/material.dart';
import 'dart:io';
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
import 'utils/global_notifications_service.dart';
import 'utils/local_database_controller.dart';
import 'utils/local_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  // Initialize SQLITE
  await DatabaseController.initialize(); 

  // Check for current user
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId != null) {
    UserManager.updateUserId(currentUserId);
  }

  // Request notification permission
  await LocalNotificationsService().requestPermission();

  // Initialize FCMService
  final fcmService = await FCMService.initialize();
  UserManager.updateFCMService(fcmService);

  // Run the app
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
