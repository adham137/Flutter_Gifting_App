import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/event.dart';

class FriendCard extends StatelessWidget {
  final UserModel user;
  String get name => user.name;

  FriendCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/avatar.png'), // Replace with real image
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
    );
  }
}