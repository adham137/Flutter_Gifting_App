import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime? selectedDate;
  String status = "Upcoming";

  // Validates user input and creates an event if valid.
  Future<String?> validateAndCreateEvent(String userId) async {
    if (nameController.text.isEmpty || categoryController.text.isEmpty || selectedDate == null) {
      return "Please fill all fields";
    }

    // Create the EventModel instance with a Timestamp for the date
    final event = EventModel(
      eventId: EventModel.generateEventId(), // Generate event ID in the model
      userId: userId,
      name: nameController.text,
      category: categoryController.text,
      date: Timestamp.fromDate(selectedDate!), // Convert DateTime to Timestamp
      status: status,
      location: locationController.text,
      createdAt: Timestamp.now(), // Current time as a timestamp
    );

    // Saves event through the model
    await EventModel.createEvent(event);
    return null; // No errors
  }

  // Clears all controllers
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    locationController.dispose();
  }
}
