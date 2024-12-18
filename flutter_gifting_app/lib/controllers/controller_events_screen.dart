import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../utils/user_manager.dart';

class EventsController {
  final VoidCallback onUpdate;

  final TextEditingController searchController = TextEditingController();
  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];
  String? selectedSort;
  bool isMyEventsSelected = true;

  EventsController({required this.onUpdate}) {
    searchController.addListener(filterAndSortEvents);
  }

  void dispose() {
    searchController.dispose();
  }

  Future<void> loadEvents() async {
    final fetchedEvents = isMyEventsSelected
        ? await EventModel.getEventsByUser(UserManager.currentUserId!)
        : await fetchMyFriendsEvents();

    events = fetchedEvents;
    filterAndSortEvents();
  }

  void filterAndSortEvents() {
    final query = searchController.text.toLowerCase();
    filteredEvents = events.where((event) {
      final name = event.name.toLowerCase();
      final category = event.category.toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();

    if (selectedSort != null) {
      filteredEvents.sort((a, b) {
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
    onUpdate(); // Notify the view
  }

  void updateSort(String? sort) {
    selectedSort = sort;
    filterAndSortEvents();
  }

  void toggleEventView(bool myEventsSelected) {
    isMyEventsSelected = myEventsSelected;
    loadEvents();
  }

  Future<List<EventModel>> fetchMyFriendsEvents() async {
    List<EventModel> friendsEvents = [];
    // Get friends ids
    List<String> friendsIds = await UserModel.getUser(UserManager.currentUserId!).then((user){
      return user!.friends;
    });

    for (String friendId in friendsIds) {
      friendsEvents.addAll( await EventModel.getEventsByUser(friendId) );
    }

    return friendsEvents;
  }
}

