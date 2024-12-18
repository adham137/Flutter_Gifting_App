import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  String? phoneNumber;
  String? profilePictureUrl;
  Timestamp createdAt;
  List<String> friends;
  bool pushNotifications;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    required this.createdAt,
    required this.friends,
    required this.pushNotifications,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phone_number'],
      profilePictureUrl: data['profile_picture_url'],
      createdAt: data['created_at'],
      friends: List<String>.from(data['friends']),
      pushNotifications: data['push_notifications'],
    );
  }

  // Convert UserModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture_url': profilePictureUrl,
      'created_at': createdAt,
      'friends': friends,
      'push_notifications': pushNotifications,
    };
  }

  // CRUD Methods
  static Future<void> createUser(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.userId).set(user.toFirestore());
  }

  static Future<UserModel?> getUser(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update(data);
  }

  static Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
static Future<String?> getFcmToken(String userId) async {
  try {
    // Fetch the user document from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // Check if the document exists and contains the 'fcm_token' field
    if (userDoc.exists) {
      final data = userDoc.data();
      final fcmToken = data?['fcm_token'];

      if (fcmToken != null) {
        print('FCM Token retrieved: $fcmToken');
        return fcmToken;
      } else {
        print('No FCM token found for user: $userId');
        return null;
      }
    } else {
      print('User document does not exist for userId: $userId');
      return null;
    }
  } catch (e) {
    print('Error getting FCM token: $e');
    return null;
  }
}

  /// Fetch friends by their IDs
  static Future<List<UserModel>> getFriends(List<String> friendIds) async {
    try {
      if (friendIds.isEmpty) return [];

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  /// Fetch friend requests for the user
  static Future<List<Map<String, dynamic>>> getFriendRequests(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('recipient', isEqualTo: userId)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'requested_by': data['requested_by'],
          'name': data['name'],
          'email': data['email'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching friend requests: $e');
      return [];
    }
  }

  /// Accept a friend request
  static Future<void> acceptFriendRequest(
      String userId, String friendId, String requestId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Add friend to the user's friend list
      final userDoc = firestore.collection('users').doc(userId);
      await userDoc.update({
        'friends': FieldValue.arrayUnion([friendId]),
      });

      // Add user to the friend's friend list
      final friendDoc = firestore.collection('users').doc(friendId);
      await friendDoc.update({
        'friends': FieldValue.arrayUnion([userId]),
      });

      // Delete the friend request
      await firestore.collection('friend_requests').doc(requestId).delete();
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

    static Future<void> sendFriendRequest(String userId, String friendEmail) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Get friend's user document by email
      final friendQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();

      if (friendQuery.docs.isEmpty) {
        throw Exception('User with email $friendEmail not found.');
      }

      final friendDoc = friendQuery.docs.first;
      final friendId = friendDoc.id;

      // Ensure the sender's data exists
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('Current user not found.');
      }

      final userData = userDoc.data()!;
      final userName = userData['name'] ?? 'Unknown';
      final userEmail = userData['email'] ?? 'Unknown';

      // Add request to the friend's "friend_requests" collection
      await firestore
          .collection('friend_requests')
          .doc('${friendId}_$userId') // Unique ID for the request
          .set({
        'requested_by': userId,
        'recipient': friendId,
        'name': userName,
        'email': userEmail,
        'requested_at': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending friend request: $e');
      rethrow;
    }
  }


}
