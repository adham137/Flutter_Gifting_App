import 'dart:io';
import 'package:flutter/material.dart';

import '../components/image_handler.dart';

import '../models/gift.dart';

import '../controllers/controller_gift_creation_screen.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/user_manager.dart';

class GiftCreationScreen extends StatefulWidget {
  final String eventId;

  const GiftCreationScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _GiftCreationScreenState createState() => _GiftCreationScreenState();
}

class _GiftCreationScreenState extends State<GiftCreationScreen> {
  late GiftCreationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GiftCreationController(
      context: context,
      eventId: widget.eventId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Create Gift', style: AppFonts.header),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageHandler(
                radius: 60,
                imagePath: null,
                defaultImagePath: 'images/default_gift_picture.png',
                isEditable: true,
                onImageUpdate: _controller.handleImageUpdate,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller.giftNameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _controller.selectedCategory,
                items: _controller.categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: _controller.updateCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Text("Price", style: AppFonts.subtitle),
              TextField(
                controller: _controller.priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _controller.createGift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Create Gift', style: AppFonts.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
