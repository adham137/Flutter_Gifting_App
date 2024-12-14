// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user.dart';

// import '../utils/user_manager.dart ';

// class ProfileController {
//   // Future<void> fetchUserData() async {
//   //   try {
//   //     final user = await UserModel.getUser(UserManager.currentUserId!);
//   //     setState(() {
//   //       currentUser = user;
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Failed to load user data: $e')),
//   //     );
//   //   }
//   // }
//     static Future<(UserModel?, bool?)> fetchUserData() async {
//     try {
//       final user = await UserModel.getUser(UserManager.currentUserId!);
//       return (user, false);

//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load user data: $e')),
//       );
//     }
//   }

//   Future<void> updateUserField(String userId, String field, dynamic value) async {
//     try {
//       await UserModel.updateUser(userId, {field: value});
//     } catch (e) {
//       throw Exception('Failed to update $field: $e');
//     }
//   }
//     void _updateUserField(String field, dynamic value) async {
//     try {
//       await UserModel.updateUser(UserManager.currentUserId!, {field: value});
//       setState(() {
//         if (field == 'name') currentUser!.name = value;
//         if (field == 'email') currentUser!.email = value;
//         if (field == 'phone_number') currentUser!.phoneNumber = value;
//         if (field == 'push_notifications') currentUser!.pushNotifications = value;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update $field: $e')),
//       );
//     }
//   }
//   void _signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         '/sign-in',
//         (route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }
// }
