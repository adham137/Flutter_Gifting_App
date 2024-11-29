import 'package:flutter/material.dart';
import '../components/event_card.dart'; // Import EventCard widget

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile_picture.png"), // Replace with actual image
            ),
            SizedBox(height: 16),
            Text(
              "Adham Yasser",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("+01012345678"),
            Text("Adham123@gmail.com"),
            SizedBox(height: 16),
            // Push Notification Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Push Notifications"),
                Switch(
                  value: true, // Set the initial value or state
                  onChanged: (value) {
                    // Handle toggle logic
                  },
                ),
              ],
            ),
            // Edit Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the Edit Profile page
              },
              child: Text("Edit"),
            ),
            SizedBox(height: 24),
            // Gift Lists Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gift Lists",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Use EventCard dynamically
                  EventCard(
                    name: "Adham Yasser",
                    title: "Grad",
                    location: "Ain Shams University",
                    date: "15/9/2025",
                    time: "8:00 PM",
                    status: "Current",
                    onDelete: () {
                      // Handle delete action
                    },
                    onEdit: () {
                      // Handle edit action
                    },
                    onView: () {
                      // Handle view action
                    },
                  ),
                  EventCard(
                    name: "Adham Yasser",
                    title: "My Birthday",
                    location: "McDonald's El-Serag",
                    date: "13/7/2025",
                    time: "12:00 AM",
                    status: "Upcoming",
                    onDelete: () {
                      // Handle delete action
                    },
                    onEdit: () {
                      // Handle edit action
                    },
                    onView: () {
                      // Handle view action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}