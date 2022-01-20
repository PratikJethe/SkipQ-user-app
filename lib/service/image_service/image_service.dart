import 'dart:io';

import 'package:booktokenapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage(ImageSource imageSource) async {
    XFile? image = await _picker.pickImage(source: imageSource);
    return image;
  }

  static Future<File?> cropFile(XFile xfile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: xfile.path,
        compressQuality: 40,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: R.color.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    return croppedFile;
  }

  static Future<File?> updateProfilePic(ImageSource imageSource) async {
    XFile? image = await pickImage(imageSource);
    if (image != null) {
      File? croppedImage = await cropFile(image);
      return croppedImage;
    }
  }
}
