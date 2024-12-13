import 'package:flutter/material.dart';

import 'colors.dart';

class AppFonts {
  static const TextStyle header = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
