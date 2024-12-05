import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/event.dart'; // Ensure the EventModel is imported

class EventCard extends StatelessWidget {
  final EventModel event; // Pass the EventModel directly
  final VoidCallback onView; // Required callback for "View"
  final VoidCallback onDeleteUpdateScreen; // Callback to update the screen when deleting an event

  EventCard({
    required this.event,
    required this.onView,
    required this.onDeleteUpdateScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, and Status Badge
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png'),
                  radius: 20,
                ),
                SizedBox(width: 8),
                Text(event.name, style: AppFonts.body),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: event.status == "Current"
                        ? AppColors.badgeCurrent
                        : AppColors.badgeUpcoming,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(event.status, style: AppFonts.badge),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Event Title
            Text(event.category, style: AppFonts.header),
            SizedBox(height: 4),

            // Location
            if (event.location != null)
              Text(event.location!, style: AppFonts.body),
            SizedBox(height: 4),

            // Date and Time
            Text(
              '${event.date.toDate().toString().split(' ')[0]} - ${event.date.toDate().toString().split(' ')[1]}',
              style: AppFonts.body,
            ),
            SizedBox(height: 12),

            // Action Buttons: Delete, View, Edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delete Button
                ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete this event?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await EventModel.deleteEvent(event.eventId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event deleted successfully')),
                      );
                      this.onDeleteUpdateScreen();  
                    }
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),

                // View Button
                ElevatedButton(
                  onPressed: onView,
                  child: Text('View'),
                ),

                // Edit Button
                ElevatedButton(
                  onPressed: () async {
                    final newName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController(text: event.name);
                        return AlertDialog(
                          title: Text('Edit Event'),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(labelText: 'Event Name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, controller.text),
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );

                    if (newName != null && newName.isNotEmpty) {
                      await EventModel.updateEvent(event.eventId, {'name': newName});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event updated successfully')),
                      );
                    }
                  },
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
