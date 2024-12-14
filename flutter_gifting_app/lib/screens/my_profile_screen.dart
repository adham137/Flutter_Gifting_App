import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/event_card.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/user.dart';
import '../utils/user_manager.dart';
import '../models/event.dart';
import 'event_details.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel? currentUser;
  bool isLoading = true;
  bool isEditing = false;

  List<EventModel> userEvents = []; // To store the user's events
  bool areEventsLoading = true; // Loading state for events

  @override
  void initState() {
    super.initState();
    fetchUserData();
    loadUserEvents();
  }

  Future<void> fetchUserData() async {
    try {
      final user = await UserModel.getUser(UserManager.currentUserId!);
      setState(() {
        currentUser = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

    Future<void> loadUserEvents() async {
    try {
      final userId = UserManager.currentUserId!;
      final events = await EventModel.getEventsByUser(userId);
      setState(() {
        userEvents = events;
        areEventsLoading = false;
      });
    } catch (e) {
      setState(() {
        areEventsLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $e')),
      );
    }
  }
  void _refreshEvents() {
    loadUserEvents(); // Refresh the events list
  }
  void _updateUserField(String field, dynamic value) async {
    try {
      await UserModel.updateUser(UserManager.currentUserId!, {field: value});
      setState(() {
        if (field == 'name') currentUser!.name = value;
        if (field == 'email') currentUser!.email = value;
        if (field == 'phone_number') currentUser!.phoneNumber = value;
        if (field == 'push_notifications') currentUser!.pushNotifications = value;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : currentUser == null
              ? Center(child: Text('No user data available.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      // Profile Header
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: currentUser!.profilePictureUrl != null
                            ? NetworkImage(currentUser!.profilePictureUrl!)
                            : AssetImage("assets/profile_picture.png") as ImageProvider,
                      ),
                      SizedBox(height: 16),
                      // Editable Fields
                      _buildEditableField(
                        label: 'Name',
                        value: currentUser!.name,
                        isEditable: isEditing,
                        onSave: (value) => _updateUserField('name', value),
                      ),
                      _buildEditableField(
                        label: 'Phone Number',
                        value: currentUser!.phoneNumber,
                        isEditable: isEditing,
                        onSave: (value) => _updateUserField('phone_number', value),
                      ),
                      _buildEditableField(
                        label: 'Email',
                        value: currentUser!.email,
                        isEditable: isEditing,
                        onSave: (value) => _updateUserField('email', value),
                      ),
                      SizedBox(height: 16),


                      // Push Notification Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Push Notifications"),
                          Switch(
                            value: currentUser!.pushNotifications,
                            onChanged: isEditing
                                ? (value) => _updateUserField('push_notifications', value)
                                : null,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Edit Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGrey,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            fixedSize: Size(100, 50),
                          ),
                          child: Text(
                            isEditing ? "Save" : "Edit",
                            style: AppFonts.button,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Gift Lists Placeholder
                                            // Events Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Events List",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      areEventsLoading
                          ? Center(child: CircularProgressIndicator())
                          : userEvents.isEmpty
                              ? Center(
                                  child: Text(
                                    "No events found.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: userEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = userEvents[index];
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
                                      onDeleteUpdateScreen: _refreshEvents,
                                    );
                                  },
                                ),
                      SizedBox(height: 24),
                      // Sign-Out Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () => _signOut(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGrey,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            fixedSize: Size(100, 50),
                          ),
                          child: Text(
                            "Sign Out",
                            style: AppFonts.button,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String? value,
    required bool isEditable,
    required Function(String) onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        initialValue: value,
        readOnly: !isEditable,
        decoration: InputDecoration(labelText: label),
        onFieldSubmitted: isEditable ? onSave : null,
        style: TextStyle(color: isEditable ? Colors.black : Colors.grey),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/sign-in',
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
