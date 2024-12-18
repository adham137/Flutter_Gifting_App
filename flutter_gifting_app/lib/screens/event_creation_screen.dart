import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../controllers/controller_event_creation_screen.dart';
import '../utils/fonts.dart';
class EventCreationScreen extends StatefulWidget {
  final String userId;

  EventCreationScreen({required this.userId});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final EventController _controller = EventController();

  @override
  void dispose() {
    _controller.dispose(); // Dispose controllers in the controller class
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Create Event', style: AppFonts.header),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name Input
            Text("Event Name", style: AppFonts.subtitle),
            TextField(
              controller: _controller.nameController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Category Input
            Text("Category", style: AppFonts.subtitle),
            TextField(
              controller: _controller.categoryController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Location Input
            Text("Location", style: AppFonts.subtitle),
            TextField(
              controller: _controller.locationController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Date Picker
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _controller.selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                _controller.selectedDate == null
                    ? "Select Date"
                    : "Selected Date: ${_controller.selectedDate!.toLocal()}",
                style: AppFonts.button,
              ),
            ),
            Spacer(),

            // Create Event Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                final error = await _controller.validateAndCreateEvent(widget.userId);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                } else {
                  Navigator.pop(context); // Navigate back on successful creation
                }
              },
              child: Text("Create Event", style: AppFonts.button),
            ),
          ],
        ),
      ),
    );
  }
}
