import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
  /// Requests permission to access the gallery.
  static Future<bool> requestGalleryPermission() async {
    var status = await Permission.photos.request();
    return status.isGranted;
    
  }

  /// Picks an image from the gallery.
  static Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Saves the image locally in the app's writable directory.
  /// Returns the saved image's file path.
  static Future<String?> saveImageLocally(File image, String userId) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String imageFileName = '${userId}_profile.png';
      String savePath = '${appDir.path}/$imageFileName';

      File savedImage = await image.copy(savePath);
      return savedImage.path;
    } catch (e) {
      print("Error saving image locally: $e");
      return null;
    }
  }
}
