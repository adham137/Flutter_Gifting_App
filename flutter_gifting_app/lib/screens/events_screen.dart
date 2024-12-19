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
      _controller.toggleEventView(text == "My\nEvents");
    },
    child: AnimatedContainer(
      duration: Duration(milliseconds: 600), // Animation duration
      curve: Curves.easeInOut, // Smooth transition curve
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.purple : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: text == "Friends\nEvents" ? Radius.circular(20) : Radius.circular(0),
          bottomLeft: text == "Friends\nEvents" ? Radius.circular(20) : Radius.circular(0),
          topRight: text == "My\nEvents" ? Radius.circular(20) : Radius.circular(0),
          bottomRight: text == "My\nEvents" ? Radius.circular(20) : Radius.circular(0),
        ),
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 600), // Smooth text transition
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          child: Text(text),
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    final events = _controller.filteredEvents;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _toggleButton("Friends\nEvents", !_controller.isMyEventsSelected),
                  SizedBox(width: 8),
                  _toggleButton("My\nEvents", _controller.isMyEventsSelected),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.babyBlue,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 5,
                color: Colors.black12,
              ),
            ],
          ),
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
      ),
      floatingActionButton: _controller.isMyEventsSelected
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventCreationScreen(userId: widget.userId),
                ),
              ).then((_) => _controller.loadEvents()),
              backgroundColor: AppColors.purple,
              child: Icon(Icons.add , color: AppColors.yellow,),
            )
          : null,
    );
  }
}