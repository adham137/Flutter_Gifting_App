import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class SortOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SortButton(label: "Category"),
        SortButton(label: "Name"),
        SortButton(label: "Status"),
      ],
    );
  }
}

class SortButton extends StatelessWidget {
  final String label;

  const SortButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Sorting logic to be implemented
      },
      child: Text(label, style: AppFonts.body),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightGrey,
        foregroundColor: AppColors.darkGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
