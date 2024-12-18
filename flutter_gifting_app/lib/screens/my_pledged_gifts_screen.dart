import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../components/gift_card.dart';
import '../components/search_bar.dart';
import '../components/sort_options.dart';

import '../utils/user_manager.dart';

import '../models/gift.dart';

import '../controllers/controller_my_pledged_gifts_screen.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  late MyPledgedGiftsController _controller;
  late Future<void> _loadGiftsFuture;

  @override
  void initState() {
    super.initState();
    _controller = MyPledgedGiftsController(onGiftsUpdated: _refreshView);
    _loadGiftsFuture = _controller.loadGifts();
  }

  // Trigger a state update when notified by the controller
  void _refreshView() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: FutureBuilder<void>(
        future: _loadGiftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading gifts"));
          }

          return Column(
            children: [
              MySearchBar(controller: _controller.searchController),
              const SizedBox(height: 10),
              SortOptions(
                selectedSort: _controller.selectedSort,
                onSortSelected: (sort) {
                  _controller.updateSort(sort);
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _controller.filteredGifts.isEmpty
                    ? Center(child: Text("No gifts found"))
                    : ListView.builder(
                        itemCount: _controller.filteredGifts.length,
                        itemBuilder: (context, index) {
                          final gift = _controller.filteredGifts[index];
                          return GiftCard(
                            gift: gift,
                            callback: () async {
                              await _controller.loadGifts();
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
