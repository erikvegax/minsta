import 'package:flutter/material.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return loading;
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
