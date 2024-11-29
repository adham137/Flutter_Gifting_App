import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import 'action_button.dart';

class GiftCard extends StatelessWidget {
  final String recipientName;
  final String recipientImage;
  final String location;
  final String date;
  final String time;
  final String giftName;
  final String category;
  final String status;

  const GiftCard({
    required this.recipientName,
    required this.recipientImage,
    required this.location,
    required this.date,
    required this.time,
    required this.giftName,
    required this.category,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(recipientImage),
                  radius: 24,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("To $recipientName", style: AppFonts.subtitle),
                    Text(
                      "$location\n$date - $time",
                      style: AppFonts.body,
                    ),
                  ],
                ),
                Spacer(),
                StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 10),

            // Gift Details Section
            Row(
              children: [
                Icon(Icons.card_giftcard, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "$giftName - $category",
                  style: AppFonts.body,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Action Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  label: "Edit",
                  color: Colors.blue,
                  onPressed: () {
                    // Add Edit Logic Here
                  },
                ),
                ActionButton(
                  label: "Delete",
                  color: Colors.red,
                  onPressed: () {
                    // Add Delete Logic Here
                  },
                ),
                ActionButton(
                  label: status == "Available" ? "Pledge" : "Unpledge",
                  color: status == "Available" ? Colors.green : Colors.orange,
                  onPressed: () {
                    // Add Pledge/Unpledge Logic Here
                    if (status == "Available") {
                      // Logic to pledge the gift
                    } else {
                      // Logic to unpledge the gift
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.statusColors[status] ?? Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppFonts.badge,
      ),
    );
  }
}
