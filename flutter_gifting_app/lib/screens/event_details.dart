// views/my_event_page.dart

import 'package:flutter/material.dart';
import '../controllers/controller_event_details.dart';
import '../models/event.dart';
import '../components/sort_options.dart';
import '../components/gift_card.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import 'gift_creation_screen.dart';

class MyEventPage extends StatefulWidget {
  final EventModel event;

  const MyEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _MyEventPageState createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  late MyEventController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyEventController(event: widget.event);
    _controller.loadGifts().then((_) {
      setState(() {}); // Refresh UI after loading gifts
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Event Details", style: AppFonts.header),
                  const SizedBox(height: 8),
                  Text("Category: ${widget.event.category}", style: AppFonts.body),
                  Text("Date: ${widget.event.date.toString()}", style: AppFonts.body),
                  Text("Status: ${widget.event.status}", style: AppFonts.body),
                  Text("Location: ${widget.event.location ?? 'Not provided'}", style: AppFonts.body),
                  Text("Created At: ${widget.event.createdAt.toDate().toString()}", style: AppFonts.body),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sort Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SortOptions(
                selectedSort: _controller.selectedSort,
                onSortSelected: (sort) {
                  setState(() {
                    _controller.updateSortOption(sort);
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Gift List Section
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _controller.filteredGifts.length,
              itemBuilder: (context, index) {
                return GiftCard(
                  gift: _controller.filteredGifts[index],
                  callback: () {
                    _controller.loadGifts().then((_) {
                      setState(() {}); // Refresh UI after updating gifts
                    });
                  },
                );
              },
            ),
            if (_controller.filteredGifts.isEmpty)
              const Center(child: Text("No gifts available")),

            // Add Gift Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftCreationScreen(eventId: widget.event.eventId),
                      ),
                    ).then((_) {
                      _controller.loadGifts().then((_) {
                        setState(() {}); // Refresh UI after returning from creation
                      });
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Gift"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


