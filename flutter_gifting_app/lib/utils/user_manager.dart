class UserManager {
  static String? currentUserId;

  static void updateUserId(String? userId) {
    currentUserId = userId;
  }
}
