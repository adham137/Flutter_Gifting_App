
import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/image_utils.dart';
import '../utils/user_manager.dart';

class ImageHandler extends StatefulWidget {
  final double radius;
  final String defaultImagePath;
  final bool isEditable;
  String? imagePath;
  final Function(String)? onImageUpdate; // Callback to handle image updates

  ImageHandler({
    Key? key,
    required this.radius,
    required this.defaultImagePath,
    required this.isEditable,
    required this.imagePath,
    this.onImageUpdate,
  }) : super(key: key);

  @override
  _ImageHandlerState createState() => _ImageHandlerState();
}

class _ImageHandlerState extends State<ImageHandler> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFile();
  }

  void _loadImageFile() {
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      try {
        _imageFile = File(widget.imagePath!);
        if (!_imageFile!.existsSync()) {
          _imageFile = null; // Reset if the file does not exist
        }
      } catch (e) {
        print("Error loading image file: $e");
        _imageFile = null; // Handle exception gracefully
      }
    }
  }

  Future<void> _pickAndSaveImage() async {
    if (!widget.isEditable) return;

    // Request gallery permissions
    bool hasPermission = await ImageUtils.requestGalleryPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gallery permission denied!')),
      );
      return;
    }

    // Pick the image
    File? selectedImage = await ImageUtils.pickImageFromGallery();
    if (selectedImage != null) {
      try {
        // Save the image locally and update the full path
        String? savedFullPath = await ImageUtils.saveImageWithFullPath(
          selectedImage,
          UserManager.currentUserId!,
        );
        print("########################################## Saved image full path: $savedFullPath");

        if (savedFullPath != null) {
          setState(() {
            _imageFile = File(savedFullPath);
          });

          // Notify the parent widget of the updated path
          if (widget.onImageUpdate != null) {
            widget.onImageUpdate!(savedFullPath);
          }
        }
      } catch (e) {
        print("Error saving image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickAndSaveImage,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : AssetImage(widget.defaultImagePath) as ImageProvider,
        child: widget.isEditable && _imageFile == null
            ? Icon(Icons.add_a_photo, size: widget.radius / 2, color: Colors.white)
            : null,
      ),
    );
  }
}