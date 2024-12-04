import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../components/gift_card.dart';
import '../components/search_bar.dart';
import '../components/sort_options.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final TextEditingController searchController = TextEditingController();
  String? selectedSort;
  List<Map<String, dynamic>> gifts = []; // Dummy data list
  List<Map<String, dynamic>> filteredGifts = []; // Filtered list

  @override
  void initState() {
    super.initState();
    _loadDummyData(); // Initialize dummy data
    _filterAndSortGifts(); // Initialize filtered list
    searchController.addListener(_filterAndSortGifts);
  }

  void _loadDummyData() {
    gifts = [
      {
        "recipientName": "Ahmed",
        "recipientImage": "assets/images/profile_placeholder.png",
        "location": "Cairo, Egypt",
        "date": "24 / 10 / 2024",
        "time": "8:00 PM",
        "giftName": "iPhone 16",
        "category": "Appliances",
        "status": "Pending",
      },
      {
        "recipientName": "Sara",
        "recipientImage": "assets/images/profile_placeholder.png",
        "location": "Alexandria, Egypt",
        "date": "15 / 09 / 2024",
        "time": "5:00 PM",
        "giftName": "MacBook Air",
        "category": "Electronics",
        "status": "Delivered",
      },
      {
        "recipientName": "Omar",
        "recipientImage": "assets/images/profile_placeholder.png",
        "location": "Giza, Egypt",
        "date": "12 / 11 / 2024",
        "time": "6:00 PM",
        "giftName": "PlayStation 5",
        "category": "Gaming",
        "status": "Pending",
      },
    ];
    filteredGifts = List.from(gifts);
  }

  void _filterAndSortGifts() {
    final query = searchController.text.toLowerCase();

    setState(() {
      // Filter gifts based on search query
      filteredGifts = gifts.where((gift) {
        final name = gift["recipientName"].toLowerCase();
        final giftName = gift["giftName"].toLowerCase();
        return name.contains(query) || giftName.contains(query);
      }).toList();

      // Sort gifts based on selected sort option
      if (selectedSort != null) {
        filteredGifts.sort((a, b) {
          switch (selectedSort) {
            case "Category":
              return a["category"].compareTo(b["category"]);
            case "Name":
              return a["recipientName"].compareTo(b["recipientName"]);
            case "Status":
              return a["status"].compareTo(b["status"]);
            default:
              return 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "My Pledged Gifts",
          style: AppFonts.header,
        ),
      ),
      body: Column(
        children: [
          MySearchBar(controller: searchController), // Updated reusable SearchBar
          const SizedBox(height: 10),
          SortOptions(
            selectedSort: selectedSort,
            onSortSelected: (sort) {
              setState(() {
                selectedSort = sort;
                _filterAndSortGifts();
              });
            },
          ), // Updated reusable SortOptions
          const SizedBox(height: 10),
          Expanded(
            child: filteredGifts.isEmpty
                ? Center(child: Text("No gifts found"))
                : ListView.builder(
                    itemCount: filteredGifts.length,
                    itemBuilder: (context, index) {
                      final gift = filteredGifts[index];
                      return GiftCard(
                        recipientName: gift["recipientName"],
                        recipientImage: gift["recipientImage"],
                        location: gift["location"],
                        date: gift["date"],
                        time: gift["time"],
                        giftName: gift["giftName"],
                        category: gift["category"],
                        status: gift["status"],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
