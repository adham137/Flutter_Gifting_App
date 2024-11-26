import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/my_events_screen.dart';

void main() {
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyEventsScreen(),

        // Add more routes as needed
      },
    );
  }
}
