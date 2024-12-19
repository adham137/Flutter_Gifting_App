import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class ActionButton extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final Icon? icon;
  final String? label;
  final double? width;
  final double? height;

  const ActionButton({

    required this.color,
    required this.text,
    required this.textStyle,
    required this.onPressed,
    this.icon,
    this.label,
    this.width = 20,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? Icon(Icons.circle, color: AppColors.teal, size: 24),
      label: label!=null?Text(label!, style: textStyle):Text(text, style: textStyle),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: height!, horizontal: width!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black12,
      ),
      
    );
  }
}


