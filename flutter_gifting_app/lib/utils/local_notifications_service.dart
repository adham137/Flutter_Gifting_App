

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/user.dart';

class LocalNotificationsService {

  final firebaseFirestore = FirebaseFirestore.instance;


  Future<void> requestPermission() async {
    // Request permission to display notifications
    PermissionStatus status = await Permission.notification.request();
    if(status != PermissionStatus.granted) {
      throw Exception('Notification permission not granted');
    }
  }

  static Future<void> uploadFcmToken(String currentUserId) async {

    try {
      await FirebaseMessaging.instance.getToken().then((fcmToken) async {
        await UserModel.updateUser(currentUserId, {
          'fcm_token': fcmToken
        });
        print('########################################################MY FCM TOKEN: {$fcmToken}');

      });

      await FirebaseMessaging.instance.onTokenRefresh.listen((token) async {

        await UserModel.updateUser(currentUserId, {
          'fcm_token': token
        });
      });

    } catch (e) {
      print('#########################################################Error uploading FCM token: $e');
    }
  }

}