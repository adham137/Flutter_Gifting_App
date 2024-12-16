import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/image_handler.dart';
import '../models/gift.dart';
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
  final TextEditingController _giftNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController priceController = TextEditingController();

  String? _selectedCategory;
  File? _giftImage;
  String? _giftImagePath;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Books',
    'Home Decor',
    'Toys',
  ];

  Future<void> _handleImageUpdate(String imagePath) async {
    setState(() {
      _giftImagePath = imagePath;
    });
  }

  Future<void> _createGift() async {
    try {
      if (_giftNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields.')),
        );
        return;
      }

      // await _firestore.collection('gifts').add({
      //   'name': _giftNameController.text.trim(),
      //   'description': _descriptionController.text.trim(),
      //   'category': _selectedCategory,
      //   'imagePath': _giftImagePath ?? '',
      //   'createdAt': Timestamp.now(),
      // });
          final newGift = GiftModel(
      giftId: FirebaseFirestore.instance.collection('gifts').doc().id,
      eventId: widget.eventId,
      creatorId: UserManager.currentUserId!,
      name: _giftNameController.text,
      description: _descriptionController.text,
      category: _selectedCategory!,
      price: double.tryParse(priceController.text) ?? 0.0,
      status: 'Available',
      imageUrl: _giftImagePath ?? '',
    );

      await GiftModel.createGift(newGift);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift created successfully!')),
      );
      Navigator.pop(context); // Redirect to the previous screen.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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
                onImageUpdate: _handleImageUpdate,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _giftNameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value;
                }),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
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
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createGift,
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
