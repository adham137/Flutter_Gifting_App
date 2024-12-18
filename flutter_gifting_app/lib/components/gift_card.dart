import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/gift_details_screen.dart';
import '../utils/user_manager.dart';
import 'action_button.dart';
import '../models/gift.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class GiftCard extends StatelessWidget {
  final GiftModel gift;
  final VoidCallback callback;
  late String userId = gift.creatorId;

  GiftCard({
    required this.gift,
    required this.callback,
  }) : userId = gift.creatorId;

  void _onViewPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftDetailsView(
          gift: gift,
          isEditable: false, // View mode
        ),
      ),
    );//.then((_) => callback());
  }
  void _onEditPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftDetailsView(
          gift: gift,
          isEditable: true, // Edit mode
        ),
      ),
    );//.then((_) => callback());
  }
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Gift"),
          content: Text("Are you sure you want to delete this gift?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: AppColors.secondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await GiftModel.deleteGift(gift.giftId);
                callback();
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMyEvent = (userId == UserManager.currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gift Header
                Row(
                  children: [
                    Icon(Icons.card_giftcard, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(gift.name, style: AppFonts.subtitle),
                  ],
                ),
                const SizedBox(height: 8),
                Text(gift.description, style: AppFonts.body),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: isMyEvent
                      ? [
                          ActionButton(
                            label: "Delete",
                            color: Colors.red,
                            onPressed: () => _confirmDelete(context),
                          ),
                          ActionButton(
                            label: "Edit",
                            color: Colors.blue,
                            onPressed: () => _onEditPressed(context),
                          ),
                          ActionButton(
                            label: "View",
                            color: Colors.grey,
                            onPressed: () => _onViewPressed(context),
                          ),
                        ]
                      : [
                          ActionButton(
                            label: gift.status == 'Pledged' ? "Unpledge" : "Pledge",
                            color: gift.status == 'Pledged' ? Colors.green : Colors.yellow,
                            onPressed: () async {
                              if (gift.status == 'Pledged') {
                                await gift.unpledgeGift();
                              } else {
                                await gift.pledgeGift();
                              }
                              callback();
                            },
                          ),
                          ActionButton(
                            label: "View",
                            color: Colors.grey,
                            onPressed: () => _onViewPressed(context),
                          ),
                        ],
                ),
              ],
            ),
          ),
          // Status Badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: gift.status == 'Pledged' ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                gift.status,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
