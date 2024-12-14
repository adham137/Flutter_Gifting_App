import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/event.dart';
import '../screens/friend_screen.dart'; // Import the target screen

class FriendCard extends StatelessWidget {
  final UserModel user;
  String get name => user.name;

  FriendCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to EventsAndGiftsScreen with the userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventsAndGiftsScreen(userId: user.userId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
        leading:CircleAvatar(
            radius: 50,
            backgroundImage: user!.profilePictureUrl != null
                ? FileImage(File(user!.profilePictureUrl!))
                : AssetImage("images/default_profile_picture.png") as ImageProvider,
          ),
          title: Text(name),
          subtitle: Text('Upcoming Events'),
          trailing: FutureBuilder<int>(
            future: EventModel.getEventsCountByUser(user.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${snapshot.data}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
