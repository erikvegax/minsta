import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minsta/screens/add_post_description_screen.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/utils/utils.dart';
import 'package:minsta/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostPickImageScreen extends StatefulWidget {
  const AddPostPickImageScreen({super.key});

  @override
  State<AddPostPickImageScreen> createState() => _AddPostPickImageScreenState();
}

class _AddPostPickImageScreenState extends State<AddPostPickImageScreen> {
  Uint8List? _file;
  Uint8List? firstAsset;
  List<AssetEntity> assets = [];

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    setState(() => assets = recentAssets);

    recentAssets[0].originBytes.then(
          (value) => setState(
            () {
              firstAsset = value!;
            },
          ),
        );
  }

  pickImage(AssetEntity asset) {
    asset.originBytes.then(
      (value) => setState(() {
        _file = value!;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAssets();
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

    return firstAsset == null
        ? loading
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: mobileBackgroundColor,
                title: const Text("pick image"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPostDescriptionScreen(file: _file!),
                          ),
                        )
                        .then(
                          (value) => setState(
                            () {
                              clear();
                            },
                          ),
                        ),
                    child: const Text(
                      "next",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.97,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: _file == null
                      ? Image.memory(firstAsset!, fit: BoxFit.cover)
                      : Image.memory(_file!, fit: BoxFit.cover),
                ),
                sizeBoxH6,
                FutureBuilder(
                  future: null,
                  initialData: assets,
                  builder: (context, snapshot) {
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
                        return InkWell(
                          onTap: () => pickImage(assets[index]),
                          child: AssetThumbnail(asset: assets[index]),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }
}
