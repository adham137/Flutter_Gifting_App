import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../components/event_card.dart';
import 'event_details.dart';
import '../components/search_bar.dart';
import '../components/sort_options.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedSort;
  bool isMyEventsSelected = true;

  // Dummy data for events
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _filterAndSortEvents();
    searchController.addListener(_filterAndSortEvents);
  }

  void _loadDummyData() {
    // Load dummy data for "My Events" and "Friends Events"
    events = [
      // My Events
      {
        "name": "Adham Yasser",
        "title": "Grad",
        "location": "Ain Shams University",
        "date": "15/9/2025",
        "time": "8:00 PM",
        "status": "Current",
        "isMine": true,
      },
      {
        "name": "Adham Yasser",
        "title": "My Birthday",
        "location": "McDonalds El-Serag",
        "date": "13/7/2025",
        "time": "12:00 AM",
        "status": "Upcoming",
        "isMine": true,
      },
      // Friends' Events
      {
        "name": "Ziad",
        "title": "Ziad's Birthday",
        "location": "New Giza, Egypt",
        "date": "13/7/2025",
        "time": "12:00 AM",
        "status": "Upcoming",
        "isMine": false,
      },
      {
        "name": "Ahmed",
        "title": "Birthday",
        "location": "Cairo, Egypt",
        "date": "24/10/2024",
        "time": "8:00 PM",
        "status": "Current",
        "isMine": false,
      },
      {
        "name": "Mohamed",
        "title": "Promotion",
        "location": "New Giza, Egypt",
        "date": "13/7/2025",
        "time": "12:00 AM",
        "status": "Upcoming",
        "isMine": false,
      },
    ];
    // Initially, filteredEvents should contain all the events
    filteredEvents = List.from(events);
  }

  void _filterAndSortEvents() {
    final query = searchController.text.toLowerCase();

    setState(() {
      // Filter based on search and toggle
      filteredEvents = events
          .where((event) {
            final isMatchingTab = isMyEventsSelected == event["isMine"];
            final matchesSearch = event["name"].toLowerCase().contains(query) ||
                event["title"].toLowerCase().contains(query);
            return isMatchingTab && matchesSearch;
          })
          .toList();

      // Sort based on selected option
      if (selectedSort != null) {
        filteredEvents.sort((a, b) {
          switch (selectedSort) {
            case "Category": // Assuming "Category" is related to "status"
              return a["status"].compareTo(b["status"]);
            case "Name":
              return a["name"].compareTo(b["name"]);
            case "Status":
              return a["status"].compareTo(b["status"]);
            default:
              return 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _toggleButton("Friends Events", !isMyEventsSelected),
            SizedBox(width: 8),
            _toggleButton("My Events", isMyEventsSelected),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            MySearchBar(controller: searchController),
            SizedBox(height: 16),
            // Sort Options
            SortOptions(
              selectedSort: selectedSort,
              onSortSelected: (sort) {
                setState(() {
                  selectedSort = sort;
                  _filterAndSortEvents();
                });
              },
            ),
            SizedBox(height: 16),
            // Event List
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(child: Text("No events found"))
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return EventCard(
                          name: event["name"],
                          title: event["title"],
                          location: event["location"],
                          date: event["date"],
                          time: event["time"],
                          status: event["status"],
                          onDelete: event["isMine"] ? () {} : null,
                          onEdit: event["isMine"] ? () {} : null,
                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyEventPage(
                                  eventName: event["title"],
                                  eventDate: event["date"],
                                  eventTime: event["time"],
                                  eventLocation: event["location"],
                                  eventDescription: "Event Description here",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isMyEventsSelected
          ? FloatingActionButton(
              onPressed: () {
                // Handle Add Event action
              },
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMyEventsSelected = (text == "My Events");
          _filterAndSortEvents(); // Refresh events on toggle
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: isSelected ? AppFonts.button : AppFonts.body,
        ),
      ),
    );
  }
}
