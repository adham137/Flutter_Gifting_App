import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../components/bottom_nav_bar.dart';
import '../components/gift_card.dart ';
import '../components/search_bar.dart';
import '../components/sort_options.dart';

class MyPledgedGiftsPage extends StatelessWidget {
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
          MySearchBar(),                      // Reusable Search Bar widget
          const SizedBox(height: 10),
          SortOptions(),                    // Reusable Sorting widget
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 3,                   // Replace with dynamic data length
              itemBuilder: (context, index) {
                return GiftCard(
                  recipientName: "Ahmed",
                  recipientImage: "assets/images/profile_placeholder.png",
                  location: "Cairo, Egypt",
                  date: "24 / 10 / 2024",
                  time: "8:00 PM",
                  giftName: "iPhone 16",
                  category: "Appliances",
                  status: "Pending",
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
