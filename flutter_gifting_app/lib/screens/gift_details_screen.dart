import 'package:flutter/material.dart';

import '../controllers/controller_gift_details_screen.dart';

import '../models/gift.dart';
import '../models/user.dart';

import '../utils/colors.dart';

import '../components/image_handler.dart';
import '../components/friend_card.dart';

class GiftDetailsView extends StatefulWidget {
  final GiftModel gift;
  final bool isEditable;

  const GiftDetailsView({
    Key? key,
    required this.gift,
    this.isEditable = false,
  }) : super(key: key);

  @override
  _GiftDetailsViewState createState() => _GiftDetailsViewState();
}

class _GiftDetailsViewState extends State<GiftDetailsView> {
  late GiftDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GiftDetailsController(widget.gift);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isEditable ? Colors.black : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditable ? 'Edit Gift' : 'Gift Details'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image and Status Section
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageHandler(
                      radius: 50,
                      imagePath: _controller.imagePath,
                      isEditable: widget.isEditable,
                      defaultImagePath: 'images/default_gift_picture.png',
                      onImageUpdate: (path) => setState(() => _controller.updateImagePath(path)),
                    ),
                    const SizedBox(height: 16),
                    _controller.buildGiftStatus(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Editable Fields
              _buildTextField(
                controller: _controller.nameController,
                label: 'Gift Name',
                textColor: textColor,
                isEditable: widget.isEditable,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _controller.descriptionController,
                label: 'Description',
                textColor: textColor,
                isEditable: widget.isEditable,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _controller.categoryController,
                label: 'Category',
                textColor: textColor,
                isEditable: widget.isEditable,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _controller.priceController,
                label: 'Price',
                textColor: textColor,
                isEditable: widget.isEditable,
                isNumeric: true,
              ),

              const SizedBox(height: 16),

              // FutureBuilder for Pledged User
              FutureBuilder<UserModel?>(
                future: _controller.fetchPledgedUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return _controller.buildNoPledgeUI();
                  } else {
                    return FriendCard(user: snapshot.data!);
                  }
                },
              ),

              const SizedBox(height: 24),

              // Save Button (Editable Mode)
              if (widget.isEditable)
                ElevatedButton(
                  onPressed: () async {
                    final result = await _controller.saveGiftDetails();
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gift details updated successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Gift'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required bool isEditable,
    bool isNumeric = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      readOnly: !isEditable,
      style: TextStyle(color: textColor),
    );
  }
}