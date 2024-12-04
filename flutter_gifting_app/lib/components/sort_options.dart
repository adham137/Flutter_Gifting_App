import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class SortOptions extends StatelessWidget {
  final String? selectedSort;
  final Function(String)? onSortSelected;

  const SortOptions({
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SortButton(
          label: "Category",
          isSelected: selectedSort == "Category",
          onPressed: () => onSortSelected!("Category"),
        ),
        SortButton(
          label: "Name",
          isSelected: selectedSort == "Name",
          onPressed: () => onSortSelected!("Name"),
        ),
        SortButton(
          label: "Status",
          isSelected: selectedSort == "Status",
          onPressed: () => onSortSelected!("Status"),
        ),
      ],
    );
  }
}

class SortButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const SortButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: AppFonts.body),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.darkGrey : AppColors.lightGrey,
        foregroundColor: isSelected ? Colors.white : AppColors.darkGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
