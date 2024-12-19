import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EA);
  static const Color secondary = Colors.teal;
  static const Color accent = Colors.blueAccent;
  static const Color background = Color(0xFFF5F5F5);
  static const Color text = Colors.black87;
  static const Color badgeCurrent = Colors.green;
  static const Color badgeUpcoming = Colors.blue;

  static const Color lightGrey = Color(0xFFF5F5F5);

  static const Color purple = Colors.purple;
  static const Color teal = Color.fromRGBO(2, 171, 176, 100);
  static const Color babyBlue = Color.fromRGBO(184, 226, 242, 100);
  static const Color lightPurple = Color.fromRGBO(144, 92, 163, 1);
  static const Color darkGrey = Color.fromRGBO(217, 217, 217, 100);
  static const Color yellow = Colors.yellowAccent;

  static const Map<String, Color> statusColors = {
    "Pending": Colors.yellow,
    "Completed": Colors.green,
    "Failed": Colors.red,
    "Available": Colors.green,
    "Pledged": Colors.orange,
    "Upcomming": Colors.green,
    "Past": Colors.red,
  };
}
