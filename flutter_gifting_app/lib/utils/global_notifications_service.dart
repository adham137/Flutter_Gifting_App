import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

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

}
