import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../components/event_card.dart';
import 'my_event.dart';
class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
            // Search Bar
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
            // Sort By Options
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
                  onChanged: (value) {
                    // Handle sorting logic
                  },
                  hint: Text('Category'),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Event List
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with dynamic friend data length
                itemBuilder: (context, index) {
                  if (isMyEventsSelected) {
                    // My Events Data
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
                      onEdit: () => {},
                      onView: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MyEventPage(eventName: "Birthday",eventDate: "13/7/2025",eventTime: "12:30", eventLocation: "Nasr City",eventDescription: "eidmilady el 23",)))},//Navigator.push(context, MaterialPageRoute(builder: (context) => MyEventPage()))
                    );
                  } else {
                    // Friends Events Data
                    return EventCard(
                      name: index == 0 ? 'Ahmed' : 'Mohamed', // Friend's name
                      title: index == 0 ? 'Birthday' : 'Promotion',
                      location: index == 0 ? 'Cairo, Egypt' : 'New Giza, Egypt',
                      date: index == 0 ? '24/10/2024' : '13/7/2025',
                      time: index == 0 ? '8:00 PM' : '12:00 AM',
                      status: index == 0 ? 'Current' : 'Upcoming',
                      onDelete: null, // No delete button
                      onEdit: null, // No edit button
                      
                      onView: () {
                        // Handle "View" action
                        
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isMyEventsSelected
          ? FloatingActionButton(
              onPressed: () {
                                    // Handle Add Event action
              },
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add),
            )
          : null, 
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
