import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class EventCard extends StatelessWidget {
  final String name, title, location, date, time, status;
  final VoidCallback? onDelete, onEdit;
  final VoidCallback onView;
  final String? avatarPath; // Optional for a dynamic avatar

  EventCard({
    required this.name,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.status,
    this.onDelete,
    this.onEdit,
    required this.onView,
    this.avatarPath, // Optional parameter for avatar
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: avatarPath != null
                      ? AssetImage(avatarPath!)
                      : AssetImage('assets/avatar.png'),
                  radius: 20,
                ),
                SizedBox(width: 8),
                Text(name, style: AppFonts.body),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: status == "Current"
                        ? AppColors.badgeCurrent
                        : AppColors.badgeUpcoming,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(status, style: AppFonts.badge),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(title, style: AppFonts.header),
            SizedBox(height: 4),
            Text(location, style: AppFonts.body),
            SizedBox(height: 4),
            Text('$date - $time', style: AppFonts.body),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                this.onDelete != null ? ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ) : Container(),

                ElevatedButton(
                  onPressed: onView,
                  child: Text('View'),
                ),

                this.onEdit != null ? ElevatedButton(
                  onPressed: onEdit,
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ) 
                ): Container(),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
