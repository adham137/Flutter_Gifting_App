import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../models/event.dart';
import '../utils/local_database_controller.dart';
import '../utils/user_manager.dart';
import 'package:flutter/material.dart';

class ProfilePageController {
  late final BuildContext context;

  ProfilePageController(this.context);

  late UserModel? currentUser;
  bool isEditing = false;

  List<EventModel> userEvents = [];
  bool areEventsLoading = true;

  Future<UserModel?> fetchUserData() async {
    try {
      currentUser = await UserModel.getUser(UserManager.currentUserId!);
      return currentUser;
    } catch (e) {
      _showSnackBar('Failed to load user data: $e');
      return null;
    }
  }

  Future<List<EventModel>> loadUserEvents() async {
    try {
      final userId = UserManager.currentUserId!;
      userEvents = await EventModel.getEventsByUser(userId);
      areEventsLoading = false;
      return userEvents;
    } catch (e) {
      areEventsLoading = false;
      _showSnackBar('Failed to load events: $e');
      return [];
    }
  }

  Future<void> updateUserField(String field, dynamic value) async {
    try {
      print('Updating $field with value: $value');
      await UserModel.updateUser(UserManager.currentUserId!, {field: value});
    } catch (e) {
      _showSnackBar('Failed to update $field: $e');
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      await UserModel.updateUser(UserManager.currentUserId!, {'profile_picture_url': imagePath});
    } catch (e) {
      _showSnackBar('Failed to update profile picture.');
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await DatabaseController.uploadLocalDataToFirestore();                  // Uplaod data from local to firestore
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
    } catch (e) {
      _showSnackBar('Error signing out: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
