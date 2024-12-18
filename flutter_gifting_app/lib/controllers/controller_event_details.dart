// controllers/my_event_controller.dart

import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/gift.dart';

class MyEventController {
  final EventModel event;
  String? selectedSort;
  List<GiftModel> gifts = [];
  List<GiftModel> filteredGifts = [];

  MyEventController({required this.event});

  // Load gifts for the event
  Future<void> loadGifts() async {
    try {
      gifts = await GiftModel.getGiftsByEvent(event.eventId);
      filterAndSortGifts();
    } catch (e) {
      // Handle errors gracefully
      debugPrint("Error loading gifts: $e");
    }
  }

  // Filter and sort the gift list
  void filterAndSortGifts() {
    filteredGifts = List.from(gifts);
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
  }

  // Set the sorting option and update filtered list
  void updateSortOption(String? sortOption) {
    selectedSort = sortOption;
    filterAndSortGifts();
  }
}
