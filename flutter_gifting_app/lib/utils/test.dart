import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';


 Future<void> main() async {
  final serviceAccountPath = 'D:/ASU/sem 9/Mobile Programming/MAJOR_TASK/flutter_gifting_app/keys/hediety-3d6a8-firebase-adminsdk-qdopa-cb2841403c.json';
  final String projectId = 'hediety-3d6a8';

  final accountCredentials = ServiceAccountCredentials.fromJson(
    json.decode(await File(serviceAccountPath).readAsString()),
  );

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await clientViaServiceAccount(accountCredentials, scopes);
  final accessToken = client.credentials.accessToken.data;

  final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  final Map<String, dynamic> payload = {
  "message": {
    "token": 'ddYemAk0RlGJkVmGslofPy:APA91bHwgtwxcSJ_PPbgXaP1POptuCaWlhd8GQSPOyuQesnC44je7PPi6yVtf-h3n49g3DupRbpfMjz-WGVPzYRc5LLHzinYUViB56agaH8GgNeV4S8guhk',
    "notification": {
      "title": "Gift Pledged!",
      "body": "Your gift has been pledged by a friend."
    },
    "data": {
      "giftId": "12345",
      "status": "Pledged",
      "message": "Someone pledged your gift!"
    }
  }
};

  print('#################### about to send the request ');
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
