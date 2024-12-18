import 'dart:io';
import 'package:flutter/material.dart';

import '../models/gift.dart';

import '../utils/user_manager.dart';

class GiftCreationController {
  final BuildContext context;
  final String eventId;
  final TextEditingController giftNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? selectedCategory;
  String? giftImagePath;

  final List<String> categories = [
    'Electronics',
    'Fashion',
    'Books',
    'Home Decor',
    'Toys',
  ];

  GiftCreationController({required this.context, required this.eventId});

  // Handles image updates
  void handleImageUpdate(String imagePath) {
    giftImagePath = imagePath;
  }

  // Updates the selected category
  void updateCategory(String? category) {
    selectedCategory = category;
  }

  // Validates inputs and creates a gift
  Future<void> createGift() async {
    try {
      // Validate inputs
      if (giftNameController.text.trim().isEmpty ||
          descriptionController.text.trim().isEmpty ||
          priceController.text.trim().isEmpty ||
          selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields.')),
        );
        return;
      }

      final price = double.tryParse(priceController.text.trim());
      if (price == null || price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid price.')),
        );
        return;
      }

      // Create GiftModel object
      final newGift = GiftModel(
        giftId: GiftModel.generateGiftId(),
        eventId: eventId,
        creatorId: UserManager.currentUserId!,
        name: giftNameController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory!,
        price: price,
        status: 'Available',
        imageUrl: giftImagePath ?? '',
      );

      // Save gift using the model
      await GiftModel.createGift(newGift);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift created successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}