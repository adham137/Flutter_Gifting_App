import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/user_manager.dart';
import 'action_button.dart';
import '../models/gift.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class GiftCard extends StatelessWidget {
  final GiftModel gift;
  final VoidCallback onGiftUpdated;
  final VoidCallback onGiftDeleted;
  late String userId = gift.creatorId;

  GiftCard({
    required this.gift,
    required this.onGiftUpdated,
    required this.onGiftDeleted,
  }) : userId = gift.creatorId;

  void _showGiftDetails(BuildContext context, {bool isEditing = false}) {
    final TextEditingController nameController = TextEditingController(text: gift.name);
    final TextEditingController descriptionController = TextEditingController(text: gift.description);
    final TextEditingController categoryController = TextEditingController(text: gift.category);
    final TextEditingController priceController = TextEditingController(text: gift.price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEditing ? "Edit Gift Details" : "Gift Details", style: AppFonts.header),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                enabled: isEditing,
                decoration: InputDecoration(labelText: "Gift Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                enabled: isEditing,
                decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                enabled: isEditing,
                decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                enabled: isEditing,
                decoration: InputDecoration(labelText: "Price", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              if (isEditing)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    final updatedGift = GiftModel(
                      giftId: gift.giftId,
                      creatorId: gift.creatorId,
                      eventId: gift.eventId,
                      name: nameController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      price: double.parse(priceController.text),
                      status: gift.status,
                      pledgedBy: gift.pledgedBy,
                      imageUrl: gift.imageUrl,
                      
                    );
                    await GiftModel.updateGift(gift.giftId, updatedGift.toFirestore());
                    onGiftUpdated();
                    Navigator.pop(context);
                  },
                  child: Text("Save Changes"),
                ),
            ],
          ),
        );
      },
    );
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
                onGiftDeleted();
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
                            onPressed: () => _showGiftDetails(context, isEditing: true),
                          ),
                          ActionButton(
                            label: "View",
                            color: Colors.grey,
                            onPressed: () => _showGiftDetails(context),
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
                              onGiftUpdated();
                            },
                          ),
                          ActionButton(
                            label: "View",
                            color: Colors.grey,
                            onPressed: () => _showGiftDetails(context, isEditing: false),
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
