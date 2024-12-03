import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService {
  static Future<void> sendFriendRequest(String userId, String friendEmail) async {
    final users = FirebaseFirestore.instance.collection('users');

    // Get friend's user ID by email
    final friendSnapshot = await users.where('email', isEqualTo: friendEmail).get();
    if (friendSnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    final friendId = friendSnapshot.docs.first.id;

    // Get the current user's name and email
    final userSnapshot = await users.doc(userId).get();
    if (!userSnapshot.exists) {
      throw Exception('Current user not found');
    }

    final userData = userSnapshot.data();
    final userName = userData?['name'] ?? 'Unknown';
    final userEmail = userData?['email'] ?? 'Unknown';

    // Add request to friend's "friend_requests" sub-collection
    await users.doc(friendId).collection('friend_requests').doc(userId).set({
      'requested_by': userId,
      'name': userName,
      'email': userEmail,
      'requested_at': Timestamp.now(),
    });
  }
}
