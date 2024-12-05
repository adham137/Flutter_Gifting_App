import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class EventCreationScreen extends StatefulWidget {
  @override
  final String userId;

  EventCreationScreen({required this.userId});

  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  
  DateTime? selectedDate;
  String status = "Upcoming";

  Future<void> _createEvent() async {
    if (nameController.text.isEmpty || categoryController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final event = EventModel(
      eventId: FirebaseFirestore.instance.collection('events').doc().id,
      userId: widget.userId, 
      name: nameController.text,
      category: categoryController.text,
      date: Timestamp.fromDate(selectedDate!),
      status: status,
      location: locationController.text,
      createdAt: Timestamp.now(),
    );

    await EventModel.createEvent(event);
    Navigator.pop(context);
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
            Text("Event Name", style: AppFonts.subtitle),
            TextField(
              controller: nameController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Text("Category", style: AppFonts.subtitle),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Text("Location", style: AppFonts.subtitle),
            TextField(
              controller: locationController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
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
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                selectedDate == null
                    ? "Select Date"
                    : "Selected Date: ${selectedDate!.toLocal()}",
                style: AppFonts.button,
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _createEvent,
              child: Text("Create Event", style: AppFonts.button),
            ),
          ],
        ),
      ),
    );
  }

}
