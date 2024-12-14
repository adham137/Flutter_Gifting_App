import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/event.dart'; // EventModel for events
import '../models/gift.dart'; // GiftModel for pledged gifts
import '../components/event_card.dart'; // Import EventCard widget
import '../components/gift_card.dart';
import 'event_details.dart'; // Import GiftCard widget

class EventsAndGiftsScreen extends StatefulWidget {
  final String userId; // User ID to fetch events and gifts

  const EventsAndGiftsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EventsAndGiftsScreenState createState() => _EventsAndGiftsScreenState();
}

class _EventsAndGiftsScreenState extends State<EventsAndGiftsScreen> {
  List<EventModel> events = [];
  List<GiftModel> gifts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch and filter data for the provided userId
      final fetchedEvents = await EventModel.getEventsByUser(widget.userId);


      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      // Handle errors (e.g., show a message)
      print('Error fetching data: $e');
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onSortEvents() {
    setState(() {
      events.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  void _onSortGifts() {
    setState(() {
      gifts.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter events and gifts based on search query
    final filteredEvents = events.where((event) {
      return event.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final filteredGifts = gifts.where((gift) {
      return gift.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('''Friends' Events''', style: AppFonts.header),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventGiftSearchDelegate(
                  onSearch: _onSearch,
                  query: searchQuery,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _onSortEvents,
                  child: Text('Sort Events'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onSortGifts,
                  child: Text('Sort Gifts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Display Events
                if (filteredEvents.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Events', style: AppFonts.header),
                  ),
                  ...filteredEvents.map((event) {
                    return EventCard(
                      event: event,
                          onView: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyEventPage(event: event), // Pass the event object here
                            ),
                          );

                          },
                      onDeleteUpdateScreen: _fetchData, // Refresh data
                    );
                  }).toList(),
                ],

              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Search Delegate for Events and Gifts
class EventGiftSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;
  EventGiftSearchDelegate({required this.onSearch, required String query})
      : super(searchFieldLabel: 'Search Events or Gifts', textInputAction: TextInputAction.search) {
    this.query = query;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container(); // Handle results elsewhere
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return Container(); // Handle suggestions elsewhere
  }
}
