import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../components/event_card.dart';
import '../components/bottom_nav_bar.dart';
class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  bool isMyEventsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _toggleButton("Friends Events", !isMyEventsSelected),
            SizedBox(width: 8),
            _toggleButton("My Events", isMyEventsSelected),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for events',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By',
                  style: AppFonts.body,
                ),
                DropdownButton<String>(
                  items: ['Category', 'Name', 'Status']
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {},
                  hint: Text('Category'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with dynamic data length
                itemBuilder: (context, index) {
                  return EventCard(
                    name: 'Adham Yasser',
                    title: index == 0 ? 'Grad' : 'My Birthday',
                    location: index == 0
                        ? 'Ain Shams University'
                        : 'McDonalds El-Serag',
                    date: index == 0 ? '15/9/2025' : '13/7/2025',
                    time: index == 0 ? '8:00 PM' : '12:00 AM',
                    status: index == 0 ? 'Current' : 'Upcoming',
                    onDelete: () => {},
                    onEdit: () => {} ,
                    onView: () => {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},                                       //
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),

    );
  }

  Widget _toggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMyEventsSelected = (text == "My Events");
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: isSelected ? AppFonts.button : AppFonts.body,
        ),
      ),
    );
  }
}