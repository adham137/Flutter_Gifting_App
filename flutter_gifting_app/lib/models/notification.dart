import 'package:cloud_firestore/cloud_firestore.dart';
class NotificationModel {
  String notificationId;
  String userId; // The recipient user ID
  String title;
  String message;
  bool isRead;
  Timestamp createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  // Convert Firestore document to NotificationModel
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: doc.id,
      userId: data['user_id'],
      title: data['title'],
      message: data['message'],
      isRead: data['is_read'],
      createdAt: data['created_at'],
    );
  }

  // Convert NotificationModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }

  // CRUD Methods
  static Future<void> createNotification(NotificationModel notification) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notification.notificationId)
        .set(notification.toFirestore());
  }

  static Future<List<NotificationModel>> getNotificationsByUser(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
  }

  static Future<void> markAsRead(String notificationId) async {
    await FirebaseFirestore.instance.collection('notifications').doc(notificationId).update({'is_read': true});
  }

  static Future<void> deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance.collection('notifications').doc(notificationId).delete();
  }
}
