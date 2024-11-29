import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
// import 'screens/my_events_screen.dart';
import 'screens/my_pledged_gifts_screen.dart';
import 'screens/parent_page.dart';

void main() {
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

      home: ParentPage(),

    );
  }
}
