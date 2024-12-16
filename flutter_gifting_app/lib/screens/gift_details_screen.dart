import 'package:flutter/material.dart';
import '../models/gift.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../components/image_handler.dart';
import '../components/friend_card.dart';

class GiftDetailsScreen extends StatefulWidget {
  final GiftModel gift;
  final bool isEditable;

  const GiftDetailsScreen({
    Key? key,
    required this.gift,
    this.isEditable = false,
  }) : super(key: key);

  @override
  _GiftDetailsScreenState createState() => _GiftDetailsScreenState();
}

class _GiftDetailsScreenState extends State<GiftDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gift.name);
    _descriptionController = TextEditingController(text: widget.gift.description);
    _categoryController = TextEditingController(text: widget.gift.category);
    _priceController = TextEditingController(text: widget.gift.price.toString());
    _imagePath = widget.gift.imageUrl;
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageHandler(
                      radius: 50,
                      imagePath: _imagePath,
                      isEditable: widget.isEditable,
                      defaultImagePath: 'images/default_gift_picture.png',
                      onImageUpdate: (path) => setState(() => _imagePath = path),
                    ),

                    const SizedBox(height: 16),

                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.gift.status == 'Pledged' ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.gift.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                ),
                readOnly: !widget.isEditable,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                readOnly: !widget.isEditable,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                readOnly: !widget.isEditable,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                readOnly: !widget.isEditable,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

                            FutureBuilder<UserModel?>(
                future: UserModel.getUser(widget.gift.pledgedBy ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
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
                  } else {
                    return FriendCard(user: snapshot.data!);
                  }
                },
              ),

              const SizedBox(height: 24),

              if (widget.isEditable)
                ElevatedButton(
                  onPressed: () async {
                    widget.gift
                      ..name = _nameController.text
                      ..description = _descriptionController.text
                      ..category = _categoryController.text
                      ..price = double.tryParse(_priceController.text) ?? widget.gift.price
                      ..imageUrl = _imagePath;

                    await GiftModel.updateGift(widget.gift.giftId, widget.gift.toFirestore());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift details updated successfully!')),
                    );
                    Navigator.pop(context);
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
}
