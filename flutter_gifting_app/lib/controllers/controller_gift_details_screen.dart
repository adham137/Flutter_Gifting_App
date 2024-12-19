import 'package:flutter/material.dart';

import '../models/gift.dart';
import '../models/user.dart';

class GiftDetailsController {
  final GiftModel _gift;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  String? imagePath;

  GiftDetailsController(this._gift) {
    // Initialize controllers with existing gift details
    nameController = TextEditingController(text: _gift.name);
    descriptionController = TextEditingController(text: _gift.description);
    categoryController = TextEditingController(text: _gift.category);
    priceController = TextEditingController(text: _gift.price.toString());
    imagePath = _gift.imageUrl;
  }

  // Update image path
  void updateImagePath(String path) {
    imagePath = path;
  }

  // Build Gift Status Widget
  Widget buildGiftStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _gift.status == 'Pledged' ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _gift.status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Fetch the user who pledged the gift
  Future<UserModel?> fetchPledgedUser() async {
    if (_gift.pledgedBy != null && _gift.pledgedBy!.isNotEmpty) {
      return await UserModel.getUser(_gift.pledgedBy!);
    }
    return null;
  }

  // Build UI for no pledged user
  Widget buildNoPledgeUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.hourglass_empty, size: 50, color: Colors.teal),
          SizedBox(height: 10),
          Text('No user has pledged for this gift.', textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Save updated gift details
  Future<bool> saveGiftDetails() async {
    // Validate inputs
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        categoryController.text.isEmpty ||
        priceController.text.isEmpty) {
      return false;
    }

    // Update gift object
    _gift
      ..name = nameController.text
      ..description = descriptionController.text
      ..category = categoryController.text
      ..price = double.tryParse(priceController.text) ?? _gift.price
      ..imageUrl = imagePath;

    // Save using model
    await GiftModel.updateGift(_gift.giftId, _gift.toFirestore());
    return true;
  }

}