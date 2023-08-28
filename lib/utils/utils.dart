import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

/// creates a sized box with height of 64
const sizeBoxH64 = SizedBox(height: 64);

/// creates a sized box with height of 36
const sizeBoxH36 = SizedBox(height: 36);

/// creates a sized box with height of 24
const sizeBoxH24 = SizedBox(height: 24);

/// creates a sized box with height of 12
const sizeBoxH12 = SizedBox(height: 12);

/// creates a sized box with height of 12
const sizeBoxH6 = SizedBox(height: 6);

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 750),
    ),
  );
}

getBytesFromAsset(AssetEntity asset) async {
  return await asset.thumbnailData;
}
