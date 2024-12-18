import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/user_manager.dart';

import '../controllers/controller_events_screen.dart';

import '../components/event_card.dart';
import '../components/sort_options.dart';
import '../components/search_bar.dart';


import 'event_creation_screen.dart';
import 'event_details.dart';


class EventsScreen extends StatefulWidget {
  final String userId = UserManager.currentUserId!;

  EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late EventsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EventsController(onUpdate: _refreshView);
    _controller.loadEvents();
  }

  void _refreshView() => setState(() {});

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _controller.toggleEventView(text == "My Events");
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
    final events = _controller.filteredEvents;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _toggleButton("Friends Events", !_controller.isMyEventsSelected),
            SizedBox(width: 8),
            _toggleButton("My Events", _controller.isMyEventsSelected),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MySearchBar(controller: _controller.searchController),
            SizedBox(height: 16),
            SortOptions(
              selectedSort: _controller.selectedSort,
              onSortSelected: (sort) => _controller.updateSort(sort),
            ),
            SizedBox(height: 16),
            Expanded(
              child: events.isEmpty
                  ? Center(child: Text("No events found", style: AppFonts.body))
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCard(
                          key: ValueKey(event.eventId),
                          event: event,
                          onView: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyEventPage(event: event),
                            ),
                          ),
                          onDeleteUpdateScreen: () => _controller.loadEvents(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _controller.isMyEventsSelected
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventCreationScreen(userId: widget.userId),
                ),
              ).then((_) => _controller.loadEvents()),
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}