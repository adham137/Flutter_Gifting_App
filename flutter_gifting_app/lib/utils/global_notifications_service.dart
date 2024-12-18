import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import '../main.dart';

class FCMService {
  final Map<String, dynamic> serviceAccountJson;
  final String projectId = 'hediety-3d6a8';

  FCMService({required this.serviceAccountJson});

  /// Initialize FCMService by loading credentials from the asset bundle
  static Future<FCMService> initialize() async {
    final String jsonString = await rootBundle.loadString(
      'keys/hediety-3d6a8-firebase-adminsdk-qdopa-cb2841403c.json',
    );

    final jsonData = json.decode(jsonString);

    // Add Listener to the notifications, activated when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onNotificationRecieved(message);
    });


    return FCMService(serviceAccountJson: jsonData);
  }

  /// Step 1: Authenticate with Google APIs to get OAuth2 access token
  Future<String> _getAccessToken() async {
    try {
      final accountCredentials = ServiceAccountCredentials.fromJson(
        serviceAccountJson,
      );

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(accountCredentials, scopes);
      final accessToken = client.credentials.accessToken.data;

      client.close();
      return accessToken;
    } catch (e) {
      print('Error getting access token: $e');
      rethrow;
    }
  }

  /// Step 2: Send a push notification to a specific FCM token
  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    print('#################### Trying to get access token');
    final accessToken = await _getAccessToken();
    print('#################### Got access token');
    final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final Map<String, dynamic> payload = {
      "message": {
        "token": fcmToken,
        "notification": {
          "title": title,
          "body": body,
        },
        if (data != null) "data": data,
      }
    };

    print('#################### About to send the request');
    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );
      print('#################### Sending');
      if (response.statusCode == 200) {
        print('Notification sent successfully: ${response.body}');
      } else {
        print('Error sending notification: ${response.body}');
      }
    } catch (e) {
      print('Error while sending notification: $e');
      rethrow;
    }
  }

  static void onNotificationRecieved(RemoteMessage message) {
    // Extract notification data
    String title = message.notification?.title ?? "";
    String body = message.notification?.body ?? "";
    String giftId = message.data?['giftId'] ?? "";
    String status = message.data?['status'] ?? "";
    print('#################### Received notification: $title - $body - $giftId - $status');

    // Update local database (either by pulling data from firestore or from the notification payload)

    // Notify the user by sending an in-app notification
    showInAppNotification(title, body);
  }


static void showInAppNotification(String title, String body) {
  OverlayEntry? overlayEntry; // Keep it nullable here for initial assignment

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(body),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      overlayEntry?.remove(); // Safe call
                      overlayEntry = null;    // Very important!
                    },
                    child: const Text('Dismiss'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  navigatorKey.currentState?.overlay?.insert(overlayEntry!); // Use ! here because we just assigned it

  Future.delayed(const Duration(seconds: 5), () {
    if (overlayEntry != null) { // Check for null before removing
      overlayEntry!.remove();   // Use ! here because we checked for null
      overlayEntry = null;      // Very important!
    }
  });
}


}
