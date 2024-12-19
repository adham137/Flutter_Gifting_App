import 'package:flutter/material.dart';
import 'package:flutter_gifting_app/components/action_button.dart';

import '../components/add_friend_modal.dart';
import '../components/sort_options.dart';
import '../components/friend_card.dart';

import '../controllers/controller_home_screen.dart';

import '../models/user.dart';

import '../utils/user_manager.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
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
        backgroundColor: AppColors.teal,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Column(
            children: [
              Text(
                'Hediety',
                style: AppFonts.t1,
                
              ),
              Text(
                'فن اختيار الهدايا',
                style: AppFonts.t2,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create Event Section
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.babyBlue,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 5,
                    color: Colors.black12,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create \n Event',
                    style: AppFonts.t3,
                  ),
                  ActionButton(
                    color: AppColors.purple,
                    text: 'Add Event',
                    textStyle: AppFonts.button,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventCreationScreen(userId: widget.userId),
                      ),
                    ),
                    icon: Icon(Icons.add, color:Colors.yellowAccent, size: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Friend Requests Section
            if (_controller.friendRequests.isNotEmpty) ...[
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.babyBlue,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Friend Requests',
                      style: AppFonts.t3,
                    ),
                    SizedBox(height: 8),
                    ..._controller.friendRequests.map(
                      (request) => Card(
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
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
            // Friends Section
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.babyBlue,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Friends',
                      style: AppFonts.t3,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _controller.searchController,
                      decoration: InputDecoration(
                        labelText: 'Search friends',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    // SortOptions(
                    //   selectedSort: _controller.selectedSort,
                    //   onSortSelected: (sort) {
                    //     _controller.updateSortOption(sort);
                    //   },
                    // ),
                    SizedBox(height: 8),
                    Expanded(
                      child: _controller.filteredFriends.isEmpty
                          ? Center(child: Text('No friends found'))
                          : ListView.builder(
                              itemCount: _controller.filteredFriends.length,
                              itemBuilder: (context, index) {
                                final friend =
                                    _controller.filteredFriends[index];
                                return FriendCard(user: friend);
                              },
                            ),
                    ),
                  ],
                ),
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
        backgroundColor: AppColors.purple,
        child: Icon(Icons.person_add, color: AppColors.yellow,),
        
      ),
      // floatingActionButton: ActionButton(
      //   color: AppColors.purple, 
      //   text: 'Add Friend', 
      //   textStyle: AppFonts.button, 
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AddFriendModal(userId: widget.userId),
      //     );
      //   },
      //   icon: Icon(Icons.person_add, color: AppColors.teal, size: 25,),
      // )
      
    );
  }
}
