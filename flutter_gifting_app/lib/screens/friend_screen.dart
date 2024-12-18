import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../models/event.dart';
import '../models/gift.dart';

import '../controllers/controller_friend_screen.dart';

import '../components/event_card.dart';
import '../components/gift_card.dart';

import 'event_details.dart';

class EventsAndGiftsScreen extends StatefulWidget {
  final String userId;

  const EventsAndGiftsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EventsAndGiftsScreenState createState() => _EventsAndGiftsScreenState();
}

class _EventsAndGiftsScreenState extends State<EventsAndGiftsScreen> {
  final EventsAndGiftsController _controller = EventsAndGiftsController();
  List<EventModel> events = [];
  List<GiftModel> gifts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetchedEvents = await _controller.fetchEvents(widget.userId);
    final fetchedGifts = await _controller.fetchGifts(widget.userId);
    setState(() {
      events = fetchedEvents;
      gifts = fetchedGifts;
    });
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onSortEvents() {
    setState(() {
      events = _controller.sortEventsByDate(events);
    });
  }

  void _onSortGifts() {
    setState(() {
      gifts = _controller.sortGiftsByName(gifts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _controller.filterEvents(events, searchQuery);
    final filteredGifts = _controller.filterGifts(gifts, searchQuery);

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
                            builder: (context) => MyEventPage(event: event),
                          ),
                        );
                      },
                      onDeleteUpdateScreen: _loadData,
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return Container();
  }
}