import 'package:flutter/material.dart';
import 'sort_options.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSearch;
  final void Function(String)? onSort;
  final bool enableSorting;
  final String? selectedSort;

  const MySearchBar({
    required this.controller,
    this.onSearch,
    this.onSort,
    this.enableSorting = false,
    this.selectedSort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onSearch,
          ),
        ),
        if (enableSorting && onSort != null) ...[
          SizedBox(height: 8),
          SortOptions(
            selectedSort: selectedSort,
            onSortSelected: onSort,
          ),
        ],
      ],
    );
  }
}
