import 'package:flutter/material.dart';
import '../models/gift.dart';

class MyPledgedGiftsController {
  final TextEditingController searchController = TextEditingController();

  // Internal list of gifts and filtered gifts
  List<GiftModel> gifts = [];
  List<GiftModel> filteredGifts = [];

  String? selectedSort;

  // Callback for notifying the View
  VoidCallback onGiftsUpdated;

  MyPledgedGiftsController({required this.onGiftsUpdated}) {
    searchController.addListener(filterAndSortGifts);
  }

  // Load gifts using the model
  Future<void> loadGifts() async {
    try {
      final fetchedGifts = await GiftModel.getMyPledgedGifts();
      gifts = fetchedGifts;
      filteredGifts = List.from(gifts);
      onGiftsUpdated(); // Notify the View to update
    } catch (e) {
      print("Error loading gifts: $e");
      rethrow;
    }
  }

  // Filter and sort gifts based on search input and selected sort
  void filterAndSortGifts() {
    final query = searchController.text.trim().toLowerCase();

    filteredGifts = gifts.where((gift) {
      final name = gift.name.toLowerCase();
      final description = gift.description.toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();

    // Apply sorting if a sort option is selected
    if (selectedSort != null) {
      filteredGifts.sort((a, b) {
        switch (selectedSort) {
          case "Category":
            return a.category.compareTo(b.category);
          case "Name":
            return a.name.compareTo(b.name);
          case "Status":
            return a.status.compareTo(b.status);
          default:
            return 0;
        }
      });
    }

    onGiftsUpdated(); // Notify the View to refresh
  }

  // Update selected sorting option
  void updateSort(String sortOption) {
    selectedSort = sortOption;
    filterAndSortGifts();
  }

  // Dispose resources
  void dispose() {
    searchController.dispose();
  }
}
