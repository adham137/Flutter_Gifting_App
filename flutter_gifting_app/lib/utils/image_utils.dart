import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart'; 

class ImageUtils {
  /// Requests permission to access the gallery and external storage.
static Future<bool> requestGalleryPermission() async {
    var statusGallery = await Permission.photos.status;
    var statusStorage = await Permission.storage.status;

    if (!statusGallery.isGranted) {
      statusGallery = await Permission.photos.request();
    }

    if (!statusStorage.isGranted) {
      statusStorage = await Permission.storage.request();
    }

    if (statusGallery.isGranted && statusStorage.isGranted) {
      return true;
    } else {
      // Provide feedback to the user
      if (statusGallery.isDenied) {
        print("Gallery permission denied.");
      }
      if (statusStorage.isDenied) {
        print("Storage permission denied.");
        // Optionally, you can prompt the user to open settings
        openAppSettings();
      }
      return false;
    }
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

/// Saves the image in an external shared directory accessible by all emulators.
  /// Returns the **absolute path** of the saved image.
  static Future<String?> saveImageWithFullPath(File image, String userId) async {
    try {
      // Specify the target path for saving images in external storage
      // This path is where shared images will be stored
      String targetPath = '/storage/emulated/0/Images';

      // Create the directory if it doesn't exist
      Directory imagesDir = Directory(targetPath);
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Create a unique file name for the image
      String imageFileName = '${Uuid().v4()}.png';
      String savePath = '${imagesDir.path}/$imageFileName';

      // Save the image to the specified path
      File savedImage = await image.copy(savePath);
      return savedImage.absolute.path; // Return the absolute path
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
  }
}