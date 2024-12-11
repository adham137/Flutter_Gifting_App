import 'package:flutter/material.dart';
import '../components/gift_card.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../models/event.dart';
import '../models/gift.dart';
import '../components/sort_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEventPage extends StatefulWidget {
  final EventModel event;

  const MyEventPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _MyEventPageState createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  String? selectedSort;
  List<GiftModel> gifts = [];
  List<GiftModel> filteredGifts = [];

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    final fetchedGifts = await GiftModel.getGiftsByEvent(widget.event.eventId);
    setState(() {
      gifts = fetchedGifts;
      _filterAndSortGifts();
    });
  }

  void _filterAndSortGifts() {
    setState(() {
      filteredGifts = List.from(gifts);
      if (selectedSort != null) {
        filteredGifts.sort((a, b) {
          switch (selectedSort) {
            case "Category":
              return a.category.compareTo(b.category);
            case "Name":
              return a.name.compareTo(b.name);
            case "Status":
              return a.status.compareTo(b.status);
            default:
              return 0;
          }
        });
      }
    });
  }

  void _showAddGiftDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            "Add Gift",
            style: AppFonts.header,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Gift Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: AppColors.secondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                      
                  final newGift = GiftModel(
                    giftId: FirebaseFirestore.instance.collection('gifts').doc().id,
                    eventId: widget.event.eventId,
                    name: nameController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    status: 'Available',
                  );
                  await GiftModel.createGift(newGift);
                  await _loadGifts(); // Refresh the gift list
                  Navigator.pop(context);
                }
              },
              child: Text("Add Gift"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Event Details", style: AppFonts.header),
                  const SizedBox(height: 8),
                  Text("Category: ${widget.event.category}", style: AppFonts.body),
                  Text("Date: ${widget.event.date.toDate().toString()}", style: AppFonts.body),
                  Text("Status: ${widget.event.status}", style: AppFonts.body),
                  Text("Location: ${widget.event.location ?? 'Not provided'}", style: AppFonts.body),
                  Text("Created At: ${widget.event.createdAt.toDate().toString()}", style: AppFonts.body),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gift List", style: AppFonts.header),
                  const SizedBox(height: 16),
                  SortOptions(
                    selectedSort: selectedSort,
                    onSortSelected: (sort) {
                      setState(() {
                        selectedSort = sort;
                        _filterAndSortGifts();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            FutureBuilder<List<GiftModel>>(
              future: GiftModel.getGiftsByEvent(widget.event.eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No gifts available"));
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredGifts.length,
                  itemBuilder: (context, index) {
                    final gift = filteredGifts[index];
                    return GiftCard(
                      recipientName: gift.pledgedBy ?? 'Unknown',
                      recipientImage: gift.imageUrl ?? 'assets/images/default_avatar.png',
                      location: gift.description,
                      date: widget.event.date.toDate().toString(),
                      time: widget.event.date.toDate().toString(),
                      giftName: gift.name,
                      category: gift.category,
                      status: gift.status,
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: _showAddGiftDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Gift"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
