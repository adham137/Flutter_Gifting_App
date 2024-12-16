import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

import '../components/gift_card.dart';
import '../components/search_bar.dart';
import '../components/sort_options.dart';

import '../utils/user_manager.dart';

import '../models/gift.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final TextEditingController searchController = TextEditingController();
  String? selectedSort;
  List<GiftModel> gifts = [];
  List<GiftModel> filteredGifts = [];
  late Future<void> loadGiftsFuture;

  @override
  void initState() {
    super.initState();
    loadGiftsFuture = _loadGifts();
    searchController.addListener(_filterAndSortGifts);
  }


  Future<void> _loadGifts() async {
    try {
      final fetchedGifts = await GiftModel.getMyPledgedGifts();
      setState(() {
        gifts = fetchedGifts;
        filteredGifts = List.from(gifts);
      });
    } catch (e) {
      print("Error loading gifts: $e");
    }
  }

  void _filterAndSortGifts() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredGifts = gifts.where((gift) {
        final name = gift.name.toLowerCase();
        final description = gift.description.toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();

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
      body: FutureBuilder<void>(
        future: loadGiftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading gifts"));
          }

          return Column(
            children: [
              MySearchBar(controller: searchController),
              const SizedBox(height: 10),
              SortOptions(
                selectedSort: selectedSort,
                onSortSelected: (sort) {
                  setState(() {
                    selectedSort = sort;
                    _filterAndSortGifts();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredGifts.isEmpty
                    ? Center(child: Text("No gifts found"))
                    : ListView.builder(
                        itemCount: filteredGifts.length,
                        itemBuilder: (context, index) {
                          final gift = filteredGifts[index];
                          return GiftCard(
                            gift: filteredGifts[index],
                            callback: _loadGifts,
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

