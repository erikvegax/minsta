import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostPickImageScreen extends StatefulWidget {
  const AddPostPickImageScreen({super.key});

  @override
  State<AddPostPickImageScreen> createState() => _AddPostPickImageScreenState();
}

class _AddPostPickImageScreenState extends State<AddPostPickImageScreen> {
  Uint8List? _file;
  List<AssetEntity> assets = [];
  late AssetEntity firstAsset;
  bool _isLoading = false;

  _fetchAssets() async {
    _isLoading = true;
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);

    setState(() {
      firstAsset = assets[0];
    });

    _isLoading = false;
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  void clear() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Container();
    }

    return _isLoading
        ? loading
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: clear,
                ),
                title: const Text("pick image"),
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () => {},
                      child: const Text(
                        "post",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ))
                ],
              ),
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.97,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: _file == null
                      ? AssetThumbnail(asset: firstAsset)
                      : AssetThumbnail(
                          asset:
                              firstAsset), // figuire out how to display chosen image
                ),
                const Divider(),
                FutureBuilder(
                  future: null,
                  initialData: assets,
                  builder: (context, snapshot) {
                    if (_isLoading) {
                      return loading;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                      ),
                      itemCount: assets.length,
                      itemBuilder: (_, index) {
                        return AssetThumbnail(asset: assets[index]);
                      },
                    );
                  },
                )
              ],
            ),
          );
  }
}
