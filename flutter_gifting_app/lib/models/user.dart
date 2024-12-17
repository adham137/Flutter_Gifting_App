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

}
