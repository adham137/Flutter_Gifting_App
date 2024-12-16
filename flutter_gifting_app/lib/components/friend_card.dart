import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/event.dart';
import '../screens/friend_screen.dart';
import 'image_handler.dart'; // Import the target screen

class FriendCard extends StatefulWidget {
  final UserModel user;

  const FriendCard({Key? key, required this.user}) : super(key: key);

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    // Initialize _profileImagePath with the user's current profile picture URL
    _profileImagePath = widget.user.profilePictureUrl;
  }

  Future<void> _handleImageUpdate(String imagePath) async {
    setState(() {
      _profileImagePath = imagePath;
    });
    await UserModel.updateUser(widget.user.userId, {'profile_picture_url': imagePath});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to EventsAndGiftsScreen with the userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventsAndGiftsScreen(userId: widget.user.userId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: FutureBuilder<UserModel?>(
            future: UserModel.getUser(widget.user.userId),
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
          title: Text(widget.user.name),
          subtitle: Text('Upcoming Events'),
          trailing: FutureBuilder<int>(
            future: EventModel.getEventsCountByUser(widget.user.userId),
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
