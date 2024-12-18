import 'package:flutter/material.dart';
import '../components/event_card.dart';
import '../components/image_handler.dart';
import '../components/editable_text_field.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../controllers/controller_my_profile_screen.dart';
import 'event_details.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfilePageController controller;
  UserModel? currentUser;
  bool isLoading = true;
  List<EventModel> userEvents = [];
  bool areEventsLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = ProfilePageController(context);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = await controller.fetchUserData();
    final events = await controller.loadUserEvents();

    setState(() {
      currentUser = user;
      userEvents = events;
      isLoading = false;
      areEventsLoading = false;
    });
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
                      ImageHandler(
                        radius: 50,
                        imagePath: currentUser!.profilePictureUrl,
                        defaultImagePath: 'images/default_profile_picture.png',
                        isEditable: true,
                        onImageUpdate: (imagePath) async {
                          await controller.updateProfileImage(imagePath);
                          await _reloadUserData();
                        },
                      ),
                      SizedBox(height: 16),
                      // Editable Fields
                      EditableTextField(
                        label: 'Name',
                        initialValue: currentUser!.name,
                        onSave: (value) async {
                          await controller.updateUserField('name', value);
                          await _reloadUserData();
                        },
                      ),
                      EditableTextField(
                        label: 'Email',
                        initialValue: currentUser!.email,
                        onSave: (value) async {
                          await controller.updateUserField('email', value);
                          await _reloadUserData();
                        },
                      ),
                      EditableTextField(
                        label: 'Phone Number',
                        initialValue: currentUser!.phoneNumber!,
                        onSave: (newValue) async {
                          await controller.updateUserField('phone_number', newValue);
                          await _reloadUserData();
                        },
                      ),
                      SizedBox(height: 16),
                      // Push Notifications Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Push Notifications"),
                          Switch(
                            value: currentUser!.pushNotifications,
                            onChanged: (value) async {
                              await controller.updateUserField('push_notifications', value);
                              await _reloadUserData();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
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
                              ? Center(child: Text("No events found."))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: userEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = userEvents[index];
                                    return EventCard(
                                      event: event,
                                      onView: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyEventPage(event: event),
                                        ),
                                      ),
                                      onDeleteUpdateScreen: _initializeData,
                                    );
                                  },
                                ),
                      SizedBox(height: 24),
                      // Sign-Out Button
                      ElevatedButton(
                        onPressed: () => controller.signOut(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGrey,
                        ),
                        child: Text("Sign Out", style: AppFonts.button),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }


  Future<void> _reloadUserData() async {
    final updatedUser = await controller.fetchUserData();
    setState(() {
      currentUser = updatedUser;
    });
  }
}
