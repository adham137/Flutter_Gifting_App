import 'package:firebase_auth/firebase_auth.dart';
import '../utils/user_manager.dart';
import '../utils/local_database_controller.dart';

class SignInController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Validate email format
  String? validateEmail(String email) {
    print('Email: $email');
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Enter a valid email'; // Corrected logic here
    }
    return null; // Valid email
  }

  // Validate password length
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Perform sign-in and handle user-related updates
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserManager.updateUserId(user.uid); // Update the global user ID
        await DatabaseController.syncFirestoreDataToLocal(user.uid);  // Fetch data from firestore and sync local storage
      }

      return null; // Sign-in successful, no errors
    } catch (e) {
      return 'Error: ${e.toString()}'; // Return error message
    }
  }
}
