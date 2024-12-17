import '../models/user.dart';
import 'global_notifications_service.dart';
import 'local_notifications_service.dart';

class UserManager {
  static UserModel? currentUser;
  static String? currentUserId;
  static FCMService? fcmService;

  static void updateUserId(String? userId) async {
    currentUserId = userId;
    currentUser = await UserModel.getUser(userId!);
    LocalNotificationsService.uploadFcmToken(userId!);
  }
  static void updateFCMService(FCMService fcms) {
    fcmService = fcms;
  }
}
