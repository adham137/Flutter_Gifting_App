import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/event.dart'; // Ensure the EventModel is imported
import '../utils/user_manager.dart';
import 'image_handler.dart'; // Import UserManager for current user ID

class EventCard extends StatefulWidget {
  final EventModel event; // Pass the EventModel directly
  final VoidCallback onView; // Required callback for "View"
  final VoidCallback onDeleteUpdateScreen; // Callback to update the screen when deleting an event

  EventCard({
    required this.event,
    required this.onView,
    required this.onDeleteUpdateScreen,
    Key? key,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String? _profileImagePath;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize _profileImagePath with the user's current profile picture URL
  //   _profileImagePath = widget.event.profilePictureUrl;
  // }

  Future<void> _handleImageUpdate(String imagePath) async {
    setState(() {
      _profileImagePath = imagePath;
    });
    await UserModel.updateUser(widget.event.userId, {'profile_picture_url': imagePath});
  }

  @override
  Widget build(BuildContext context) {
    final isMine = widget.event.userId == UserManager.currentUserId; // Check if the event belongs to the current user

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
                FutureBuilder<UserModel?>(
                  future: UserModel.getUser(widget.event.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ImageHandler(
                        radius: 20,
                        imagePath: snapshot.data!.profilePictureUrl,
                        defaultImagePath: 'images/default_profile_picture.png',
                        isEditable: false,
                        onImageUpdate: _handleImageUpdate,
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(width: 8),
                Text(widget.event.name, style: AppFonts.body),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: widget.event.status == "Current"
                        ? AppColors.badgeCurrent
                        : AppColors.badgeUpcoming,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.event.status, style: AppFonts.badge),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Event Title
            Text(widget.event.category, style: AppFonts.header),
            SizedBox(height: 4),

            // Location
            if (widget.event.location != null)
              Text(widget.event.location!, style: AppFonts.body),
            SizedBox(height: 4),

            // Date and Time
            Text(
              '${widget.event.date.toDate().toString().split(' ')[0]} - ${widget.event.date.toDate().toString().split(' ')[1]}',
              style: AppFonts.body,
            ),
            SizedBox(height: 12),

            // Action Buttons: Conditionally Rendered
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isMine) ...[
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
                        await EventModel.deleteEvent(widget.event.eventId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Event deleted successfully')),
                        );
                        widget.onDeleteUpdateScreen();
                      }
                    },
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),

                  // Edit Button
                  ElevatedButton(
                    onPressed: () async {
                      final newName = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController(text: widget.event.name);
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
                        await EventModel.updateEvent(widget.event.eventId, {'name': newName});
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

                // View Button (always visible)
                ElevatedButton(
                  onPressed: widget.onView,
                  child: Text('View'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
