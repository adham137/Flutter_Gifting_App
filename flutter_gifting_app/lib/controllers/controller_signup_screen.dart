import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/user_manager.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signUp(
    String name,
    String email,
    String phoneNumber,
    String password,
    String? profileImagePath,
    BuildContext context,
  ) async {
    // Validate input
    if (name.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
      return 'All fields must be filled';
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        UserModel user = UserModel(
          userId: firebaseUser.uid,
          name: name.trim(),
          email: email.trim(),
          phoneNumber: phoneNumber.trim(),
          profilePictureUrl: profileImagePath,
          createdAt: Timestamp.now(),
          friends: [],
          pushNotifications: false,
        );

        // Database access is encapsulated in the model
        await UserModel.createUser(user);
        UserManager.updateUserId(firebaseUser.uid); // Update the global user ID
        Navigator.pushNamedAndRemoveUntil(context, '/parent', (route) => false);

        return 'Account created successfully!';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    return null;
  }
}