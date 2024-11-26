import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/friend_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Hediety',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'فن اختيار الهدايا',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(                // Create event button not functional
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text('Add Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Friends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for friends',         // Search not functional yet
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,                           // Replace with dynamic length
                itemBuilder: (context, index) {         //
                  return FriendCard(                    //
                    name: 'Adham Yasser Ahmed',         //
                    eventCount: index + 1,              //
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(       // Add friend button (needs work)
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: Icon(Icons.person_add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}