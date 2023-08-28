import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:minsta/models/user.dart';
import 'package:minsta/providers/user_provider.dart';
import 'package:minsta/resources/auth_methods.dart';
import 'package:minsta/resources/firestore_methods.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostDescriptionScreen extends StatefulWidget {
  final Uint8List file;
  const AddPostDescriptionScreen({Key? key, required this.file})
      : super(key: key);

  @override
  State<AddPostDescriptionScreen> createState() =>
      _AddPostDescriptionScreenState();
}

class _AddPostDescriptionScreenState extends State<AddPostDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clear() {
    setState(() {
      _descriptionController.clear();

      // if a newly signed in user will it pop to the sign in screen?
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void postImage(String uid, String profileImage, String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        uid,
        username,
        profileImage,
        widget.file,
      );

      if (res == success) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("posted!", context);
        clear();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _isLoading
        ? loading
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: mobileBackgroundColor,
                title: const Text("description"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.photoUrl, user.username),
                    child: const Text(
                      "post",
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
                  child: Image.memory(widget.file, fit: BoxFit.cover),
                ),
                sizeBoxH6,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "write a few words...",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ],
            ),
          );
  }
}
