import 'package:flutter/material.dart';
class FriendCard extends StatelessWidget {
  final String name;
  final int eventCount;

  FriendCard({required this.name, required this.eventCount});

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
        trailing: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            '$eventCount',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}