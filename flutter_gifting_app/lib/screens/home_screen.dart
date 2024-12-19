import 'package:flutter/material.dart';

import '../components/add_friend_modal.dart';
import '../components/sort_options.dart'; 
import '../components/friend_card.dart';

import '../controllers/controller_home_screen.dart';

import '../models/user.dart';

import '../utils/user_manager.dart';
import 'event_creation_screen.dart';

class HomeScreenView extends StatefulWidget {
  final String userId = UserManager.currentUserId ?? '';
  

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(onUpdate: () {
      setState(() {});
    });
    _controller.init();
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
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Hediety',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'فن اختيار الهدايا',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventCreationScreen(userId: widget.userId),
                      ),
                    ),
                  icon: Icon(Icons.add),
                  label: Text('Add Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_controller.friendRequests.isNotEmpty) ...[
              Text(
                'Friend Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ..._controller.friendRequests.map((request) => Card(
                    child: ListTile(
                      title: Text(request['name'] ?? 'Unknown'),
                      subtitle: Text(request['email'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _controller.acceptFriendRequest(
                          request['id'],
                          request['requested_by'],
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 16),
            ],
            Text(
              'Friends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller.searchController,
              decoration: InputDecoration(
                labelText: 'Search friends',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8),
            SortOptions(
              selectedSort: _controller.selectedSort,
              onSortSelected: (sort) {
                _controller.updateSortOption(sort);
              },
            ),
            SizedBox(height: 8),
            Expanded(
              child: _controller.filteredFriends.isEmpty
                  ? Center(child: Text('No friends found'))
                  : ListView.builder(
                      itemCount: _controller.filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = _controller.filteredFriends[index];
                        return FriendCard(user: friend);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                AddFriendModal(userId: widget.userId),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.person_add),
      ),
    );
  }
}