import 'package:flutter/material.dart';
import '../components/gift_card.dart'; // Updated GiftCard
import '../utils/colors.dart';
import '../utils/fonts.dart';

class MyEventPage extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventDescription;

  const MyEventPage({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example Gift List Data (Can later be replaced with dynamic data)
    final List<Map<String, String>> giftList = [
      {
        "recipientName": "Adham Yasser",
        "recipientImage": "assets/images/avatar1.png",
        "location": "Faculty of Engineering, Ain Shams University",
        "date": eventDate,
        "time": eventTime,
        "giftName": "iPhone 16",
        "category": "Appliances",
        "status": "Available",
      },
      {
        "recipientName": "Adham Yasser",
        "recipientImage": "assets/images/avatar1.png",
        "location": "Faculty of Engineering, Ain Shams University",
        "date": eventDate,
        "time": eventTime,
        "giftName": "iPhone 15",
        "category": "Appliances",
        "status": "Pledged",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Event", style: AppFonts.header),
                  const SizedBox(height: 8),
                  Text(eventDescription, style: AppFonts.body),
                  const SizedBox(height: 16),
                  Text("Location", style: AppFonts.header),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/map_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Gift List Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gift List", style: AppFonts.header),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sort By:",
                        style: AppFonts.body,
                      ),
                      DropdownButton<String>(
                        items: ["Category", "Name", "Status"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: AppFonts.body),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // Sorting logic here
                        },
                        hint: Text("Category", style: AppFonts.body),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Render Gift Cards
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: giftList.length,
              itemBuilder: (context, index) {
                final gift = giftList[index];
                return GiftCard(
                  recipientName: gift["recipientName"]!,
                  recipientImage: gift["recipientImage"]!,
                  location: gift["location"]!,
                  date: gift["date"]!,
                  time: gift["time"]!,
                  giftName: gift["giftName"]!,
                  category: gift["category"]!,
                  status: gift["status"]!,
                );
              },
            ),

            // Add Gift Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logic to add a gift
                    showDialog(
                      context: context,
                      builder: (context) => AddGiftDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Gift"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddGiftDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String giftName = "";
    String category = "";

    return AlertDialog(
      title: const Text("Add Gift"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => giftName = value,
            decoration: const InputDecoration(labelText: "Gift Name"),
          ),
          TextField(
            onChanged: (value) => category = value,
            decoration: const InputDecoration(labelText: "Category"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Logic to save gift
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
