import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'global_colors.dart';

Future<File> cropImage(
      PickedFile imageFile, CropAspectRatioPreset ratio) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [ratio],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(primary),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Color(primary),
            initAspectRatio: ratio,
            lockAspectRatio: true,
            hideBottomControls: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    return croppedFile;
  }