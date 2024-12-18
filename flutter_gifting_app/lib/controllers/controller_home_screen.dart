import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/user_manager.dart';

class HomeController {
  final String userId = UserManager.currentUserId!;
  final Function onUpdate;

  List<UserModel> friends = [];
  List<Map<String, dynamic>> friendRequests = [];
  List<UserModel> filteredFriends = [];
  String? selectedSort;
  final TextEditingController searchController = TextEditingController();

  HomeController({required this.onUpdate});

  void init() {
    _loadFriends();
    _loadFriendRequests();

    searchController.addListener(() {
      _filterAndSortFriends();
    });
  }

  Future<void> _loadFriends() async {
    UserModel? user = await UserModel.getUser(UserManager.currentUserId!);
    if (user != null) {
      friends = await UserModel.getFriends(user.friends);
      filteredFriends = friends;
      onUpdate();
    }
  }

  Future<void> _loadFriendRequests() async {
    friendRequests = await UserModel.getFriendRequests(userId);
    onUpdate();
  }

  Future<void> acceptFriendRequest(String requestId, String friendId) async {
    await UserModel.acceptFriendRequest(userId, friendId, requestId);
    await _loadFriends();
    await _loadFriendRequests();
  }

  void _filterAndSortFriends() {
    final query = searchController.text.toLowerCase();
    filteredFriends = friends
        .where((friend) => friend.name.toLowerCase().contains(query))
        .toList();
    if (selectedSort != null) {
      _applySort();
    }
    onUpdate();
  }

  void updateSortOption(String? sort) {
    selectedSort = sort;
    _applySort();
    onUpdate();
  }

  void _applySort() {
    if (selectedSort == "Name") {
      filteredFriends.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void dispose() {
    searchController.dispose();
  }
}