import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../controllers/controller_events_screen.dart';
import '../components/event_card.dart';
import '../models/event.dart';
import 'event_creation_screen.dart';
import '../components/sort_options.dart';
import '../components/search_bar.dart';

class EventsScreen extends StatefulWidget {
  final String userId;

  EventsScreen({required this.userId});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController searchController = TextEditingController();
  final EventRepository _eventRepository = EventRepository();
  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];
  String? selectedSort;
  bool isMyEventsSelected = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    searchController.addListener(_filterAndSortEvents); // Listen to search input
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    final userId = widget.userId;
    final fetchedEvents = isMyEventsSelected
        ? await _eventRepository.fetchMyEvents(userId)
        : await _eventRepository.fetchFriendsEvents(userId);
    setState(() {
      events = fetchedEvents;
      _filterAndSortEvents();
    });
  }

  void _filterAndSortEvents() {
    final query = searchController.text.toLowerCase();

    setState(() {
      // Filter events based on the search query
      filteredEvents = events.where((event) {
        final name = event.name.toLowerCase();
        final category = event.category.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();

      // Sort events based on the selected sort option
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
    });
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMyEventsSelected = (text == "My Events");
          _loadEvents(); // Refresh events on toggle
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
                  ? Center(child: Text("No events found", style: AppFonts.body))
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return EventCard(
                          event: event,
                          onView: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("View clicked for: ${event.name}")),
                            );
                          },
                          onDeleteUpdateScreen: () => _loadEvents(), // Reload events after deletion
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventCreationScreen(userId: widget.userId)),
                ).then((_) => _loadEvents());
              },
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
