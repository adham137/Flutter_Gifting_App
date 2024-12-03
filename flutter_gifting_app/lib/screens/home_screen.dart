import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/add_friend_modal.dart';
import '../components/friend_card.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> friends = [];
  List<Map<String, dynamic>> friendRequests = [];
  List<UserModel> filteredFriends = []; // For search functionality
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _loadFriendRequests();

    // Initialize filtered friends with the full list
    searchController.addListener(() {
      _filterFriends();
    });
  }

  Future<void> _loadFriends() async {
    final user = await UserModel.getUser(widget.userId);
    if (user != null) {
      final friendDocs = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: user.friends)
          .get();
      setState(() {
        friends = friendDocs.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
        filteredFriends = friends; // Set initial filtered friends
      });
    }
  }

  Future<void> _loadFriendRequests() async {
    final requestDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('friend_requests')
        .get();
    setState(() {
      friendRequests = requestDocs.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  Future<void> _acceptFriendRequest(String requestId, String friendId) async {
    final currentUser = await UserModel.getUser(widget.userId);
    final friend = await UserModel.getUser(friendId);

    if (currentUser != null && friend != null) {
      // Add each other's IDs to the friends list
      await UserModel.updateUser(currentUser.userId, {
        'friends': FieldValue.arrayUnion([friend.userId])
      });
      await UserModel.updateUser(friend.userId, {
        'friends': FieldValue.arrayUnion([currentUser.userId])
      });

      // Remove the friend request
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('friend_requests')
          .doc(requestId)
          .delete();

      // Reload data
      await _loadFriends();
      await _loadFriendRequests();
    }
  }

  void _filterFriends() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.name.toLowerCase().contains(query))
          .toList();
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
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text('Add Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Friend Requests Section
            if (friendRequests.isNotEmpty) ...[
              Text(
                'Friend Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...friendRequests.map((request) => Card(
                    child: ListTile(
                      title: Text(request['name'] ?? 'Unknown'),
                      subtitle: Text(request['email'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _acceptFriendRequest(request['id'], request['requested_by']),
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
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search friends',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: filteredFriends.isEmpty
                  ? Center(child: Text('No friends found'))
                  : ListView.builder(
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = filteredFriends[index];
                        return FriendCard(
                          name: friend.name,
                          eventCount: 0, // Replace with dynamic event count if available
                        );
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
            builder: (context) => AddFriendModal(userId: widget.userId),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.person_add),
      ),
    );
  }
}
