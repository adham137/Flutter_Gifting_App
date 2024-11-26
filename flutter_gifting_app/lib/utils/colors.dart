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
  static const Color darkGrey = Color(0xFF757575);

  static const Map<String, Color> statusColors = {
    "Pending": Colors.yellow,
    "Completed": Colors.green,
    "Failed": Colors.red,
  };
}
