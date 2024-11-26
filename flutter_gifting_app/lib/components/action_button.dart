import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;

  const ActionButton({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
                                                              // Strategy DP can be used
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
    );
  }
}
